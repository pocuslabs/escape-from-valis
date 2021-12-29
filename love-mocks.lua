-- code borrowed and modified from kikito/anim8 on github:
-- https://raw.githubusercontent.com/kikito/anim8/master/spec/love-mocks.lua
-- thank you @kikito!

-- Copyright (c) 2011 Enrique García Cota

-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, sublicense, and/or sell copies of the Software, and to
-- permit persons to whom the Software is furnished to do so, subject to
-- the following conditions:

-- The above copyright notice and this permission notice shall be included
-- in all copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
-- OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
-- IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
-- CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
-- TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
-- SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

-- mocks for LÖVE functions
local unpack = _G.unpack or table.unpack

local Quadmt = {
  __eq = function(a,b)
    if #a ~= #b then return false end
    for i,v in ipairs(a) do
      if b[i] ~= v then return false end
    end
    return true
  end,
  __tostring = function(self)
    local buffer = {}
    for i,v in ipairs(self) do
      buffer[i] = tostring(v)
    end
    return "quad: {" .. table.concat(buffer, ",") .. "}"
  end,
  getViewport = function(self)
    return unpack(self)
  end
}

Quadmt.__index = Quadmt

_G.love = {
  graphics = {
    newQuad = function(...)
      return setmetatable({...}, Quadmt)
    end,
    draw = function()
    end,
    getLastDrawq = function()
    end,
    newImage = function()
    end,
  }
}