Object = require("lib.classic")

local const = require("mod.constants")

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

function Player:isMovable(level, dx, dy)
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

function Player:setMovement(level, dx, dy)
  if not self:isMovable(level, dx, dy) then
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

  local tileSize = const.TILE_SIZE * const.SCALE
  local corners = {
    { x, y },
    { math.min(x + tileSize, const.WIDTH), y },
    { x, math.min(const.HEIGHT, y + tileSize) },
    { math.min(x + tileSize, const.WIDTH), math.min(const.HEIGHT, y + tileSize) }
  }

  local isColliding = false
  local gid = nil
  for _, corner in ipairs(corners) do
    local cx, cy = unpack(corner)
    local tile = Game.level:tileAtPixels(cx, cy)
    if tile.solid then
      isColliding = true
      gid = tile
    end
  end

  return isColliding, gid
end

function Player:move(dt)
  local speed = const.TILE_SIZE * const.SCALE * const.SPEED * self.speed * dt
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
  if Game.showIntro then
    Game.showIntro = false
  end
end

function Player:draw()
  love.graphics.draw(self.spritesheet, self.quad, self.x, self.y)
end

return Player
