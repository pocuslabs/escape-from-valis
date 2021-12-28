require("lib.batteries"):export()
Object = require("lib.classic")
Gamestate = require("lib.hump.gamestate")
local cartographer = require("lib.cartographer")

local spritely = require("mod.spritely")
local const = require("mod.constants")
local overworldState = require("mod.states.overworld")
local Player = require("mod.player")
local Keys = require("mod.keys")
local Map = require("mod.map")

Game = {
  keys = {},
  showIntro = true,
  currentLevel = 1,
  map = Map("gfx/dung2.png")
}

function love.conf(t)
  t.identity = "escape-from-valis"
  t.console = true
end

function love.load()
  -- love.window.setIcon(love.graphics.newImage(""))
  love.window.setTitle("Escape from Valis!")
  love.window.setMode(const.WIDTH, const.HEIGHT)
  local font = love.graphics.newFont("fonts/merriweather/Merriweather-Regular.ttf", 32)
  love.graphics.setFont(font)

  Game.level = Game.map:generate(Game.currentLevel)
  Game.map:draw(Game.level)
  local selector = spritely.load("gfx/blowhard2.png", { padding = 2, margin = 2 })
  local playerSheet, quad = selector(1, 1)

  Game.player = Player(playerSheet, quad)
  Game.keys = Keys()

  Gamestate.registerEvents()
  Gamestate.switch(overworldState)
end
