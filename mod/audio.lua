local music

local function load()
  -- the "stream" tells LÖVE to stream the file from disk, good for longer music tracksend
	music = love.audio.newSource("data/audio/chiptunes.mp3", "stream") 
  music:setLooping(true)
  love.audio.setEffect('reverb', {
    type = 'reverb',
    --number gain
    --number highgain
    --density = .9,
    --diffusion = .9,
    decaytime = 1
    --number decayhighratio
    --number earlygain
    --number earlydelay
    --number lategain
    --number latedelay
    --number roomrolloff
    --number airabsorption
  })
  music:setEffect('reverb')
  love.audio.play(music)
end

local function play()
  if not music then
    return
  end

end

return {
  load = load,
  play = play
}
