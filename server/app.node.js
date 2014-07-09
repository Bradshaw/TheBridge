var _ = require("underscore");
var lazy = require("lazy.js");
var async = require("async");
var net = require("net");


var Connection = require("./Connection");
var Simulator = require("./sim/Simulator");

var sim = new Simulator(); 

var server = net.createServer(function (socket) {
    var conn = new Connection(socket);
    
    sim.addConnection(conn);
    
    conn.on("jump", function(data){
        sim.playerShip.x = data.x;
        sim.playerShip.y = data.y;
        sim.playerShip.stop();
        sim.playerShip.start();
    });
    
    conn.on("fire", function(data){
        sim.fire(data);
    });
    
    conn.on("debug", function(){
         sim.dump();
    });
});


server.listen(1337, '0.0.0.0');
console.log("Listening...");