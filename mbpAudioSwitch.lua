-- audio stuff on macbook pro

local airpodsIcon = hs.image.imageFromPath("airpods.png")
local outputIcon = hs.menubar.new()

function audiowatch(arg)
  print("Audiowatch arg: ", arg)
  print(hs.audiodevice.defaultOutputDevice():name())
  if arg == "dev#" then
    print("Audiowatch arg: ", arg)
    print(hs.audiodevice.defaultOutputDevice():name(), hs.audiodevice.defaultInputDevice():name())
    -- if a new input device is added, like the airpods, start a watcher for it
    spoon.MuteMic:startInputWatchers()
  end

  if arg == "dIn " then
    if hs.audiodevice.defaultInputDevice():inputMuted() then
      spoon.MuteMic:setMenuBarIcon('🙊')
    else
      spoon.MuteMic:setMenuBarIcon('🎙')
    end
  end
  if (arg == "dOut") then
    setOutputIcon()
  end
end

function setOutputIcon()
  if hs.audiodevice.defaultOutputDevice():name() == "Built-in Output" then
    outputIcon:removeFromMenuBar()
  elseif string.match(hs.audiodevice.defaultOutputDevice():name(), 'AirPods') then
    outputIcon:setTitle(nil)
    outputIcon:setIcon(airpodsIcon:setSize({w=16,h=16}))
    outputIcon:returnToMenuBar()
  elseif string.match(hs.audiodevice.defaultOutputDevice():name(), 'Dell') then
    outputIcon:setIcon(nil)
    outputIcon:setTitle('🔊')
    outputIcon:returnToMenuBar()
  end
end

function audioOutWatcher()
  print("dev_uid:", dev_uid, "event_name:", event_name, "event_scope:",event_scope, "event_element:",event_element)
  --outputDev = hs.audiodevice.findDeviceByUID(dev_uid)
  hs.audiodevice.findDeviceByUID(dev_uid):name()
--  if (event_name == 'diff' and hs.audiodevice.defaultOutputDevice():currentOutputDataSource():name() == 'Headphones') then
--      setOutputIcon()
--    end
end

for i,outputDev in ipairs(hs.audiodevice.allOutputDevices()) do
  print("watching output device: ", outputDev:name())
  outputDev:watcherCallback(audioOutWatcher):watcherStart()
end

hs.audiodevice.watcher.setCallback(audiowatch)
hs.audiodevice.watcher.start()
setOutputIcon()
