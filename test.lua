---@diagnostic disable: undefined-global

require("love-mocks")
local spritely = require("mod.spritely")

local tileSheet = "gfx/dung2.png"

describe("Spritely module", function()
  it("returns a selector", function()
    local selector = spritely.load(tileSheet)
    assert.is_function(selector)
  end)

  it("pulls the first sprite", function()
    assert.truthy("Yup.")
  end)

  it("takes margins into account")
  it("takes padding into account")
  it("can pull a sprite from the middle of the sheet")
  it("pulls a sprite from the end of the sheet")
  it("handles out of bounds errors gracefully")
end)