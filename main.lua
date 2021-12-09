Object = require "lib/classic"
local cartographer = require "lib/cartographer"
local helium = require "lib/helium"

local const = require "mod/constants"
local spritely = require "mod/spritely"
local Player = require "mod/player"
local Keys = require "mod/keys"

local font = love.graphics.newFont("fonts/merriweather/Merriweather-Regular.ttf", 32)

local DEFAULT_MARGIN = 16

local function rgb(r, g, b)
  return r / 255, g / 255, b / 255
end

local DisplayModes = {
  FULL = "FULL",
  FIT = "FIT"
}

local function tlen(t)
  local count = 0

  for _ in pairs(t) do
    count = count + 1
  end

  return count
end

local function every(t)
  local res = true

  for val in pairs(t) do
    if not val then res = false end
  end

  return res
end

local function tequals(t1, t2)
  if not t1 or not t2 then return nil end

  local elementEquals = {}

  for i, v in ipairs(t1) do
    table.insert(elementEquals, t2[i] == v)
  end

  return every(elementEquals)
end

local textCreator = helium(function (param, view)
  return function ()
    local outerX = 0
    local outerY = 0
    local outerWidth = view.w
    local outerHeight = view.h
    love.graphics.setColor(rgb(100, 100, 100))
    love.graphics.rectangle("fill", outerX, outerY, outerWidth, outerHeight)

    local innerX = outerX + DEFAULT_MARGIN
    local innerY = outerY + DEFAULT_MARGIN
    local innerWidth = view.w - (DEFAULT_MARGIN * 2)
    local innerHeight = view.h - (DEFAULT_MARGIN * 2)
    love.graphics.setColor(rgb(128, 128, 128))
    love.graphics.rectangle("fill", innerX, innerY, innerWidth, innerHeight)

    local textX = innerX + DEFAULT_MARGIN
    local textY = innerY + DEFAULT_MARGIN
    local textObject = love.graphics.newText(font, param.text)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(textObject, textX, textY)
  end
end)

local function action()
  if TextBox then
    TextBox:undraw()
    TextBox = nil
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

  local winWidth, winHeight = love.graphics.getDimensions()
  local x = 16
  local w = winWidth - x - DEFAULT_MARGIN * 2
  local h = font:getHeight() * 3 + DEFAULT_MARGIN * 2
  local y = winHeight - h - DEFAULT_MARGIN * 2
  print("X, Y, W, H", x, y, w, h)
  TextBox = textCreator({ text = "Hey Dad! I like beer!" }, w, h)
  TextBox:draw(x, y)
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
