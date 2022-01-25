require("lib.batteries"):export()
Object = require("lib.classic")
Gamestate = require("lib.hump.gamestate")

local spritely = require("mod.spritely")
local const = require("mod.constants")
local overworldState = require("mod.states.overworld")
local Player = require("mod.player")
local Keys = require("mod.keys")
local Level = require("mod.level")
local lurker = require("lib.lurker")

Game = {
  keys = {},
  showIntro = true,
  currentLevel = 1,
}

function love.conf(t)
  t.identity = "escape-from-valis"
  t.console = true
end

function love.update()
  lurker.update()
end

function love.load()
  -- love.window.setIcon(love.graphics.newImage(""))
  love.window.setTitle("Escape from Valis!")
  love.window.setMode(const.WIDTH, const.HEIGHT)
  local font = love.graphics.newFont("fonts/merriweather/Merriweather-Regular.ttf", 32)
  love.graphics.setFont(font)

  local selector, playerSheet = spritely.load("gfx/blowhard2.png", { padding = 2, margin = 2 })
  local quad = selector(1, 1)

  local screenW, screenH = love.graphics.getPixelDimensions()
  Game.level = Level(Game.currentLevel, screenW, screenH)
  local p1 = Player(playerSheet, quad)
  Game.world:add(p1.bumpId, p1.x, p1.y, p1.w, p1.h)
  Game.player = p1
  Game.keys = Keys()

  Gamestate.registerEvents()
  Gamestate.switch(overworldState)
end
