var _ = require("underscore");
var lazy = require("lazy.js");
var async = require("async");
var useful = require("./../useful");

function Sensor(attach){
    this.attach = attach;
}

module.exports = Sensor;