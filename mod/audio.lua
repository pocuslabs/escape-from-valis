local music

local function load()
  -- the "stream" tells LÖVE to stream the file from disk, good for longer music tracksend
	music = love.audio.newSource("data/audio/chiptunes.mp3", "stream") 
end

local function play()
  if not music then
    return
  end

  if not music:isPlaying() then
		love.audio.play(music)
	end
end

return {
  load = load,
  play = play
}
