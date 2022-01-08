local constants = {
  WIDTH = 1024,
  HEIGHT = 768,
  TILE_SIZE = 32,
  SPEED = 2,
  DEFAULT_MARGIN = 16,
  TILES = {
    ground = {
      name = "ground",
      coordinates = {4, 3}  -- these tile coordinates will be fed into the spritely module
    },
    wall = {
      coordinates = {2, 1},
      solid = true
    },
    door = {
      coordinates = {9, 8},
      warp = true
    }
  },
  MIN_SIZE = 3,  -- sizes are in tile units, 16x16
  MAX_SIZE = 5,
  MAX_ROOMS = 10,
  MAX_DOORS = 4
}

return constants
