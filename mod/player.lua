Object = require("lib.classic")
local anim8 = require("lib.anim8")

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
  self.pxToWalk = 0
  self.dtAcc = 0
  self.moves = {}
  self.keys = {}
  self.currentMove = nil
  self.currentFrame = 0

  local g = anim8.newGrid(self.w, self.h, self.spritesheet:getWidth(), self.spritesheet:getHeight())
  self.animation = anim8.newAnimation(g(1, '1-2'), 0.2)
end

function Player:isMoving()
  return #self.moves > 0 or self.currentMove ~= nil
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
  self.dtAcc = self.dtAcc + dt * 1000
  print("DT", self.dtAcc)
  if self.dtAcc < const.DT_THRESHOLD then
    return
  end

  if not self.currentMove then 
    self.currentMove = table.remove(self.moves, 1)
  end
  local move = self.currentMove
  if not move then
    return
  end

  print("MOVE", move)
  local dx, dy, speed = 0, 0, self.speed
  
  local mx, my = unpack(self:moveDirection(move))
  local newX, newY = self.x + mx, self.y + my
  local realX, realY = Game.world:move(self.bumpId, newX, newY)
  self.x = realX
  self.y = realY
  self.animation:update(dt)
  self.dtAcc = 0
  self.currentFrame = self.currentFrame + 1
  if self.currentFrame > const.WALK_FRAMES then
    self.currentFrame = 0
    self.keys[self.currentMove] = nil
    self.currentMove = nil

    local newDir = Game.keys:hasDirection()
    if newDir then self.currentMove = newDir end
  end
end

function Player:queueMove(move)
  print("QUEUEING", move)
  self.keys[move] = true
  table.insert(self.moves, move)
end

function Player:moveDirection(move)
  if move == "right" then
    return {1, 0}
  elseif move == "left" then
    return {-1, 0}
  elseif move == "down" then
    return {0, 1}
  elseif move == "up" then
    return {0, -1}
  else
    return nil
  end
end

function Player:draw()
  self.animation:draw(self.spritesheet, self.x, self.y)
end

return Player
