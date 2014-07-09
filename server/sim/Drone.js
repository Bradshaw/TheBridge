var _ = require("underscore");
var lazy = require("lazy.js");
var async = require("async");
var useful = require("./../useful");
var Signature = require("./Signature");
var Sensor = require("./Sensor");

function Drone(sim){
    var coord = useful.getRandomCoordinates();
    this.x = coord.x;
    this.y = coord.y;
    this.sim = sim;
    this.signature = new Signature(50, 2, 25);
    this.sensor = new Sensor(this.sim, this);
    this.sensor.start();
    this.destructible = true;
}

module.exports = Drone;