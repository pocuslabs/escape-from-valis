return {
  version = "1.5",
  luaversion = "5.1",
  tiledversion = "1.7.2",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 20,
  height = 15,
  tilewidth = 16,
  tileheight = 16,
  nextlayerid = 2,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "tile16",
      firstgid = 1,
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      columns = 8,
      image = "../gfx/basictiles.png",
      imagewidth = 128,
      imageheight = 240,
      objectalignment = "unspecified",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 16,
        height = 16
      },
      properties = {},
      wangsets = {},
      tilecount = 120,
      tiles = {
        {
          id = 0,
          properties = {
            ["Solid"] = false
          }
        },
        {
          id = 62,
          properties = {
            ["Solid"] = true
          }
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 20,
      height = 15,
      id = 1,
      name = "mainlayer",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12,
        12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12,
        12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12,
        12, 12, 12, 12, 12, 12, 12, 12, 39, 39, 39, 39, 39, 12, 12, 12, 12, 12, 12, 12,
        12, 12, 12, 12, 12, 12, 39, 39, 39, 12, 12, 12, 39, 39, 12, 12, 12, 12, 12, 12,
        12, 12, 12, 12, 12, 12, 39, 12, 12, 12, 12, 12, 12, 39, 12, 12, 12, 12, 12, 12,
        12, 12, 12, 12, 12, 12, 39, 12, 12, 12, 12, 12, 12, 39, 39, 12, 12, 12, 12, 12,
        12, 12, 12, 12, 12, 12, 39, 12, 12, 12, 44, 12, 12, 39, 39, 12, 12, 12, 12, 12,
        12, 12, 12, 12, 12, 12, 39, 39, 12, 12, 12, 12, 12, 39, 12, 12, 12, 12, 12, 12,
        12, 12, 12, 12, 12, 12, 12, 39, 39, 12, 12, 12, 39, 39, 12, 12, 12, 12, 12, 12,
        12, 12, 12, 12, 12, 12, 12, 12, 39, 39, 12, 39, 39, 12, 12, 12, 12, 12, 12, 12,
        12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12,
        12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12,
        12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12,
        12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12
      }
    }
  }
}
