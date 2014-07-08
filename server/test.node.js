var ship = require("./Ship");

s = new ship();

s.gun.curCool = 1;
s.gun.curRate = 1;

s.start();

setInterval(function(){
    console.log("Temp: "+ s.gun.temperature);
    console.log("Charge: "+ s.gun.charge);
    console.log("------------------------------\n");
}, 1000);
