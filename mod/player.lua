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
  self.bumpId = { name = "Player" }
end

function Player:isMoving()
  return self.dx ~= 0 or self.dy ~= 0
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

function Player:update(dt)
  local dx, dy, speed = 0, 0, self.speed
  if love.keyboard.isDown('right') then
    dx = speed * dt
  elseif love.keyboard.isDown('left') then
    dx = -speed * dt
  end
  if love.keyboard.isDown('down') then
    dy = speed * dt
  elseif love.keyboard.isDown('up') then
    dy = -speed * dt
  end

  local nx = self.x + dx
  local ny = self.y + dy
  local rx, ry = Game.world:move(self.bumpId, nx, ny)
  self.x = rx
  self.y = ry
end

function Player:draw()
  love.graphics.draw(self.spritesheet, self.quad, self.x, self.y)
end

return Player
