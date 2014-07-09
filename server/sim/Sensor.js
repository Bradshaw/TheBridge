var _ = require("underscore");
var lazy = require("lazy.js");
var async = require("async");
var useful = require("./../useful");

function Sensor(sim, attach){
    this.attach = attach;
    this.sim = sim;
}

Sensor.prototype.impulse = function(x, y, range){
      
};

Sensor.prototype.start = function(){
    setInterval(this.ping.bind(this), 1000);  
};

Sensor.prototype.ping = function(){
    var that = this;
    lazy(this.sim.space).each(function(ob){
        that.sim.send(
        {
            sensor: {
                x: that.attach.x,
                y: that.attach.y,
                reading: {
                    name: "em",
                    method: "range",
                    value: useful.distance(that.attach, ob)
                }
            }
        });
        that.sim.send(
            {
                sensor: {
                    x: that.attach.x,
                    y: that.attach.y,
                    reading: {
                        name: "gr",
                        method: "angle",
                        value: useful.distance(that.attach, ob)
                    }
                }
            });
    });
};

module.exports = Sensor;