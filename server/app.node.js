var _ = require("underscore");
var lazy = require("lazy.js");
var async = require("async");
var net = require("net");


var Connection = require("./Connection");
var Ship = require("./sim/Ship");


var theKatana = new Ship();

var server = net.createServer(function (socket) {
    var conn = new Connection(socket);
    
    
    
    conn.on("fire", function(data){
        
    });
});


server.listen(1337, '0.0.0.0');
console.log("Listening...");