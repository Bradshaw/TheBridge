var _ = require("underscore");
var lazy = require("lazy.js");
var async = require("async");
var useful = require("./useful");


function Ship(){
    this.x = Math.random()*800;
    this.y = Math.random()*600;
	this.mspt = 1000/100;
    this.ambiantTemperature = 20;
    this.gun  = {
        minRate: 0,
        maxRate: 1,
        curRate: 0,
        disRate: 0.001,
        minCool: 0.0002,
        maxCool: 0.0025,
        curCool: 0,
        charge: 0,
        chargeHeat: 0.0002,
        temperature: this.ambiantTemperature
    };
}

Ship.prototype.tick = function() {
    
    // Tick gun
    this.gun.charge = this.gun.charge - this.gun.charge*this.gun.disRate*useful.jitter();
    this.gun.charge = this.gun.charge + useful.lerp(this.gun.minRate, this.gun.maxRate, this.gun.curRate)*useful.jitter();
    this.gun.temperature = this.gun.temperature - (this.gun.temperature - this.ambiantTemperature)*useful.lerp(this.gun.minCool, this.gun.maxCool, this.gun.curCool)*useful.jitter();
    this.gun.temperature = this.gun.temperature + this.gun.charge * this.gun.chargeHeat*useful.jitter();
    
};

Ship.prototype.start = function() {
	this.interval = setInterval(this.tick.bind(this), this.mspt);
};

Ship.prototype.stop = function() {
	if (this.interval){
		clearInterval(this.interval);
	}
};

Ship.prototype.fire = function(){
    
};


module.exports = Ship;