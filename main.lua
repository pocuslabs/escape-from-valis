local cartographer = require "lib/cartographer"
local logger = require("lib/logging/file") {
  filename = "~/log.txt"
}

WIDTH = 1024
HEIGHT = 768
TILE = 32

Keys = {}
MoveQueue = {}

local function isDirection(key)
  return key == "up" or key == "down" or key == "left" or key == "right"
end

local function getDirection(key)
  if key == "up" then
    return 0, -1
  elseif key == "down" then
    return 0, 1
  elseif key == "left" then
    return -1, 0
  elseif key == "right" then
    return 1, 0
  else
    return 0, 0
  end
end

local function isMovable(dx, dy)
  local nx = Player.x + dx
  local ny = Player.y + dy

  return nx >= 0 and nx <= WIDTH and ny >= 0 and ny <= HEIGHT
end

local function isMoving()
  return Player.dx ~= 0 or Player.dy ~= 0
end

local function tlen(t)
  local count = 0

  for _ in pairs(t) do
    count = count + 1
  end

  return count
end

Player = {
  x = 1,
  y = 1,
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
  Player.x = Player.x + Player.dx * TILE * dt
  Player.y = Player.y + Player.dy * TILE * dt
end

function love.draw()
  Map:draw()
  love.graphics.draw(Spritesheet, PlayerQuad, Player.x, Player.y)
end

function love.keypressed(key, scancode, isrepeat)
  if isrepeat then return end

  Keys[key] = true
  print("#IN", tlen(Keys))
  if key == "escape" then
     love.event.quit()
  elseif isDirection(key) then
    local dx, dy = getDirection(key)
    if not isMovable(dx, dy) or isMoving() then
      print("OPE")
      table.insert(MoveQueue, { dx, dy })
      return
    end

    local nx = Player.x + dx
    local ny = Player.y + dy
    local layer = Map.layers[1]
    local gid = layer:getTileAtPixelPosition(nx, ny)
    local issolid = Map:getTileProperty(gid, "solid")

    if issolid then return end
  
    Player.dx = dx
    Player.dy = dy
  end
end

function love.keyreleased(key, scancode)
  Keys[key] = nil
  print("#" .. tlen(Keys))
  if isDirection(key) and tlen(MoveQueue) > 0 then
    local queuedMove = MoveQueue[1]
    table.remove(MoveQueue, 1)
    local dx, dy = unpack(queuedMove)
    Player.dx = dx
    Player.dy = dy
  else
    Player.dx = 0
    Player.dy = 0
  end
end