function love.load()
	require("brdcastcl")
	client = EchoClient:new()
	time = 0
	received = ""
end

function love.update( dt )
	time = time - dt
	if time<=0 then
		time = time + 1
		client:send('{"command": {"do": "sensors", "data": {}}}')
	end
	ret = client:receive()
    if ret then
        received = received..ret..'\n'
    end
   	if received:len()>400 then
   		received =  received:sub(received:len()-400)
   	end
end

function love.draw()
	love.graphics.print(received)
end