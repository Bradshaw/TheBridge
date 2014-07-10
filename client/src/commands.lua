function deployDrone()
	send("deployDrone")
end

function retrieveDrones()
	send("retrieveDrones")
end

function moveDrone(id, x, y)
	send("moveDrone", {
		id = id,
		x = x,
		y = y
		})
end

function scanDrone(id, x, y)
	send("moveDrone", {
		id = id,
		x = x,
		y = y
		})
end

function jump(x, y)
	send("jump",{
		x = x,
		y = y
		})
end

function fire(angle, speed, time)
end

function set(module, subsystem, value)
end