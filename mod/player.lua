Object = require("lib.classic")

local const = require("mod.constants")

local Player = Object:extend()

function Player:new(spritesheet, quad)
  self.spritesheet = spritesheet
  self.quad = quad
  self.x = 1
  self.y = 1
  self.w = const.TILE_SIZE
  self.h = const.TILE_SIZE
  self.dx = 0
  self.dy = 0
  self.speed = 80
  self.bumpOffset = 4
  self.bumpId = { name = "Player" }
end

function Player:isMoving()
  return self.dx ~= 0 or self.dy ~= 0
end

function Player:run()
  self.speed = self.speed * 1.75
end

function Player:walk()
  self.speed = 80
end

function Player:act()
  if Game.showIntro then
    Game.showIntro = false
  end
end

function Player:update(dt)
  local dx, dy, speed = 0, 0, self.speed
  if Game.keys.state['right'] then
    dx = speed * dt
  elseif Game.keys.state['left'] then
    dx = -speed * dt
  end
  if Game.keys.state['down'] then
    dy = speed * dt
  elseif Game.keys.state['up'] then
    dy = -speed * dt
  end

  local newX = self.x + dx
  local newY = self.y + dy
  local realX, realY = Game.world:move(self.bumpId, newX, newY)
  self.x = realX
  self.y = realY
end

return Player
