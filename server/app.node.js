var _ = require("underscore");
var lazy = require("lazy.js");
var async = require("async");
var net = require("net");


var Connection = require("./Connection");
var Simulator = require("./sim/Simulator");
var Drone = require("./sim/Drone");

var sim = new Simulator(); 

var server = net.createServer(function (socket) {
    var conn = new Connection(socket);
    
    sim.addConnection(conn);
    conn.on("deployDrone", function(data){
        //()
        if (sim.playerShip.availableDrones>0){
            var a = Math.random()*Math.PI*2;
            var d = 25;
            var ox = Math.cos(a)*d;
            var oy = Math.sin(a)*d;
            var drone = new Drone(sim, sim.playerShip.x+ox, sim.playerShip.y+oy);
            drone.sensor.start();
            sim.space.push(drone);
            sim.playerShip.availableDrones--;
        }
    });

    conn.on("retrieveDrones", function(data){
        lazy(sim.space)
            .filter(function(ob){
                return ob.identifier=="Drone";
            })
            .filter(function(drone){
                return useful.distance(drone, sim.playerShip)<50;
            })
            .each(function(drone){
                sim.playerShip.availableDrones++;
                drone.purge = true;
                drone.sensor.stop();
                delete drone.sensor;
            });
        sim.prune();
    });

    conn.on("moveDrone", function(data){
        //(id, x, y)
        var drone = lazy(sim.space)
            .find(function(ob){
                return ob.identifier=="Drone" && ob.id==data.id;
            });
        
        if (drone && !drone.warping && useful.distance({x:data.x, y:data.y}, sim.playerShip)<200) {
            drone.sensor.stop();
            drone.warping = true;
            setTimeout(function(){
                drone.warping = false;
                drone.x = data.x;
                drone.y = data.y;
                drone.sensor.start(); 
            }, useful.distance(drone, data)*20);
        }
    });

    conn.on("scanDrone", function(data){
        var drone = lazy(sim.space)
            .find(function(ob){
                return ob.identifier=="Drone" && ob.id==data.id;
            });
        if (drone && !drone.warping && useful.distance(data, drone)<200) {
            lazy(sim.space)
                .filter(function(ob){
                    return distance(data, ob)<10;
                })
                .each(function(ob){
                    ob.marked = true;
                });
        }
    });

    conn.on("jump", function(data){
        if (!sim.playerShip.warping && useful.distance(sim.playerShip,data)<200){
            sim.playerShip.sensor.stop();
            sim.playerShip.warping = true;
            setTimeout(function() {
                sim.playerShip.x = data.x;
                sim.playerShip.y = data.y;
                sim.playerShip.warping = false;
                sim.playerShip.sensor.start();
            }, useful.distance(sim.playerShip, {x: data.x, y:data.y})*20);
        }
    });

    conn.on("fire", function(data){
        //(angle, speed, time)
    });

    conn.on("set", function(data){
        //(module, subsystem, value)
    });
});





server.listen(1337, '0.0.0.0');
console.log("Listening...");