var _ = require("underscore");
var lazy = require("lazy.js");
var async = require("async");

var net = require("net");


var ship = require("./Ship");




var server = net.createServer(function (socket) {

});


server.listen(1337, '0.0.0.0');
console.log("Listening...");