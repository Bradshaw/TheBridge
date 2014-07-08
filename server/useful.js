useful = {};

useful.lerp = function(a, b, n){
    return b*n+a*(1-n);
};

useful.jitter = function(base){
    var base = base || 0.1;
    return 1 + Math.random()*base - Math.random()*base;
};


module.exports = useful;