useful = {};

useful.lerp = function(a, b, n){
    return b*n+a*(1-n);
};

useful.jitter = function(base){
    var b = base || 0.1;
    return 1 + Math.random()*b - Math.random()*b;
};

useful.distance2 = function(o1, o2){
    var dx = o2.x-o1.x;
    var dy = o2.y-o1.y;
    return (dx*dx+dy*dy);
};

useful.distance = function(o1, o2){
    return Math.sqrt(useful.distance2(o1, o2));
};

useful.angle = function(o1, o2){
    var dx = o2.x-o1.x;
    var dy = o2.y-o1.y;
    return Math.atan2(dy, dx);
};

useful.falloff = function(amp, distance){
    Math.max(amp-distance, 0);
};

useful.getRandomCoordinates = function(){
    return {
        x: Math.random()*800,
        y: Math.random()*600
    }
};


module.exports = useful;