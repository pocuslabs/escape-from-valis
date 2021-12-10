Object = require "lib/classic"
local cartographer = require "lib/cartographer"
local helium = require "lib/helium"

local const = require "mod/constants"
local spritely = require "mod/spritely"
local Player = require "mod/player"
local Keys = require "mod/keys"
local widgets = require "mod/widgets"

State = {
  keys = {}
}

local function tlen(t)
  local count = 0

  for _ in pairs(t) do
    count = count + 1
  end

  return count
end

local function action()
  if State.currentText then
    State.currentText:undraw()
    State.currentText = nil
  end
end

function love.conf(t)
  t.console = true
end

function love.load()
  love.window.setMode(const.WIDTH, const.HEIGHT)
  State.map = cartographer.load("data/map.lua")
  local selector = spritely.load("gfx/blowhard2.png", { padding = 2, margin = 2 })
  local spritesheet, quad = selector(1, 1)

  State.player = Player(spritesheet, quad)
  State.keys = Keys()
  Scene = helium.scene.new(true)
  Scene:activate()

  local text, dim = widgets.makeText("Hey Dad, I like beer!")
  text:draw(dim.x, dim.y)
  State.currentText = text
end

function love.update(dt)
  local player = State.player

  if player:isMovable() then
    player:move(dt)
  else
    if player:isColliding() then
      player:stepBack()
    end

    player:setMovement(0, 0)
  end

  Scene:update(dt)
end

function love.draw()
  State.map:draw()
  State.player:draw()
  Scene:draw()
end

function love.keypressed(key, scancode, isrepeat)
  if isrepeat then return end
  local player = State.player

  State.keys:on(key)

  if key == "s" then
    player:run()
  end

  if player:isMoving() then return end

  if key == "escape" then
     love.event.quit()
  elseif Keys.isDirection(key) then
    local dx, dy = Keys.getDirection(key)
    player:setMovement(dx, dy)
  end
end

function love.keyreleased(key, scancode)
  State.keys:off(key)
  local player = State.player

  if Keys.isDirection(key) and tlen(State.keys.state) == 0 then
    player.dx = 0
    player.dy = 0
  elseif Keys.isDirection(key) and tlen(State.keys.state) > 0 then
    local firstKey
    for k in pairs(State.keys.state) do
      firstKey = k
      break
    end

    local dx, dy = Keys.getDirection(firstKey)
    player:setMovement(dx, dy)
  elseif key == "s" then
    player:walk()
  elseif key == "x" then
    action()
  end
end
