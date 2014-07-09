require("useful")
function love.load(arg)
	JSON = require("JSON")
	require("brdcastcl")
	client = EchoClient:new()
	gstate = require "gamestate"
	game = require("game")

	fudge = require("fudge")
	cursor = fudge.new("images/curseur")
		fudge.set({
		monkey= true,
		current = cursor
		})

	cursor:countToAnimation("cursor_anim",50,{
		numlen = 4,
		startAt = 0,
		name = "cursor",
		framerate = 30
	})

	map_canv = love.graphics.newCanvas(love.graphics.getWidth(),love.graphics.getHeight())


	gstate.registerEvents()
	gstate.switch(game)
end