require("useful")
function love.load(arg)
	JSON = require("JSON")
	require("brdcastcl")
	client = EchoClient:new()
	gstate = require "gamestate"
	game = require("game")

	map_canv = love.graphics.newCanvas(800,600)


	gstate.registerEvents()
	gstate.switch(game)
end