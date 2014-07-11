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

function scanDrone(x, y)
	send("scanDrone", {
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

function fire(angle, speed, distance)
	send("fire",{
		angle = angle,
		speed = speed,
		distance = distance
	})
end

function set(module, subsystem, value)
	send("set", {
		module = module,
		subsystem = subsystem,
		value = value
	})
end