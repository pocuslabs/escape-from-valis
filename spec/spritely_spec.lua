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
    local tileSize = const.TILE_SIZE * const.SCALE
    local img, quad = selector(tx, ty)
    local expectedX = (tx - 1) * tileSize + margin
    local expectedY = (ty - 1) * tileSize + margin

    local qx, qy = quad:getViewport()
    assert.are.equal(qx, expectedX)
    assert.are.equal(qy, expectedY)
  end)

  it("takes padding into account", function()
    local padding = 2
    local selector = spritely.load(tileSheet, { padding = padding })
    local tx = 3
    local ty = 4
    local tileSize = const.TILE_SIZE * const.SCALE
    local img, quad = selector(tx, ty)
    local expectedX = 66
    local expectedY = 100

    local qx, qy = quad:getViewport()
    assert.are.equal(expectedX, qx)
    assert.are.equal(expectedY, qy)
  end)

  it("takes both margins and padding into account")
  it("handles out of bounds errors gracefully")
end)