var _ = require("underscore");
var lazy = require("lazy.js");
var async = require("async");
var net = require("net");


var Connection = require("./Connection");
var Ship = require("./Ship");


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

var theKatana = new Ship();



var server = net.createServer(function (socket) {
    var conn = new Connection(socket);
    
    conn.on("fire", function(data){
        
    });
});


server.listen(1337, '0.0.0.0');
console.log("Listening...");