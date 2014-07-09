socket = require("socket")
math.randomseed(os.time())


-- private functions
local function add_lf(s)
    if string.sub(s, #s, #s) ~= '\n' then
        return s .. '\n'
    else
        return s
    end
end

-- echo client
EchoClient = {}
 
function EchoClient:request(msg)
    self:send(msg)
    return self:receive('*line')
end

function EchoClient:send( msg )
    self.sock:send(add_lf(msg).."[BREAK]")
end

function EchoClient:receive()
    local response = self.sock:receive('*l')
    return response
end
 
function EchoClient:new(host, port)
    local self = setmetatable({},{__index=EchoClient})
    self.host = host or '127.0.0.1'
    self.port = port or 1337
    self.sock = socket.tcp()
    assert(self.sock:connect(self.host, self.port))
    self.sock:settimeout(0)
    return self
end

function string:split(sep)
        local sep, fields = sep or ":", {}
        local pattern = string.format("([^%s]+)", sep)
        self:gsub(pattern, function(c) fields[#fields+1] = c end)
        return fields
end

function EchoClient:parse(msg, f)
    local parts = msg:split("/")
    if #parts>=2 then
        if parts[1]=="c" then
            self.uid = parts[2]
        elseif parts[1]=="b" then
            if #parts>=4 then
                if parts[2]==self.uid then
                    print("I got a message from myself: \""..parts[4].."\" in room "..parts[3])
                else
                    print("I got a message from "..parts[2]..": \""..parts[4].."\" in room "..parts[3])
                end
            end
        end

    end
end

if not love then

    local client = EchoClient:new()

    max = 0

    client:send("s/a")
    client:send("s/b")
    client:send("u/a")
    client:send("b/b/Hello everybody!")

    while true do
        ret = client:receive()
        if ret then
            client:parse(ret)
        end
    end

    client.sock:shutdown()
    client.sock:close()
end