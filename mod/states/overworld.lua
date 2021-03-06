local suit = require("lib.suit")

local Keys = require("mod.keys")
local help = require("mod.helpers")
local pauseState = require("mod.states.pause")
local widgets = require("mod.widgets")
local audio = require("mod.audio")

audio.load()

local introText = "Welcome to Valis!"

local gui = suit.new()

local overworldState = {}

function overworldState:update(dt)
  if Game.showIntro then
    widgets.TextBox(gui, introText)
  end

  Game.player:update(dt)
end

function overworldState:draw()
  Game.level:draw()
  Game.player:draw()
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

  if Keys.isDirection(key) then
    player:queueMove(key)
  end

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

  if key == "s" then
    player:walk()
  elseif key == "x" then
    player:act()
  end
end

return overworldState
