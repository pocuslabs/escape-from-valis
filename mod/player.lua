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

  if dx ~= 0 or dy ~= 0 then
    local cols
    self.x, self.y, cols, cols_len = Game.level.world:move(self, self.x + dx, self.y + dy)
    for i=1, cols_len do
      local col = cols[i]
      print(("col.other = %s, col.type = %s, col.normal = %d,%d"):format(col.other, col.type, col.normal.x, col.normal.y))
      love.event.push('collide')
    end
  end
end

local function drawBox(box, r,g,b)
  love.graphics.setColor(r,g,b,70)
  love.graphics.rectangle("fill", box.x, box.y, box.w, box.h)
  love.graphics.setColor(r,g,b)
  love.graphics.rectangle("line", box.x, box.y, box.w, box.h)
end

function Player:draw()
  love.graphics.draw(self.spritesheet, self.quad, self.x, self.y)
  drawBox(self, 0, .4, .4)
end

return Player
