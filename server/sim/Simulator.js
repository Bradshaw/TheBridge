var _ = require("underscore");
var lazy = require("lazy.js");
var async = require("async");
var useful = require("./../useful");
var Ship = require("./Ship");
var Celestial = require("./Celestial");
var Enemy = require("./Enemy");
var Drone = require("./Drone");
var Signature = require("./Signature");
var Bomb = require("./Bomb");

function Simulator(){
    this.playerShip = new Ship(this);
    this.space = [this.playerShip];
    this.playerShip.start();
    var i;
    for (i=0; i<10; i++){
        this.space.push(new Celestial(this));
    }
    for (i=0; i<10; i++){
        var en = new Enemy(this);
        while (useful.distance(en, this.playerShip)<200){
            var c = useful.getRandomCoordinates();
            en.x = c.x;
            en.y = c.y;
        }
        this.space.push(en);
    }

    this.start();

    this.connections = [];
}

Simulator.prototype.start = function(){
    this.interval = setInterval(this.destroyDistantDrone.bind(this), 1000);  
};

Simulator.prototype.destroyDistantDrone = function(){
    var that = this;
    lazy(this.space).filter(this.space, function(ob) {
        return ob.identifier == "Drone";
    }).filter(function(ob){
        return useful.distance(that.playerShip, ob) > 10;
    }).each(function(ob){
        ob.purge = true;//*/
    });
    this.prune();

};


Simulator.prototype.prune = function(){
    this.space = lazy(this.space).filter(
        function(ob){
            return (!ob.purge);
        }).toArray();
};

Simulator.prototype.explode = function(x, y, range){
    lazy(this.space).filter(function(ob){
        return ob.destructible;  
    }).filter(function(ob){
        return ob.x<x+range && ob.x>x-range;
    }).filter(function(ob){
        return ob.y<y+range && ob.y>y-range;
    }).filter(function(ob){
        return useful.distance2({x:x, y:y}, ob)<(range*range);
    }).each(function(ob){
        console.log("KILL: "+ob.identifier);
        ob.purge = true;
        if (ob.hasOwnProperty("stop"))
            ob.stop();
        if (ob.hasOwnProperty("sensor")){
            ob.sensor.stop();
        }
    });
    this.prune();
    lazy(this.space).filter(function(ob){
        return ob.hasOwnProperty("sensor");
    }).each(function(ob){
        ob.sensor.impulse({x:x, y:y, sig: new Signature(0,0,50000000), radius: range});
    });
};


Simulator.prototype.addConnection = function(conn){
    this.connections.push(conn);  
};

Simulator.prototype.send = function(ob){
    this.connections = _.filter(this.connections, function(conn){
         return conn.active;
    });
    _.each(this.connections, function(conn){
        conn.send(ob);  
    });
};

Simulator.prototype.dump = function(){
    var that = this;
    _.each(this.space, function(ob){
        that.send({dump: {x: ob.x, y:ob.y}});        
    });
};

module.exports = Simulator;