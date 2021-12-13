local suit = require("lib/suit")

local Keys = require("mod/keys")
local help = require("mod/helpers")
local pauseState = require("mod/states/pause")

local gui = suit.new()

local overworldState = {}

function overworldState:update(dt)
  local player = Game.player

  if player:isMovable(Game.map) then
    player:move(dt)
  else
    if player:isColliding(Game.map) then
      player:stepBack()
    end

    player:setMovement(Game.map, 0, 0)
  end
end

function overworldState:draw()
  Game.map:draw()
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

  if player:isMoving(Game.map) then return end

  if key == "escape" then
     love.event.quit()
  elseif Keys.isDirection(key) then
    local dx, dy = Keys.getDirection(key)
    player:setMovement(Game.map, dx, dy)
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
  elseif Keys.isDirection(key) and help.tlen(Game.keys.state) > 0 then
    local firstKey
    for k in pairs(Game.keys.state) do
      firstKey = k
      break
    end

    local dx, dy = Keys.getDirection(firstKey)
    player:setMovement(Game.map, dx, dy)
  elseif key == "s" then
    player:walk()
  elseif key == "x" then
    player:act()
  end
end

return overworldState
