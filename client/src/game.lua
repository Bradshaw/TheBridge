local state = {}

function state:init()
end


function state:enter( pre )
	time = 0
	mousedown = 0
	mouseX = 0
	mouseY = 0
end


function state:leave( next )
end

function state:update(dt)
	if love.mouse.isDown('l') then
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
		if o.dump then
			love.graphics.setCanvas(map_canv)
			love.graphics.setColor(255,255,255)
			love.graphics.line(o.dump.x-5, o.dump.y-5,o.dump.x+5, o.dump.y+5)
			love.graphics.line(o.dump.x-5, o.dump.y+5,o.dump.x+5, o.dump.y-5)
			love.graphics.setCanvas()
		end
		if o.sensor then
			local sensor = o.sensor
			love.graphics.setCanvas(map_canv)
			love.graphics.setBlendMode("additive")
			local x = tonumber(sensor.x)
			local y = tonumber(sensor.y)
			local read = sensor.reading
			if read.name=="em" then
				love.graphics.setColor(0,0,255)
			elseif read.name == "gr" then
				love.graphics.setColor(0,255,0)
			else
				love.graphics.setColor(255,0,0)
			end

			if read.method == "range" then
				love.graphics.circle("line", x, y, tonumber(read.value));
			else
				local d = tonumber(read.value)
				love.graphics.line(x, y, x+math.cos(d)*1000, y+math.sin(d)*1000)
			end
			love.graphics.setCanvas()
		end
		ret = client:receive()
	end
end


function state:draw()
	love.graphics.setCanvas()
	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(255,255,255)
	love.graphics.draw(map_canv)
	love.graphics.setCanvas(map_canv)
	love.graphics.setColor(0,0,0,5)
	love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
	love.graphics.setCanvas()
	love.graphics.setColor(255,255,255)
	love.graphics.draw("ani_cursor", mouseX, mouseY,0,mousedown,mousedown,(100/2),(94/2))

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
end


function state:keyreleased(key, isRepeat)
end


function state:mousefocus(f)
end


function state:mousepressed(x, y, btn)
end


function state:mousereleased(x, y, btn)
	local jumpTo = {x = x, y = y}
	client:send(JSON:encode({command="jump", data=jumpTo}))
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