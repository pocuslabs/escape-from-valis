Object = require("lib/classic")
local const = require("mod/constants")

local Player = Object:extend()

function Player:new(spritesheet, quad)
  self.spritesheet = spritesheet
  self.quad = quad
  self.x = 1
  self.y = 1
  self.dx = 0
  self.dy = 0
  self.speed = 1
end

function Player:isMovable(map, dx, dy)
  dx = dx or 0
  dy = dy or 0
  local nx = self.x + dx
  local ny = self.y + dy

  local isColliding = self:isColliding(map, nx, ny)

  return not isColliding and nx >= 0 and nx <= const.WIDTH and ny >= 0 and ny <= const.HEIGHT
end

function Player:isMoving()
  return self.dx ~= 0 or self.dy ~= 0
end

function Player:setMovement(map, dx, dy)
  if not self:isMovable(map, dx, dy) then
    return
  end

  local nx = self.x + dx
  local ny = self.y + dy
  local isColliding = self:isColliding(map, nx, ny)

  if isColliding then return end

  self.dx = dx
  self.dy = dy
end

function Player:isColliding(map, x, y)
  if not x or not y then
    x = self.x
    y = self.y
  end

  local corners = {
    { x, y },
    { math.min(x + const.TILE_SIZE, const.WIDTH), y },
    { x, math.min(const.HEIGHT, y + const.TILE_SIZE) },
    { math.min(x + const.TILE_SIZE, const.WIDTH), math.min(const.HEIGHT, y + const.TILE_SIZE) }
  }

  local isColliding = false
  local gid = nil
  for _, corner in ipairs(corners) do
    local cx, cy = unpack(corner)
    local layer = map.layers[1]
    local thisGid = layer:getTileAtPixelPosition(cx, cy)
    local issolid = map:getTileProperty(thisGid, "Solid")
    if issolid then
      isColliding = true
      gid = thisGid
    end
  end

  return isColliding, gid
end

function Player:stepBack()
  self.x = self.ox
  self.y = self.oy
end

function Player:move(dt)
  local speed = const.TILE_SIZE * const.SPEED * self.speed * dt
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

function Player:act()
  if Game.currentText then
    Game.currentText:undraw()
    Game.currentText = nil
  end
end

function Player:draw()
  love.graphics.draw(self.spritesheet, self.quad, self.x, self.y)
end

return Player
