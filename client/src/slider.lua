local slider_mt = {}
slider = {}

slider.all = {}

function slider.new(x, y, w, h, min, max, value)
	local self = setmetatable({},{__index=slider_mt})
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.margin = 3
	self.min = min or 0
	self.max = max or 1
	self.value = value or self.min
	self.pushVal = function() end
	self.label = ""
	table.insert(slider.all, self)
	return self
end

function slider_mt:activate(x, y, cb)
	self.value = math.min(self.max, math.max(self.min, self.min+((x-self.x)/(self.w))*(self.max-self.min)))
	if cb then
		cb(self.value)
	end
	self.pushVal(self.value)
	return self.value
end

function slider_mt:canActivate(x, y, cb)
	local act = (x>=self.x-self.margin and x<=self.x+self.w+self.margin and y>=self.y-self.margin and y<=self.y+self.h+self.margin)
	if act and cb then
		cb()
	end
	return act
end

function slider_mt:draw()
	love.graphics.print(self.label,
		self.x-love.graphics.getFont():getWidth(self.label)-3,
		self.y+self.h/2-love.graphics.getFont():getHeight()/2
		)
	love.graphics.rectangle("line",self.x, self.y, self.w, self.h)
	love.graphics.rectangle("fill",self.x, self.y, (self.value/(self.max-self.min))*self.w, self.h)
end