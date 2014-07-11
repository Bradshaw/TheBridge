var _ = require("underscore");
var lazy = require("lazy.js");
var async = require("async");
var useful = require("./../useful");
var Signature = require("./Signature");

function Bomb(sim, x, y, dx, dy, range){
    this.identifier = "Bomb";
    this.x = x;
    this.y = y;
    this.origin = {x:x, y:y};
    this.range = range;
    this.dx = dx;
    this.dy = dy;
    this.signature = new Signature(0,0, 50000);
    this.destructible = true;
    this.sim = sim;
    this.interval = setInterval(this.tick.bind(this), 1000/100);
}

Bomb.prototype.tick = function(){
    this.x+=this.dx/100;
    this.y+=this.dy/100;
    if (useful.distance(this, this.origin)>=this.range)
        this.explode();
};

Bomb.prototype.explode = function(){
    clearInterval(this.interval);
    this.sim.explode(this.x, this.y, 100);
};



module.exports = Bomb;

