
local mash = {'ctrl', 'alt', 'cmd'}

-- Hammerspoon repl:
hs.hotkey.bind(mash, 'C', hs.openConsole)


--
-- Spectacle emulation
--

function centreWindow()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:fullFrame()

  f.x = max.w/2 - f.w/2
  f.y = max.h/2 - f.h/2
  win:setFrame(f)
end

function resize(fx1, mw1, fy1, mh1, fx2, mw2, fy2, mh2, full)
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = full and screen:fullFrame() or screen:frame()

    f.x = f.x*fx1 + max.w*mw1
    f.y = f.y*fy1 + max.h*mh1
    f.w = f.x*fx2 + max.w*mw2
    f.h = f.y*fy2 + max.h*mh2
    win:setFrame(f)
end

hs.hotkey.bind({"cmd", "alt"}, "C", centreWindow)
hs.hotkey.bind({"cmd", "alt"}, "F", function() resize(0,0,0,0,   0,1,0,1) end)

-- resize and move to left/right/top/bottom half
hs.hotkey.bind({"cmd", "alt"}, "LEFT",  function() resize(0,0,0,0,   0,.5,0,1) end)
hs.hotkey.bind({"cmd", "alt"}, "RIGHT", function() resize(0,0.5,0,0, 0,.5,0,1) end)
hs.hotkey.bind({"cmd", "alt"}, "UP",    function() resize(0,0,0,0,   0,1,0,.5) end)
hs.hotkey.bind({"cmd", "alt"}, "DOWN",  function() resize(0,0,0,0.5, 0,1,0,.5) end)

--
-- WiFi
-- adapted from https://github.com/STRML/init/blob/master/hammerspoon/init.lua
--

local home = {tolv = 1, sjutton = 1}
local lastSSID = hs.wifi.currentNetwork() or ''

function ssidChangedCallback()
    newSSID = hs.wifi.currentNetwork()
	if newSSID == nil then
		-- not on Wifi
		return
	end
	
	--hs.alert('wifi ' .. newSSID .. ' <-- ' .. lastSSID)

    if home[newSSID] and not home[lastSSID] then
        -- We just joined our home WiFi network
        hs.audiodevice.defaultOutputDevice():setVolume(25)
		hs.alert('Welcome home')
    elseif not home[newSSID] and home[lastSSID] then
        -- We just departed our home WiFi network
        hs.audiodevice.defaultOutputDevice():setVolume(0)
    end

    lastSSID = newSSID
end

local wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()



-- Fancy configuration reloading
-- from http://www.hammerspoon.org/go/#fancyreload
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end

function init()

	hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', reloadConfig):start()

	-- Doesn't work with symlinks... so go straight to the git repo.
	-- from https://github.com/STRML/init/blob/master/hammerspoon/init.lua
	hs.pathwatcher.new(os.getenv("HOME") .. "/dotfiles/hammerspoon/", reloadConfig):start()

	hs.alert('🔨 Hammerspoon Reloaded', 1.0)
end


init()
