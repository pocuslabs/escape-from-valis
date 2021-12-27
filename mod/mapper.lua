local mapper = {
  memo = {}
}

function mapper.generate(number)
  number = number or 1
  -- we should cache the levels so we can call generate any number of times
  if mapper.memo[number] then
    return mapper.memo[number]
  end

  local level = {
    number = number,  -- the number of the level we're on
    rooms = {},  -- each room will be a 2D table of tile numbers
    tiles = {}
  }

  local MIN_SIZE = 3
  local MAX_SIZE = 10
  local MAX_ROOMS = 10
  local numRooms = love.math.random(MAX_ROOMS)

  for _ in numRooms do
    local roomSize = love.math.random(MIN_SIZE, MAX_SIZE)
    local room = {}

    for x in roomSize do
      local row = {}

      for y in roomSize do
        table.insert(row, 0)
      end

      table.insert(room, row)
    end

    table.insert(level.rooms, room)
  end

  mapper.memo[number] = level
  return level
end

return mapper
