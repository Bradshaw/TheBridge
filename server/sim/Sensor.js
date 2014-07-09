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
        var em = ob.signature.getEM(useful.distance(that.attach, ob));
        var gr = ob.signature.getGR(useful.distance(that.attach, ob));
        var th = ob.signature.getTH(useful.distance(that.attach, ob));

        if( (em > 20) ){
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
        }

        if( (gr > 20) ){
            that.sim.send(
                {
                    sensor: {
                        x: that.attach.x,
                        y: that.attach.y,
                        reading: {
                            name: "gr",
                            method: "angle",
                            value: useful.angle(that.attach, ob)
                        }
                    }
                });
        }

        if( (th > 80) ){
            that.sim.send(
                {
                    sensor: {
                        x: that.attach.x,
                        y: that.attach.y,
                        reading: {
                            name: "th",
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
                            name: "th",
                            method: "angle",
                            value: useful.angle(that.attach, ob)
                        }
                    }
                });
        }

    });
};

module.exports = Sensor;