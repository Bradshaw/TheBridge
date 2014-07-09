require("useful")
function love.load(arg)
	JSON = require("JSON")
	require("brdcastcl")
	client = EchoClient:new()
	gstate = require "gamestate"
	game = require("game")

	fudge = require("fudge")

	fudge.set("monkey", true)

	cursor = fudge.new("images/curseur")
	cursor:countToAnimation("cursor_anim",50,{
		numlen = 4,
		startAt = 0,
		name = "ani"
	})

	map_canv = love.graphics.newCanvas(800,600)


	gstate.registerEvents()
	gstate.switch(game)
end