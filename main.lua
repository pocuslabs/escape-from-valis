local cartographer = require "lib/cartographer"

function love.load()
  map = cartographer.load("data/map.lua")
end

function love.update(dt)

end

function love.draw()
  map:draw()
end