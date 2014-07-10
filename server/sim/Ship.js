var _ = require("underscore");
var lazy = require("lazy.js");
var async = require("async");
var useful = require("./../useful");
var Signature = require("./Signature");
var Sensor = require("./Sensor");


function Ship(sim){
    var coord = useful.getRandomCoordinates();
    this.x = coord.x;
    this.y = coord.y;
    this.signature = new Signature(0, 0, 0);
    this.sim = sim;
    this.destructible = true;
    this.sensor = new Sensor(this.sim,this);
	this.mspt = 1000/100;
    this.ambiantTemperature = 20;
    this.gun  = {
        minRate: 0,
        maxRate: 1,
        curRate: 0.8,
        disRate: 0.001,
        minCool: 0.0002,
        maxCool: 0.0025,
        curCool: 0.5,
        charge: 0,
        loading: true,
        load: 0,
        chargeHeat: 0.0002,
        temperature: this.ambiantTemperature
    };
    this.jumpDrive  = {
        minRate: 0,
        maxRate: 1,
        curRate: 1,
        disRate: 0.001,
        minCool: 0.0002,
        maxCool: 0.0025,
        curCool: 1,
        charge: 0,
        chargeHeat: 0.0002,
        temperature: this.ambiantTemperature
    };
}

Ship.prototype.pump = function() {
    this.sim.send({"status": this.getStatus()});  
};

Ship.prototype.tick = function() {
    
    // Tick gun
    this.gun.charge = this.gun.charge - this.gun.charge*this.gun.disRate*useful.jitter();
    this.gun.charge = this.gun.charge + useful.lerp(this.gun.minRate, this.gun.maxRate, this.gun.curRate)*useful.jitter();
    this.gun.temperature = this.gun.temperature - (this.gun.temperature - this.ambiantTemperature)*useful.lerp(this.gun.minCool, this.gun.maxCool, this.gun.curCool)*useful.jitter();
    this.gun.temperature = this.gun.temperature + this.gun.charge * this.gun.chargeHeat*useful.jitter();
    this.gun.load = useful.clamp(this.gun.load+(this.gun.loading?1:-1)*0.01);

    // Tick jumpDrive
    this.jumpDrive.charge = this.jumpDrive.charge - this.jumpDrive.charge*this.jumpDrive.disRate*useful.jitter();
    this.jumpDrive.charge = this.jumpDrive.charge + useful.lerp(this.jumpDrive.minRate, this.jumpDrive.maxRate, this.jumpDrive.curRate)*useful.jitter();
    this.jumpDrive.temperature = this.jumpDrive.temperature - (this.jumpDrive.temperature - this.ambiantTemperature)*useful.lerp(this.jumpDrive.minCool, this.jumpDrive.maxCool, this.jumpDrive.curCool)*useful.jitter();
    this.jumpDrive.temperature = this.jumpDrive.temperature + this.jumpDrive.charge * this.jumpDrive.chargeHeat*useful.jitter();
    
    
};

Ship.prototype.start = function() {
	this.interval = setInterval(this.tick.bind(this), this.mspt);
    this.sensor.start();
    this.pumpInterval = setInterval(this.pump.bind(this), 200);
};

Ship.prototype.stop = function() {
    this.sensor.stop();
	if (this.interval){
		clearInterval(this.interval);
        delete this.interval;
	}
    if (this.pumpInterval){
        clearInterval(this.pumpInterval);
        delete this.pumpInterval;
    }
};

Ship.prototype.fire = function(){
    
};

Ship.prototype.getStatus = function(){
    var status = {};
    status.gun = {
        charge: this.gun.charge,
        cooling: this.gun.curCool,
        rate: this.gun.curRate,
        loading: this.gun.loading,
        loadStatus: this.gun.load,
        ready: this.gun.charge>100&&this.gun.load>=1,
        temp: this.gun.temperature
    };
    status.jumpDrive = {
        charge: this.jumpDrive.charge,
        cooling: this.jumpDrive.curCool,
        rate: this.jumpDrive.curRate,
        loadStatus: this.jumpDrive.load,
        ready: this.jumpDrive.charge>800,
        temp: this.jumpDrive.temperature
    };
    return status;
};


module.exports = Ship;