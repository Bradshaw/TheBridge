local state = {}

function state:init()
end


function state:enter( pre )
	pump = 	0
	time = 0
	temp = 20
	ambiant = 20
	maxCap = 1
	minCap = 0
	curCap = 0
	maxCool = 0.0025
	minCool = 0.0002
	curCool = 0
	lineh = {}
	linec = {}

end


function state:leave( next )
end

function jit()
	return 1+math.random()*0.5-math.random()*0.5
end

function state:update(dt)
	--curCap = (600-love.mouse.getY())/600
	--curCool = (love.mouse.getX())/800
	time = time - dt
	while time<=0 do
		time = time + 0.01
		pump = pump - pump*0.001*jit()
		pump = pump + useful.lerp(minCap, maxCap, curCap)*jit()
		temp = temp - (temp - ambiant)*useful.lerp(minCool, maxCool, curCool)*jit()
		temp = temp + pump * 0.0002*jit()
		table.insert(lineh, temp)
		table.insert(linec, pump)
	end
	while #lineh>800 do
		table.remove(lineh, 1)
		table.remove(linec, 1)
	end
end


function state:draw()
	love.graphics.setBlendMode("additive")
	love.graphics.setColor(255,255,255)
	love.graphics.print("Capa: "..(math.floor(pump*100)/100).." kJ", 20, 20)
	love.graphics.print("Temp: "..(math.floor(temp*100)/100).."°", 20, 40)
	love.graphics.print("Pump: "..(curCap*100).."%", 20, 60)
	love.graphics.print("Cool: "..(curCool*100).."%", 20, 80)
	love.graphics.setColor(255,0,0)
	for i,v in ipairs(lineh) do
		love.graphics.point(i, 600-v)
	end
	love.graphics.setColor(0,255,255)
	for i,v in ipairs(linec) do
		love.graphics.point(i, 600-v/10)
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
	if key==' ' and pump>=100 then
		pump = pump-100
		temp = temp+30
	end
	if key=="left" then
		curCool = math.max(curCool-0.1, 0)
	end
	if key=="down" then
		curCap = math.max(curCap-0.1, 0)
	end
	if key=="right" then
		curCool = math.min(curCool+0.1, 1)
	end
	if key=="up" then
		curCap = math.min(curCap+0.1, 1)
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