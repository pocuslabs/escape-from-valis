require("lib.batteries"):export()
Object = require("lib.classic")
Gamestate = require("lib.hump.gamestate")
local lurker = require("lib.lurker")

local spritely = require("mod.spritely")
local const = require("mod.constants")
local overworldState = require("mod.states.overworld")
local Player = require("mod.player")
local Keys = require("mod.keys")
local Level = require("mod.level")

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

  local selector = spritely.load("gfx/blowhard2.png", { padding = 2, margin = 2 })
  local playerSheet, quad = selector(1, 1)

---@diagnostic disable-next-line: undefined-field
  local pw, ph = love.graphics.getPixelDimensions()
  Game.level = Level(pw, ph)
  Game.player = Player(playerSheet, quad)
  Game.level.world:add(Game.player, Game.player.x, Game.player.y, Game.player.w, Game.player.h)
  Game.keys = Keys()

  Gamestate.registerEvents()
  Gamestate.switch(overworldState)
end
