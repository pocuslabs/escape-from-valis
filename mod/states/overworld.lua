local suit = require("lib.suit")
local anim8 = require("lib.anim8")

local Keys = require("mod.keys")
local help = require("mod.helpers")
local pauseState = require("mod.states.pause")
local widgets = require("mod.widgets")
local audio = require("mod.audio")

audio.load()

local introText = "Welcome to Valis!"

local gui = suit.new()

local overworldState = {}

function overworldState:init()
  local image = Game.player.spritesheet
  local g = anim8.newGrid(32, 32, image:getWidth(), image:getHeight())
  Game.playerAnimation = anim8.newAnimation(g(1,'1-2'), 0.2)
end

function overworldState:update(dt)
  if Game.showIntro then
    widgets.TextBox(gui, introText)
  end

  Game.player:update(dt)
  Game.playerAnimation:update(dt)
end

function overworldState:draw()
  Game.level:draw()
  Game.playerAnimation:draw(Game.player.spritesheet, Game.player.x, Game.player.y)
  gui:draw()
end

function overworldState:keypressed(key, scancode, isrepeat)
  if isrepeat then return end
  local player = Game.player

  Game.keys:on(key)

  if key == "s" then
    player:run()
  end

  if player:isMoving() then return end

  if key == "escape" then
     love.event.quit()
  end
end

function overworldState:keyreleased(key, scancode)
  Game.keys:off(key)

  if key == 'return' then
    Gamestate.switch(pauseState)
    return
  end

  local player = Game.player

  if Keys.isDirection(key) and help.tlen(Game.keys.state) == 0 then
    player.dx = 0
    player.dy = 0
  elseif key == "s" then
    player:walk()
  elseif key == "x" then
    player:act()
  end
end

return overworldState
