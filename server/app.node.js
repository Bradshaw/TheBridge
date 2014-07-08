var _ = require("underscore");
var lazy = require("lazy.js");
var async = require("async");
var net = require("net");


var Connection = require("./Connection");
var ship = require("./Ship");




var server = net.createServer(function (socket) {
    var conn = new Connection(socket);

    //map size
    var tailleMapX = 1000;
    var tailleMapY = 1000;

    //random ship and object position
    var shipX = Math.floor(Math.random() * tailleMapX) + 1;
    var shipY = Math.floor(Math.random() * tailleMapY) + 1;

    var objX = Math.floor(Math.random() * tailleMapX) + 1;
    var objY = Math.floor(Math.random() * tailleMapY) + 1;


    //calcul de la distance et de l'angle
    var dist = Math.sqrt( Math.pow(objX - shipX, 2) + Math.pow(objY - shipY, 2));
    var angle = Math.atan2(objY - shipY, objX - shipX);

    var thPortee = 10;

    var tha, thd;
    if(dist > thPortee){
    	tha = thd = "";
    }
    else{
    	tha = angle;
    	thd = dist;
    }
    
    conn.on("sensors", function(data){
        var sensorData = //{ "sensors": "dvcdvdvd"};//*/
		{
			"sensors": 
			[
				
				{
					"name" : "ship",
					"x": shipX,
					"y": shipY,
					"readings": 
					[
						{
							"em": dist
						},
						{	
							"tha": tha,
							"thd": thd
						},
						{
							"gr": angle
						}

					]
	
				}		
			]
		};//*/
        conn.send(sensorData);
    });
    
    conn.on("fire", function(data){
        
    });
    
});


server.listen(1337, '0.0.0.0');
console.log("Listening...");