require("lib.batteries"):export()
Object = require("lib.classic")
Gamestate = require("lib.hump.gamestate")
local cartographer = require("lib.cartographer")
local suit = require("lib.suit")

local spritely = require("mod.spritely")
local const = require("mod.constants")
local overworldState = require("mod.states.overworld")
local Player = require("mod.player")
local Keys = require("mod.keys")

Game = {
  keys = {},
  showIntro = true
}

function love.conf(t)
  t.console = true
end

function love.load()
  -- love.window.setIcon(love.graphics.newImage(""))
  love.window.setTitle("Escape from Detroit!")
  love.window.setMode(const.WIDTH, const.HEIGHT)
  local font = love.graphics.newFont("fonts/merriweather/Merriweather-Regular.ttf", 32)
  love.graphics.setFont(font)

  Game.map = cartographer.load("data/map.lua")
  local selector = spritely.load("gfx/blowhard2.png", { padding = 2, margin = 2 })
  local spritesheet, quad = selector(1, 1)

  Game.player = Player(spritesheet, quad)
  Game.keys = Keys()

  Gamestate.registerEvents()
  Gamestate.switch(overworldState)
end

function love.update(dt)

end

function love.draw()
end
