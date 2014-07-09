var _ = require("underscore");
var lazy = require("lazy.js");
var async = require("async");
var useful = require("./../useful");


function Signature(em, gr, th){
    this.em = em;
    this.gr = gr;
    this.th = th;
}

Signature.prototype.getAtRange = function(sig, range){
    return useful.falloff(this[sig], range);
};

Signature.prototype.getEM = function(range){
    return this.getAtRange("em", range) * 100;
};

Signature.prototype.getGR = function(range){
    return this.getAtRange("gr", range) * 100;
};

Signature.prototype.getTH = function(range){
    return this.getAtRange("th", range) * 100;
};

module.exports = Signature;