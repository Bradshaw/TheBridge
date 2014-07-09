var _ = require("underscore");
var lazy = require("lazy.js");
var async = require("async");
var net = require("net");


var Connection = require("./Connection");
var Ship = require("./Ship");

var theKatana = new Ship();

function distance(o1, o2){
    var dx = o2.x-o1.x;
    var dy = o2.y-o1.y;
    return Math.sqrt(dx*dx+dy*dy);
}

function angle(o1, o2){
    var dx = o2.x-o1.x;
    var dy = o2.y-o1.y;
    return Math.atan2(dy, dx);
}


var server = net.createServer(function (socket) {
    var conn = new Connection(socket);

    var thing = {
        x: Math.random()*800,
        y: Math.random()*600
    };
    
    sensorInterval = setInterval(function(){        
        var sensorData = {"sensors":[
            {
                "name": "ship",
                "x" : theKatana.x,
                "y" : theKatana.y,
                "readings":
                [
                    {
                        "name": "em",
                        "method": "range",
                        "value": distance(theKatana, thing)
                    },
                    {
                        "name": "gr",
                        "method": "direction",
                        "value": angle(theKatana, thing)
                    },
                    {
                        "name": "th",
                        "method": "range",
                        "value": distance(theKatana, thing)
                    },
                    {
                        "name": "th",
                        "method": "direction",
                        "value": angle(theKatana, thing)
                    }
                    
                ]
            }
        ]};
        conn.send(sensorData);
    }, 1000);
    
    conn.socket.on('close', function(){
       clearInterval(sensorInterval); 
    });
    
    conn.on("fire", function(data){
        
    });
});


server.listen(1337, '0.0.0.0');
console.log("Listening...");