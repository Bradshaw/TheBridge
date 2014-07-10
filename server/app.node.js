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
    conn.on("deployDrone", function(data){
        //()
    });

    conn.on("retrieveDrones", function(data){
        //()
    });

    conn.on("moveDrone", function(data){
        //(id, x, y)
    });

    conn.on("scanDrone", function(data){
        //(id, x, y)
    });

    conn.on("jump", function(data){
        //(x, y)
    });

    conn.on("fire", function(data){
        //(angle, speed, time)
    });

    conn.on("set", function(data){
        //(module, subsystem, value)
    });
});





server.listen(1337, '0.0.0.0');
console.log("Listening...");