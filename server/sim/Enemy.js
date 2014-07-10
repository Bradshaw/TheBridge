var _ = require("underscore");
var lazy = require("lazy.js");
var async = require("async");
var useful = require("./../useful");
var Signature = require("./Signature");

function Enemy(sim){
	this.identifier = "Enemy";
    var coord = useful.getRandomCoordinates();
    this.x = coord.x;
    this.y = coord.y;
    this.signature = new Signature(3000+Math.random()*5000, 3000, 50);
    this.destructible = true;
    this.sim = sim;
}

module.exports = Enemy;
