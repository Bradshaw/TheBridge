local state = {}

function state:init()
	chev = love.graphics.newImage("images/chevron.png")
end


function state:enter( pre )
	time = 0
	mousedown = 0
	mouseX = 0
	mouseY = 0
	markers = {}
	gunCoolSlider = slider.new(300,10,100,20,0,1,0)
	gunCoolSlider.pushVal = function(val)
		set("gun","curCool",val)
	end
	gunCoolSlider.label = "Gun cooling"
	gunChargeSlider = slider.new(300,40,100,20,0,1,0)
	gunChargeSlider.pushVal = function(val)
		set("gun","curRate",val)
	end
	gunChargeSlider.label = "Gun charging"

	jumpDriveCoolSlider = slider.new(300,70,100,20,0,1,0)
	jumpDriveCoolSlider.pushVal = function(val)
		set("jumpDrive","curCool",val)
	end
	jumpDriveCoolSlider.label = "Jump Drive cooling"
	jumpDriveChargeSlider = slider.new(300,100,100,20,0,1,0)
	jumpDriveChargeSlider.pushVal = function(val)
		set("jumpDrive","curRate",val)
	end
	jumpDriveChargeSlider.label = "Jump Drive charging"

end

function send(command, data)
	client:send(JSON:encode({command=command, data=(data or {})}))
end

function state:leave( next )
end

function state:update(dt)
	if love.mouse.isDown("l") then
		local mx = love.mouse.getX()
		local my = love.mouse.getY()
		for i,v in ipairs(slider.all) do
			v:canActivate(mx, my, function()
				v:activate(mx, my)
			end)
		end
	end
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
			gunCoolSlider.value = status.gun.cooling
			gunChargeSlider.value = status.gun.rate
			jumpDriveCoolSlider.value = status.jumpDrive.cooling
			jumpDriveChargeSlider.value = status.jumpDrive.rate
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
			for k,v in pairs(o.pulse.reading) do
				print(k,v)
			end
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
	love.graphics.draw("ani_cursor", mouseX, mouseY,0,mousedown,mousedown,50,51)
	for i,v in ipairs(markers) do
		anim = cursor:getAnimation("ani_cursor")
		love.graphics.draw(anim:getPiece(math.floor((1+math.sin(i)*0.3)*love.timer.getTime()*anim.framerate)), v.x, v.y,0,0.3,0.3,(100/2),(94/2))
	end
	love.graphics.setShader()
	if status then
		love.graphics.setColor(0,255,255)
		love.graphics.setShader(alphaToWhite)

		anim = tag_ship:getAnimation("ani_cursor")
		if status.ship.warping then
			love.graphics.setColor(0,255,255,80)
			local x = (status.ship.x+status.ship.warpingTo.x)/2
			local y = (status.ship.y+status.ship.warpingTo.y)/2
			local dx = status.ship.warpingTo.x-status.ship.x
			local dy = status.ship.warpingTo.y-status.ship.y
			local d = math.sqrt(dx*dx+dy*dy)
			local a = math.atan2(dy,dx)
			love.graphics.setShader(chevshad)
			chevshad:send("times",(d/20))
			chevshad:send("time",(-love.timer.getTime()*2)%1)
			love.graphics.draw(chev,x,y,a,d/100,0.2,50,50)
		else
			love.graphics.draw(anim,
				status.ship.x,
				status.ship.y,
				0,0.3,0.3,140,145)
			love.graphics.setColor(0,255,255,25)
			love.graphics.circle("fill", status.ship.x, status.ship.y, 200)
			love.graphics.circle("fill", status.ship.x, status.ship.y, 50)
		end
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
				if v.warping then
					love.graphics.setColor(255,0,255,80)
					local x = (v.x+v.warpingTo.x)/2
					local y = (v.y+v.warpingTo.y)/2
					local dx = v.warpingTo.x-v.x
					local dy = v.warpingTo.y-v.y
					local d = math.sqrt(dx*dx+dy*dy)
					local a = math.atan2(dy,dx)
					love.graphics.setShader(chevshad)
					chevshad:send("times",(d/10))
					chevshad:send("time",(-love.timer.getTime()*2)%1)
					love.graphics.draw(chev,x,y,a,d/100,0.1,50,50)
					love.graphics.setShader()
				else
					love.graphics.setColor(255,0,255)
					love.graphics.circle("fill", v.x, v.y, 5)
					love.graphics.setColor(255,0,255,25)
					love.graphics.circle("fill", v.x, v.y, 200)
					love.graphics.setColor(255,0,255,25)
					love.graphics.circle("fill", v.x, v.y, 20)
				end
				love.graphics.print(v.id, 20, 20*line)
				line = line+1
			end
		end
	end
	love.graphics.setColor(255,255,255)
	for i,v in ipairs(slider.all) do
		v:draw()
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
		local dx = love.mouse.getX()-status.ship.x
		local dy = love.mouse.getY()-status.ship.y
		local d = math.sqrt(dx*dx+dy*dy)

		fire(
			math.atan2(dy, dx),
			50,
			d
		)
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
	if key=="s" then
		scanDrone(
			love.mouse.getX(),
			love.mouse.getY()
		)
	end
	if key=="l" then
		set("gun", "loading", math.floor(1-status.gun.loading))
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