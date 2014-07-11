var _ = require("underscore");
var lazy = require("lazy.js");
var async = require("async");
var net = require("net");


var Connection = require("./Connection");
var Simulator = require("./sim/Simulator");
var Drone = require("./sim/Drone");
var Bomb = require("./sim/Bomb");

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
            drone.warpingTo = {x:data.x, y:data.y};
            setTimeout(function(){
                drone.warping = false;
                drone.x = data.x;
                drone.y = data.y;
                drone.sensor.start(); 
            }, useful.distance(drone, data)*5);
        }
    });

    conn.on("scanDrone", function(data){
        var drone = lazy(sim.space)
            .find(function(ob){
                return ob.identifier=="Drone" && useful.distance(ob, data)<200;
            });
        if (sim.playerShip.markers>0 && drone && !drone.warping) {
            sim.playerShip.markers--;
            lazy(sim.space)
                .filter(function(ob){
                    return useful.distance(data, ob)<30;
                })
                .each(function(ob){
                    ob.marked = useful.guid();
                });
        }
    });

    conn.on("jump", function(data){
        if (!sim.playerShip.warping && sim.playerShip.jumpDrive.charge>=800 && useful.distance(sim.playerShip,data)<200){
            sim.playerShip.jumpDrive.charge -= 800;
            sim.playerShip.jumpDrive.curCool = 0;
            sim.playerShip.jumpDrive.curRate = 0;
            sim.playerShip.gun.curCool = 0;
            sim.playerShip.gun.curRate = 0;
            sim.playerShip.jumpDrive.temperature += 50;
            sim.playerShip.sensor.stop();
            sim.playerShip.warping = true;
            sim.playerShip.warpingTo = {x:data.x, y:data.y};
            lazy(sim.space)
                .filter(function(ob){
                    return ob.identifier=="Drone";
                })
                .each(function(drone){
                    drone.purge = true;
                    drone.sensor.stop();
                    delete drone.sensor;
                });
            sim.prune();
            setTimeout(function() {
                sim.playerShip.x = data.x;
                sim.playerShip.y = data.y;
                sim.playerShip.warping = false;
                sim.playerShip.sensor.start();
            }, useful.distance(sim.playerShip, {x: data.x, y:data.y})*5);
        }
    });

    conn.on("fire", function(data){
        //(angle, speed, time)
        if (!sim.playerShip.warping && sim.playerShip.gun.charge>=100 && sim.playerShip.gun.load>=1)
        {
            sim.playerShip.gun.charge -= 100;
            sim.playerShip.gun.temperature += 50;
            sim.playerShip.gun.load = 0;
            sim.playerShip.gun.loading = 0;
            var dx = Math.cos(data.angle)*data.speed;
            var dy = Math.sin(data.angle)*data.speed;
            sim.space.push(new Bomb(
                sim,
                sim.playerShip.x,
                sim.playerShip.y,
                dx,
                dy,
                data.distance
            ));            
        }
    });

    conn.on("set", function(data){
        //(module, subsystem, value)
        var mod = sim.playerShip[data.module];
        mod[data.subsystem] = parseFloat(data.value); 
    });
});





server.listen(1337, '0.0.0.0');
console.log("Listening...");