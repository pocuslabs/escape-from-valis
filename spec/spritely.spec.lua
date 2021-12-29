---@diagnostic disable: undefined-global

require("busted")
require("love-mocks")
local spritely = require("mod.spritely")
local const = require("mod.constants")

local tileSheet = "gfx/dung2.png"

describe("Spritely module", function()
  it("returns a selector function", function()
    local selector = spritely.load(tileSheet)
    assert.is_function(selector)
  end)

  it("pulls the first sprite", function()
    local selector = spritely.load(tileSheet)
    local img, quad = selector(1, 1)
    assert.is_truthy(img:typeOf(love.Image))
    assert.is_truthy(quad:typeOf(love.Quad))
  end)

  it("takes margins into account", function()
    local margin = 2
    local selector = spritely.load(tileSheet, { margin = margin })
    local tx = 4
    local ty = 3
    local tileSize = const.TILE_SIZE
    local img, quad = selector(tx, ty)
    local expectedX = (tx - 1) * tileSize + margin
    local expectedY = (ty - 1) * tileSize + margin

    local qx, qy = quad:getViewport()
    assert.are.equal(qx, expectedX)
    assert.are.equal(qy, expectedY)
  end)

  it("takes padding into account")
  it("takes both margins and padding into account")
  it("can pull a sprite from the middle of the sheet")
  it("pulls a sprite from the end of the sheet")
  it("handles out of bounds errors gracefully")
end)