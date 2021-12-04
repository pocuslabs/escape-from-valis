local cartographer = require "lib/cartographer"

WIDTH = 1024
HEIGHT = 768

function love.load()
  love.window.setMode(WIDTH, HEIGHT)
  Map = cartographer.load("data/map.lua")
  Player = {
    x = 0,
    y = 0
  }
end

function love.update(dt)

end

function love.draw()
  Map:draw()
end