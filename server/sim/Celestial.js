var _ = require("underscore");
var lazy = require("lazy.js");
var async = require("async");
var useful = require("./../useful");
var Signature = require("./Signature");

function Celestial(sim){
	this.identifier = "Celestial";
    var coord = useful.getRandomCoordinates();
    this.x = coord.x;
    this.y = coord.y;
    this.signature = new Signature(Math.pow((Math.random(),4)*5000), 5000+Math.random()*10000, 5000);
    this.sim = sim;
}

module.exports = Celestial;