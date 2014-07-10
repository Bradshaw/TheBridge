local state = {}

function state:init()
end


function state:enter( pre )
	time = 0
	mousedown = 0
	mouseX = 0
	mouseY = 0
	markers = {}
end

function send(command, data)
	client:send(JSON:encode({command=command, data=(data or {})}))
end

function state:leave( next )
end

function state:update(dt)
	if love.mouse.isDown('r') then
		mousedown = math.min(1, mousedown+dt*10)
		mouseX = love.mouse.getX()
		mouseY = love.mouse.getY()
	else
		mousedown = math.max(0, mousedown-dt*10)
	end
	time = time - dt
	if time<=0 then
		time = time + 1
	end
	ret = client:receive()
	while ret do
		local o = JSON:decode(ret)
		if o.status then
			status = o.status
		end
		if o.dump then
			love.graphics.setCanvas(map_canv)
			love.graphics.setColor(255,255,255)
			love.graphics.line(o.dump.x-5, o.dump.y-5,o.dump.x+5, o.dump.y+5)
			love.graphics.line(o.dump.x-5, o.dump.y+5,o.dump.x+5, o.dump.y-5)
			love.graphics.setCanvas()
		end
		if o.sensor then
			local sensor = o.sensor
			local x = tonumber(sensor.x)
			local y = tonumber(sensor.y)
			local read = sensor.reading
			if read.intensity>0 and read.intensity<math.huge then
				love.graphics.setCanvas(map_canv)
				love.graphics.setBlendMode("additive")
				local intensity = math.min(255,math.max(0, read.intensity-read.threshold))
				if read.name=="em" then
					love.graphics.setColor(0,0,255,intensity)
				elseif read.name == "gr" then
					love.graphics.setColor(0,255,0,intensity)
				else
					love.graphics.setColor(255,0,0,intensity)
				end
				--love.graphics.setLineStyle("rough")
				if read.method == "range" then
					love.graphics.circle("line", x, y, tonumber(read.value));
				else
					local d = tonumber(read.value)
					love.graphics.line(x, y, x+math.cos(d)*1000, y+math.sin(d)*1000)
				end
				--love.graphics.setLineStyle("smooth")
				love.graphics.setCanvas()
			end
		end
		if o.pulse then
			local sensor = o.pulse
			local x = tonumber(sensor.x)
			local y = tonumber(sensor.y)
			local read = sensor.reading
			love.graphics.setCanvas(map_canv)
			love.graphics.setBlendMode("alpha")
			local intensity = math.min(255,math.max(0, read.intensity-read.threshold))
			love.graphics.setColor(255,125,0,intensity/2)
			love.graphics.circle("fill", x, y, read.value)
			love.graphics.setColor(255,125,0,intensity)
			love.graphics.circle("line", x, y, read.value)
			love.graphics.setCanvas()
		end
		ret = client:receive()
	end
end


function state:draw()
	love.graphics.setCanvas()
	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(255,255,255)
	love.graphics.setShader(darken)
	love.graphics.draw(map_canv)
	love.graphics.setShader()
	love.graphics.setCanvas(map_canv)
	love.graphics.setColor(0,0,0,5)
	love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
	love.graphics.setCanvas()
	love.graphics.setColor(0,255,255)
	love.graphics.setShader(alphaToWhite)
	love.graphics.draw("ani_cursor", mouseX, mouseY,0,mousedown,mousedown,(100/2),(94/2))
	for i,v in ipairs(markers) do
		anim = cursor:getAnimation("ani_cursor")
		love.graphics.draw(anim:getPiece(math.floor((1+math.sin(i)*0.3)*love.timer.getTime()*anim.framerate)), v.x, v.y,0,0.3,0.3,(100/2),(94/2))
	end
	love.graphics.setShader()
	if status then
		love.graphics.setColor(0,255,255)
		love.graphics.setShader(alphaToWhite)
		anim = tag_ship:getAnimation("ani_cursor")
		love.graphics.draw(anim,
			status.ship.x,
			status.ship.y,
			0,0.3,0.3,(268/2),(283/2))
		love.graphics.setColor(0,255,255,25)
		love.graphics.circle("fill", status.ship.x, status.ship.y, 200)
		love.graphics.setShader()
		love.graphics.setColor(255,255,255)
		print("have status")
		local line = 1
		love.graphics.print("Gun:",10,line*20)
		line = line +1
		for k,v in pairs(status.gun) do
			local v = v
			if type(v)=="boolean" then
				v = v and "TRUE" or "FALSE"
			end
			love.graphics.print(k..": "..v, 20, line*20)
			line = line+1
		end
		love.graphics.print("Jump Drive:",10,line*20)
		line = line +1
		for k,v in pairs(status.jumpDrive) do
			local v = v
			if type(v)=="boolean" then
				if v then
					v = "TRUE"
				else
					v = "FALSE"
				end
			end
			love.graphics.print(k..": "..v, 20, line*20)
			line = line+1
		end
		love.graphics.print("Drones:", 10, line*20)
		line = line+1
		if status.drones then
			for i,v in ipairs(status.drones) do
				love.graphics.setColor(255,0,255)
				love.graphics.print(v.id, 20, 20*line)
				love.graphics.circle("fill", v.x, v.y, 5)
				love.graphics.setColor(255,0,255,25)
				love.graphics.circle("fill", v.x, v.y, 200)
				line = line+1
			end
		end
	end
end


function state:errhand(msg)
end


function state:focus(f)
end


function state:keypressed(key, isRepeat)
	if key=='escape' then
		love.event.push('quit')
	end
	if key==" " then
		client:send(JSON:encode({command="debug", data={}}))
	end
	if key=='m' then
		table.insert(markers,{
			x= love.mouse.getX(),
			y= love.mouse.getY()
		})
	end
	if key=="x" then
		send("bomb", {x=love.mouse.getX(),y=love.mouse.getY(),speed=100})
	end
	if key=="d" then
		deployDrone()
	end
	if key=="r" then
		retrieveDrones()
	end
	if tonumber(key) then
		if status.drones[tonumber(key)] then
			moveDrone(
				status.drones[tonumber(key)].id,
				love.mouse.getX(),
				love.mouse.getY()
			)
		end
	end

end


function state:keyreleased(key, isRepeat)
end


function state:mousefocus(f)
end


function state:mousepressed(x, y, btn)
end


function state:mousereleased(x, y, btn)
	if btn=="r" then
		jump(x, y)
	end
end


function state:quit()
end


function state:resize(w, h)
end


function state:textinput( t )
end


function state:threaderror(thread, errorstr)
end


function state:visible(v)
end


function state:gamepadaxis(joystick, axis)
end


function state:gamepadpressed(joystick, btn)
end


function state:gamepadreleased(joystick, btn)
end


function state:joystickadded(joystick)
end


function state:joystickaxis(joystick, axis, value)
end


function state:joystickhat(joystick, hat, direction)
end


function state:joystickpressed(joystick, button)
end


function state:joystickreleased(joystick, button)
end


function state:joystickremoved(joystick)
end

return state