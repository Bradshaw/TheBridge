var _ = require("underscore");
var lazy = require("lazy.js");
var async = require("async");
var useful = require("./../useful");
var Signature = require("./Signature");
var Sensor = require("./Sensor");

function Drone(sim,x,y){
	this.identifier = "Drone";
    this.id = useful.guid();
    this.x = x;
    this.y = y;
    this.sim = sim;
    this.signature = new Signature(0, 0, 0);	
    this.sensor = new Sensor(this.sim, this);
    this.sensor.start();
    this.destructible = true;
}

module.exports = Drone;