var _ = require("underscore");
var lazy = require("lazy.js");
var async = require("async");
var useful = require("./../useful");
var Ship = require("./Ship");
var Celestial = require("./Celestial");
var Enemy = require("./Enemy");
var Drone = require("./Drone");

function Simulator(){
    this.playerShip = new Ship(this);
    this.space = [this.playerShip];
    for (var i=0; i<10; i++){
        this.space.push(new Celestial(this));
    }
    for (var i=0; i<1; i++){
        this.space.push(new Drone(this));
    }
    this.connections = [];
}

Simulator.prototype.prune = function(){
    this.space = lazy(this.space).filter(
        function(){
            return (!this.purge);
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
        ob.purge = true; 
    });
    this.prune();
    lazy(this.space).filter(function(ob){
        return ob.hasOwnProperty("sensor");
    }).each(function(ob){
        ob.sensor.impulse(x, y, range);
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