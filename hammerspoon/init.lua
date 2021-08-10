
local mash = {'ctrl', 'alt', 'cmd'}

-- Hammerspoon repl:
hs.hotkey.bind(mash, 'C', hs.openConsole)


--
-- Spectacle emulation
--

function resizeWindow(fn1, reference)
  local win = hs.window.focusedWindow()

  if not win then
    return
  end

  local f = win:frame()
  local screen = win:screen()
  local dims = {full=screen:fullFrame(), screen=screen:frame(), window=win:frame()}
  local max = reference and dims[reference] or screen:frame()

  f = fn1(f, max)
  win:setFrame(f)
end

-- center window on screen
hs.hotkey.bind({"cmd", "alt"}, "C", function() resizeWindow( function(f,m)
  return {x=m.w/2-f.w/2, y=m.h/2-f.h/2, w=f.w, h=f.h}
end, 'full') end)

-- expand to full screen
hs.hotkey.bind({"cmd", "alt"}, "F", function() resizeWindow( function(f,m)
  return {x=0, y=0, w=m.w, h=m.h}
end) end)

-- resize and move to left/right/top/bottom half
hs.hotkey.bind({"cmd", "alt"}, "left",  function() resizeWindow( function(f,m)
  return {x=0, y=0, w=m.w/2, h=m.h}
end) end)
hs.hotkey.bind({"cmd", "alt"}, "right", function() resizeWindow( function(f,m)
  return {x=m.w/2, y=0, w=m.w/2, h=m.h}
end) end)
hs.hotkey.bind({"cmd", "alt"}, "up",    function() resizeWindow( function(f,m)
  return {x=0, y=0, w=m.w, h=m.h/2}
end) end)
hs.hotkey.bind({"cmd", "alt"}, "down",  function() resizeWindow( function(f,m)
  return {x=0, y=m.h/2, w=m.w, h=m.h/2}
end) end)


-- snap to tl/bl/tr/br corners
hs.hotkey.bind({"cmd", "alt"}, "home",  function() resizeWindow( function(f,m)
  return {x=0, y=0, w=f.w, h=f.h}
end) end)
hs.hotkey.bind({"cmd", "alt"}, "end",  function() resizeWindow( function(f,m)
  return {x=0, y=m.h-f.h, w=f.w, h=f.h}
end) end)
hs.hotkey.bind({"cmd", "alt"}, "pageup",  function() resizeWindow( function(f,m)
  return {x=m.w-f.w, y=0, w=f.w, h=f.h}
end) end)
hs.hotkey.bind({"cmd", "alt"}, "pagedown",  function() resizeWindow( function(f,m)
  return {x=m.w-f.w, y=m.h-f.h, w=f.w, h=f.h}
end) end)

function quadrant(f, m)
  if f.x>m.w/2 then
    if f.y>m.h/2 then
      return 4
    else
      return 1
    end
  else
    if f.y>m.h/2 then
      return 3
    else
      return 2
    end
  end
end

function growWindow(scale)
  return 
    function() resizeWindow( 
        function(f,m)
          local tl=quadrant({x=f.x,y=f.y}, {w=m.w,h=m.h})
          local br=quadrant({x=f.x+f.w,y=f.y+f.h}, {w=m.w,h=m.h})
          local dx=f.w*scale
          local dy=f.h*scale
          local r={w=f.w+dx, h=f.h+dy}
          
          -- FIXME need to improve decision logic here
          if tl==2 or (tl==1 and br==4) or (tl==3 and br==4) then
            -- grow bottom right corner
            hs.alert('grow br')
            r.x, r.y=f.x, f.y
          elseif tl==3 and br==3 then
            -- grow top right corner
            hs.alert('grow tr')
            r.x, r.y=f.x, f.y-dy
          elseif tl==1 and br==1 then
            -- grow bottom left corner
            hs.alert('grow bl')
            r.x, r.y=f.x-dx, f.y
          else
            -- grow top left corner
            hs.alert('grow tl')
            r.x, r.y=f.x-dx, f.y-dy
          end
          return r
          end )
      end
end

hs.hotkey.bind({"cmd", "alt", "shift"}, "up", growWindow(0.1))
hs.hotkey.bind({"cmd", "alt", "shift"}, "down", growWindow(-0.1))


--
-- Window focus
-- adapted from http://larryhynes.net/2015/04/a-minor-update-to-my-hammerspoon-config.html
--

if 0 then
hs.hotkey.bind(mash, 'k', function()
  if hs.window.focusedWindow() then
    hs.window.focusedWindow():focusWindowNorth()
  else
    hs.alert.show("No active window")
  end
end)

hs.hotkey.bind(mash, 'j', function()
  if hs.window.focusedWindow() then
    hs.window.focusedWindow():focusWindowSouth()
  else
    hs.alert.show("No active window")
  end
end)

hs.hotkey.bind(mash, 'l', function()
  if hs.window.focusedWindow() then
    hs.window.focusedWindow():focusWindowEast()
  else
    hs.alert.show("No active window")
  end
end)

hs.hotkey.bind(mash, 'h', function()
  if hs.window.focusedWindow() then
    hs.window.focusedWindow():focusWindowWest()
  else
    hs.alert.show("No active window")
  end
end)
end


--
-- WiFi
-- adapted from https://github.com/STRML/init/blob/master/hammerspoon/init.lua
--

local home = {tolv = 1, sjutton = 1, tusan = 1}
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
