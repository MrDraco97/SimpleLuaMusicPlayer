local playlists = {
    playlist1 = {
        "music1.mp3",
        "music2.mp3",
        "music3.mp3",
        "music4.mp3",
        "music5.mp3",
        "music6.mp3"
    },
    playlist2 = {
        "music7.mp3",
        "music8.mp3",
        "music9.mp3",
        "music10.mp3",
        "music11.mp3",
        "music12.mp3"
    }
}

local currentPlaylist = "playlist1"
local playlistName = "Playlist-1"
local currentTrack = 1
local music = love.audio.newSource(playlists[currentPlaylist][currentTrack], "stream")
local isPlaying = false
local volume = 1.0
local isLooping = false
local isDragging = false

function love.load()
    love.window.setTitle("Music Player")
    love.window.setMode(400, 200)
end

function love.keypressed(key)
    if key == "space" then
        if isPlaying then
            love.audio.pause(music)
            isPlaying = false
        else
            love.audio.play(music)
            isPlaying = true
        end
    elseif key == "right" then
        currentTrack = currentTrack + 1
        if currentTrack > #playlists[currentPlaylist] then
            currentTrack = 1
        end
        love.audio.stop(music)
        music = love.audio.newSource(playlists[currentPlaylist][currentTrack], "stream")
        music:setLooping(isLooping)
        love.audio.play(music)
    elseif key == "left" then
        currentTrack = currentTrack - 1
        if currentTrack < 1 then
            currentTrack = #playlists[currentPlaylist]
        end
        love.audio.stop(music)
        music = love.audio.newSource(playlists[currentPlaylist][currentTrack], "stream")
        music:setLooping(isLooping)
        love.audio.play(music)
    elseif key == "p" then
        if currentPlaylist == "playlist1" then
            currentPlaylist = "playlist2" 
            playlistName = "Playlist-2"
        else
            currentPlaylist = "playlist1"
            playlistName = "Playlist-1"
        end
        currentTrack = 1
        love.audio.stop(music)
        music = love.audio.newSource(playlists[currentPlaylist][currentTrack], "stream")
        music:setLooping(isLooping)
        love.audio.play(music)
    elseif key == "l" then
        isLooping = not isLooping
        music:setLooping(isLooping)
    end
end

function love.update(dt)
    if isDragging then
        local mouseX = love.mouse.getX()
        local volumeFraction = (mouseX - 20) / 360
        volume = math.max(0, math.min(1, volumeFraction))
    end
    love.audio.setVolume(volume)
end

function love.draw()
    love.graphics.setBackgroundColor(0, 0, 1)
    love.graphics.print("Press Space to Pause/Play", 20, 20)
    love.graphics.print("Press Right to Skip Forward", 20, 40)
    love.graphics.print("Press Left to Skip Backward", 20, 60)
    love.graphics.print("Press P to Switch Playlist", 20, 80)
    love.graphics.print("Current Playlist: " .. playlistName, 20, 100)
    love.graphics.print("Press L to Toggle Looping: " .. tostring(isLooping), 20, 120)
    love.graphics.print("Volume: " .. tostring(math.floor(volume * 100)) .. "%", 20, 140)
    love.graphics.rectangle("fill", 20, 160, volume * 360, 20)
end

function love.mousepressed(x, y, button)
    if button == 1 and y >= 160 and y <= 180 then
        isDragging = true
    end
end

function love.mousereleased(x, y, button)
    if button == 1 then
        isDragging = false
    end
end