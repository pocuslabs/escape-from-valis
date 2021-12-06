Object = require "lib/classic"
local const = require("mod/constants")

local Player = Object:extend()

function Player:new(x, y)
  self.x = x or 1
  self.y = y or 1
  self.dx = 0
  self.dy = 0
  self.speed = 1
end

function Player:isMovable(dx, dy)
  dx = dx or 0
  dy = dy or 0
  local nx = self.x + dx
  local ny = self.y + dy

  local isColliding = self:isColliding(nx, ny)

  return not isColliding and nx >= 0 and nx <= const.WIDTH and ny >= 0 and ny <= const.HEIGHT
end

function Player:isMoving()
  return self.dx ~= 0 or self.dy ~= 0
end

function Player:setMovement(dx, dy)
  if not self:isMovable(dx, dy) then
    return
  end

  local nx = self.x + dx
  local ny = self.y + dy
  local isColliding = self:isColliding(nx, ny)

  if isColliding then return end

  self.dx = dx
  self.dy = dy
end

function Player:isColliding(x, y)
  if not x or not y then
    x = self.x
    y = self.y
  end

  local corners = {
    { x, y },
    { math.min(x + const.TILE, const.WIDTH), y },
    { x, math.min(const.HEIGHT, y + const.TILE) },
    { math.min(x + const.TILE, const.WIDTH), math.min(const.HEIGHT, y + const.TILE) }
  }

  local isColliding = false
  for _, corner in ipairs(corners) do
    local cx, cy = unpack(corner)
    local layer = Map.layers[1]
    local gid = layer:getTileAtPixelPosition(cx, cy)
    local issolid = Map:getTileProperty(gid, "Solid")
    if issolid then
      isColliding = true
    end
  end

  return isColliding
end

function Player:stepBack()
  self.x = self.ox
  self.y = self.oy
end

function Player:move(dt)
  local speed = const.TILE * const.SPEED * self.speed * dt
  self.ox = self.x
  self.x = self.x + self.dx * speed
  self.oy = self.y
  self.y = self.y + self.dy * speed
end

function Player:run()
  self.speed = 1.75
end

function Player:walk()
  self.speed = 1
end

return Player
