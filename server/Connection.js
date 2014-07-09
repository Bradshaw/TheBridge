var _ = require("underscore");

function Connection(socket){
    this.socket = socket;
    this.socket.setEncoding('utf8');
    var that = this;
    this.socket.on('error', function(err) {
        console.log(err)
    });
    this.socket.on('close', function() {
        that.active = false;
    });
    this.socket.on('data', function(data) {
        that.unpack(data, "[BREAK]");
    });
    this.active = true;
    this.callbacks = {};
}

Connection.prototype.on =  function(key, cb){
    if (!this.callbacks.hasOwnProperty(key)) {
        this.callbacks[key] = [];
    }
    this.callbacks[key].push(cb);
};

Connection.prototype.unpack = function(str, sym) {
    var commands = str.split(sym);
    for (var i = 0; i < commands.length-1; i++) {
        this.parse(commands[i]);
    }
};

Connection.prototype.send = function(object){
    this.socket.write(JSON.stringify(object)+'\n');
};

Connection.prototype.parse = function(line){
    var req = JSON.parse(line);
    if (req.hasOwnProperty('command')) {
        _.each(this.callbacks[req.command], function(cb){
            cb(req.data);
        });
    }
};

module.exports = Connection;