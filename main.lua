Object = require "lib/classic"
local cartographer = require "lib/cartographer"
local helium = require "lib/helium"

local const = require "mod/constants"
local spritely = require "mod/spritely"
local Player = require "mod/player"
local Keys = require "mod/keys"
local widgets = require "mod/widgets"

local CurrentText = nil

local function tlen(t)
  local count = 0

  for _ in pairs(t) do
    count = count + 1
  end

  return count
end

local function action()
  if CurrentText then
    CurrentText:undraw()
    CurrentText = nil
  end
end

function love.conf(t)
  t.console = true
end

function love.load()
  love.window.setMode(const.WIDTH, const.HEIGHT)
  Map = cartographer.load("data/map.lua")
  local selector = spritely.load("gfx/blowhard2.png", { padding = 2, margin = 2 })
  Spritesheet, PlayerQuad = selector(1, 1)

  P1 = Player()
  KeyState = Keys()
  Scene = helium.scene.new(true)
  Scene:activate()

  local text, dim = widgets.makeText("Hey Dad, I like beer!")
  text:draw(dim.x, dim.y)
  CurrentText = text
end

function love.update(dt)
  if P1:isMovable() then
    P1:move(dt)
  else
    if P1:isColliding() then
      P1:stepBack()
    end

    P1:setMovement(0, 0)
  end

  Scene:update(dt)
end

function love.draw()
  Map:draw()
  love.graphics.draw(Spritesheet, PlayerQuad, P1.x, P1.y)
  Scene:draw()
end

function love.keypressed(key, scancode, isrepeat)
  if isrepeat then return end

  KeyState:on(key)

  if key == "s" then
    P1:run()
  end

  if P1:isMoving() then return end

  if key == "escape" then
     love.event.quit()
  elseif Keys.isDirection(key) then
    local dx, dy = Keys.getDirection(key)
    P1:setMovement(dx, dy)
  end
end

function love.keyreleased(key, scancode)
  KeyState:off(key)

  if Keys.isDirection(key) and tlen(KeyState.state) == 0 then
    P1.dx = 0
    P1.dy = 0
  elseif Keys.isDirection(key) and tlen(KeyState.state) > 0 then
    local firstKey
    for k in pairs(KeyState.state) do
      firstKey = k
      break
    end

    local dx, dy = Keys.getDirection(firstKey)
    P1:setMovement(dx, dy)
  elseif key == "s" then
    P1:walk()
  elseif key == "x" then
    action()
  end
end
