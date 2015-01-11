var argv = require('optimist').argv;
var async = require('async')

var https = require('https');
var fs = require('fs');

var fs_extra = require('fs.extra');

var flickr_api_raw = require('./flickr_api_raw.js');    

flickr_api_raw_obj = flickr_api_raw(
                    '73b62d34e0bedf5213c965fea98df862', 
                    'a3c99ff0bcc4d6af')        

var word = argv.w;
var init_count   = argv.i;
var sorted_count = argv.s;

/*var Flickr = require('flickrapi');

var flickr = new Flickr({
  api_key: "73b62d34e0bedf5213c965fea98df862"
});



flickr.photos.search({
  text: "red+panda"
}, function(err, result) {
  if(err) { throw new Error(err); }
  // do something with result
  
  console.log('--------------- result ---------------');
  console.log(result);
  
});*/

var Flickr = require("node-flickr");

var keys = {"api_key": "73b62d34e0bedf5213c965fea98df862"};

flickr = new Flickr(keys);

var i = 0;

var get_photo_info = function(one_photo_data, __callback)
{
    
    var photo_id     = one_photo_data['id'];
    var photo_secret = one_photo_data['secret'];
    
    var args_array = { 
        'method' : 'flickr.photos.getInfo',
        'photo_id' : photo_id, 
        'photo_secret' : photo_secret, 
    };                                                                                                                       
                  
    flickr_api_raw_obj(args_array, function(err, response) {
        
        /*
        console.log('- response -');
        console.log(response);
        */
        __callback(false, response['photo']);
        
    });    
    
}

var download_image = function(src, __callback)
{
                   
    console.log(src);
                
    //__callback(false, true);                
                
    var file_name = src.split("/");
                
    file_name = file_name[file_name.length - 1];
           
    var file_name = i + '.jpg';
                
    i++;
                
    console.log('file_name:', file_name);
                           
    var file = fs.createWriteStream('./images/tmp/' + file_name);
    
    var request = https.get(src, function(response) {
        
        response.pipe(file);
                  
        __callback(false, file_name);
                  
    });       
}

var move_image = function(name, __callback)
{
    
    fs.rename('./images/tmp/' + name, './images/ready/' + name, function (err) {  
        
        __callback(false, name);
        
    });
    
}

flickr.get("photos.search", {"tags" : word, 
                             'per_page' : init_count, 
                             'page' : 0, 
                             'sort' : 'interestingness-desc', 
                            // lat  : '28.672438', 
                           //  lon  : '83.949979', 
                           //  radius : 20 
							}, 
                             function(result){
	
     
    //console.log(result);
    console.log('--------------- result ---------------');
    console.log(result.photos.perpage);
    
    //return false;
    
    var photos = result.photos.photo;
    
    console.log('photos length:', photos.length);
    /*
    for (var i = 0; i < photos.length; i++)
    {
        
        var photo = photos[i];
        
        console.log('------ photo --------', i);
        console.log(photo);
        
    }
    */
    
    async.map(photos, function(one_photo, __callback){
        
        get_photo_info(one_photo, function(err, full_data)
        {
            
            if (err)
            {
                console.log('---------------------');
                console.log(err);
            }
            
            //console.log('++++ full data ++++');
            //console.log(full_data);
            
            __callback(false, full_data);
            
        });
                
    }, function(err, photos){
        
        console.log('############# all info ###############');
        console.log(photos.length);
        
        var sorted_array = [];
        
        for (var i = 0; i < photos.length; i++)
        {
            
            //console.log(photos[i]['views']);
      
            var event = photos[i];
            var likes_length_event = parseInt(photos[i]['views']);
                    
            if (!sorted_array[0])
            {
                sorted_array[0] = event;
                continue;
            }
                    
            //console.log('i:', i, '--', sorted_array.length);
            //console.log(sorted_array);
                    
            var sorted_length = sorted_array.length;
                    
            var is_more = false;
                    
            for (var j = 0; j < sorted_length; j++)
            {
                  
                var likes_length_sorted = parseInt(sorted_array[j]['views']);
                
                        
                if (likes_length_event > likes_length_sorted)
                {
                    
                    //console.log(likes_length_event + ' :: ' + likes_length_sorted);
                    
                    sorted_array.splice(j, 0, event);
                            
                    is_more = true;
                            
                    break
                            
                }
                        
            }
                    
            if (!is_more)
            {
                sorted_array.push(event);
            }     
                        
        }
        
        console.log('------------------ sorted ------------------');
  
        sorted_array = sorted_array.slice(0, sorted_count);
        
        async.map(sorted_array, function(one_photo, __callback){
             
             /*
            console.log('-one_photo-');
            console.log(one_photo);          
              */   
                 
            var photo_id     = one_photo['id'];
            var photo_secret = one_photo['secret'];
            
            //console.log('download:', photo_id);
                
            var args_array = { 
                'method' : 'flickr.photos.getSizes',
                'photo_id' : photo_id, 
                'photo_secret' : photo_secret, 
            };                                                                                                                       
                          
            flickr_api_raw_obj(args_array, function(err, photo_sizes) {
                
                /*
                console.log('- response -');
                console.log(response);
                */
                
                var size = photo_sizes['sizes']['size'];
            
                console.log('>>>>>>>>>>>>>>>>>>>>>>>>>>.');
                                
                var src = size[3]['source'];
               
                console.log(src);    
              
                download_image(src, function(err, file_name)
                {
                    
                    move_image(file_name, __callback);
                    
                });
                
            }); 
                               
            
        }, function(err, photos){
            
            console.log('############# all download ###############');
            console.log('############# all download ###############');
            console.log('############# all download ###############');
            
        });
        
        
    });
    
    
    /*
    flickr.get("photos.search", {"tags":"cat,dogs"}, function(result){
        
        
    })
    
    flickr.photos.getSizes
    */
});
