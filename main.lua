local cartographer = require "lib/cartographer"

WIDTH = 1024
HEIGHT = 768

local function isDirection(key)
  return key == "up" or key == "down" or key == "left" or key == "right"
end

local function getDirection(key)
  if key == "up" then
    return 0, 1
  elseif key == "down" then
    return 0, -1
  elseif key == "left" then
    return -1, 0
  elseif key == "right" then
    return 1, 0
  else
    return 0, 0
  end
end

Player = {
  x = 0,
  y = 0,
  dx = 0,
  dy = 0
}

function love.conf(t)
  t.console = true
end

function love.load()
  love.window.setMode(WIDTH, HEIGHT)
  Map = cartographer.load("data/map.lua")
  Spritesheet = love.graphics.newImage("gfx/blowhard.png")
  PlayerQuad = love.graphics.newQuad(0, 32, 32, 32, Spritesheet:getDimensions())
end

function love.update(dt)
  Player.x = Player.x + Player.dx * dt
  Player.y = Player.y + Player.dy * dt
end

function love.draw()
  Map:draw()
  love.graphics.draw(Spritesheet, PlayerQuad, Player.x, Player.y)
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then
     love.event.quit()
  elseif isDirection(key) then
    local dx, dy = getDirection(key)
    local nx = Player.x + dx
    local ny = Player.y + dy
    local layer = Map.layers[1]
    local gid = layer.getTileAtPixelPosition(nx, ny)
    local issolid = Map.getTileProperty(gid, "solid")

    if not issolid then
      Player.dx = dx
      Player.dy = dy
    end
  end
end