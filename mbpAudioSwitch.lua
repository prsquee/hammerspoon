-- audio stuff on macbook pro

-- {{{ vars
local airpodsIcon    = hs.image.imageFromPath("airpods.png"):setSize({w=16,h=16})
local speakersIcon   = hs.image.imageFromPath("speakers.png"):setSize({w=16,h=16})
local headphonesIcon = hs.image.imageFromPath("headphones.png"):setSize({w=16,h=16})
local outputIcon = hs.menubar.new():setTitle(nil)

local builtinOutput = hs.audiodevice.findDeviceByName("Built-in Output")
local digitalOutput = nil
local hotkeyToggle  = hs.hotkey.new(hyper, "a", function() toggleOutput() end)
-- }}}
-- {{{ general watcher for dev# dIn dOut events
function audiowatch(arg)
  -- print("Audiowatch arg: ", arg)
  -- print(hs.audiodevice.defaultOutputDevice():name())
  if arg == "dev#" then
    print("Audiowatch arg: ", arg)
    print(hs.audiodevice.defaultOutputDevice():name(), hs.audiodevice.defaultInputDevice():name())
    -- if a new input device is added, like the airpods, start a watcher for it
    spoon.MuteMic:startInputWatchers()
    setupAudioOutputToggle()

  elseif arg == "dIn " then
    if hs.audiodevice.defaultInputDevice():inputMuted() then
      spoon.MuteMic:setMenuBarIcon("mute")
    else
      spoon.MuteMic:setMenuBarIcon("unmute")
    end

  elseif arg == "dOut" then
    setOutputIcon()
  end
end
-- }}}
-- {{{ menubar icon setting
function setOutputIcon()
  local current = hs.audiodevice.defaultOutputDevice()
  if current:name() == "Built-in Output" then
    if current:currentOutputDataSource():name() == 'Headphones' then
      outputIcon:setIcon(headphonesIcon)
      outputIcon:returnToMenuBar()
    else
      outputIcon:removeFromMenuBar()
    end
  elseif current:name():match("AirPods") then
    outputIcon:setIcon(airpodsIcon)
    outputIcon:returnToMenuBar()
  elseif (current:name() == "DisplayPort" or current:name() == "HDMI") then
    outputIcon:setIcon(speakersIcon)
    outputIcon:returnToMenuBar()
  end
end
-- }}}
-- {{{ start watchers for each output device
function audioOutWatcher()
  print("dev_uid:", dev_uid, "event_name:", event_name, "event_scope:",event_scope, "event_element:",event_element)
  print(hs.audiodevice.findDeviceByUID(dev_uid):name())
  outputDev = hs.audiodevice.findDeviceByUID(dev_uid)
  if (event_name == 'diff' and hs.audiodevice.defaultOutputDevice():currentOutputDataSource():name() == 'Headphones') then
    setOutputIcon()
  end
end
-- }}}
-- {{{ audio device toggle
function setupAudioOutputToggle()
  -- we do have more than one device to toggle?
  if #hs.audiodevice.allOutputDevices() >= 2 then
    for i,dev in ipairs(hs.audiodevice.allOutputDevices()) do
      if (dev:name() == "DisplayPort" or dev:name() == "HDMI") then
        digitalOutput = dev
      end
    end
    -- start:
    if digitalOutput then hotkeyToggle:enable() end
  else
    -- stop:
    digitalOutput = nil
    hotkeyToggle:disable()
  end
end
function toggleOutput()
  local currentOutput = hs.audiodevice.defaultOutputDevice()
  if digitalOutput then
    if currentOutput:name() == builtinOutput:name() then
      digitalOutput:setDefaultOutputDevice()
    else
      builtinOutput:setDefaultOutputDevice()
    end
  end
end
-- }}}

for i,outputDev in ipairs(hs.audiodevice.allOutputDevices()) do
  print("watching output device: ", outputDev:name())
  outputDev:watcherCallback(audioOutWatcher):watcherStart()
end

hs.audiodevice.watcher.setCallback(audiowatch)
hs.audiodevice.watcher.start()

setOutputIcon()
setupAudioOutputToggle()
