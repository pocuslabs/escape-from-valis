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
    local selector, img = spritely.load(tileSheet)
    local quad = selector(1, 1)
    assert.is_truthy(img:typeOf(love.Image))
    assert.is_truthy(quad:typeOf(love.Quad))
  end)

  it("takes margins into account", function()
    local margin = 2
    local selector = spritely.load(tileSheet, { margin = margin })
    local tx = 4
    local ty = 3
    local quad = selector(tx, ty)
    local expectedX = 98  -- (x - 1) * const.TILE_SIZE + margin
    local expectedY = 66  -- same for y

    local qx, qy = quad:getViewport()
    assert.are.equal(qx, expectedX)
    assert.are.equal(qy, expectedY)
  end)

  it("takes padding into account", function()
    local padding = 2
    local selector = spritely.load(tileSheet, { padding = padding })
    local tx = 3
    local ty = 4
    local quad = selector(tx, ty)
    local expectedX = 66
    local expectedY = 100

    local qx, qy = quad:getViewport()
    assert.are.equal(expectedX, qx)
    assert.are.equal(expectedY, qy)
  end)

  it("takes both margins and padding into account", function()
    local margin = 2
    local padding = 2
    local selector = spritely.load(tileSheet, { margin = margin, padding = padding })
    local tx = 3
    local ty = 4
    local quad = selector(tx, ty)
    local expectedX = 68
    local expectedY = 102

    local qx, qy = quad:getViewport()
    assert.are.equal(expectedX, qx)
    assert.are.equal(expectedY, qy)
  end)

  it("handles out of bounds errors gracefully", function ()
    local selector = spritely.load(tileSheet)
    local zx = 0
    local zy = 0
    local quad = selector(zx, zy)
    local expectedX = 0
    local expectedY = 0

    local qx, qy = quad:getViewport()
    assert.are.equal(expectedX, qx)
    assert.are.equal(expectedY, qy)
  end)
end)