local state = {}

function state:init()
end


function state:enter( pre )
	time = 0
end


function state:leave( next )
end

function state:update(dt)
	time = time - dt
	if time<=0 then
		time = time + 1
	end
	ret = client:receive()
	if ret then
		local o = JSON:decode(ret)
		if o.sensors then
			love.graphics.setCanvas(map_canv)
			love.graphics.setBlendMode("additive")
			for _,sensor in ipairs(o.sensors) do
				local x = tonumber(sensor.x)
				local y = tonumber(sensor.y)
				for _,read in ipairs(sensor.readings) do
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
				end
			end
			love.graphics.setCanvas()
		end
	end
	love.graphics.setCanvas(map_canv)
	love.graphics.setColor(0,0,0,12)
	love.graphics.rectangle("fill",0,0,800,600)
	love.graphics.setCanvas()
	love.graphics.setCanvas()
end


function state:draw()
	love.graphics.setCanvas()
	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(255,255,255)
	love.graphics.draw(map_canv)

end


function state:errhand(msg)
end


function state:focus(f)
end


function state:keypressed(key, isRepeat)
	if key=='escape' then
		love.event.push('quit')
	end
end


function state:keyreleased(key, isRepeat)
end


function state:mousefocus(f)
end


function state:mousepressed(x, y, btn)
end


function state:mousereleased(x, y, btn)
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