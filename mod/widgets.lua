local const = require("mod.constants")
local helpers = require("mod.helpers")

local theme = require("mod.theme")

local rgba = helpers.rgba
local DEFAULT_MARGIN = const.DEFAULT_MARGIN

local function TextBox(core, text, ...)
	local opt, x,y,w,h = core.getOptionsAndSize(...)
	opt.id = opt.id or text
	opt.font = opt.font or love.graphics.getFont()

	local winWidth, winHeight = love.graphics.getDimensions()
  local font = love.graphics.getFont()

  x = x or DEFAULT_MARGIN
  w = w or winWidth - x - DEFAULT_MARGIN * 2
  h = h or font:getHeight() * 2 + DEFAULT_MARGIN * 2
  y = y or winHeight - DEFAULT_MARGIN * 2

	opt.state = core:registerHitbox(opt.id, x,y,w,h)
	core:registerDraw(opt.draw or theme.TextBox, text, opt, x,y,w,h)

	return {
		id = opt.id,
		hit = core:mouseReleasedOn(opt.id),
		hovered = core:isHovered(opt.id),
		entered = core:isHovered(opt.id) and not core:wasHovered(opt.id),
		left = not core:isHovered(opt.id) and core:wasHovered(opt.id)
	}
end

local widgets = {
  TextBox = TextBox
}

return widgets
