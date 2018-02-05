-- toggle between speakers and headpphones


local obj = {}
obj.__index = obj

-- metadata

obj.name = "AudioSwitch"
obj.version = "0.1"
obj.author = "sQuEE"
obj.homepage = "https://github.com/prsquee/hammerspoon"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.outputIcon  = nil
obj.hotkeyToggle = nil

-- all my devices
obj.headphones = hs.audiodevice.findDeviceByUID('AppleHDAEngineOutput:1F,3,0,1,2:0')
obj.speakers   = hs.audiodevice.findDeviceByUID('AppleHDAEngineOutput:1F,3,0,1,3:1')    -- this is the FIRST line out device
-- whatever = hs.audiodevice.findDeviceByUID('AppleHDAEngineOutput:1F,3,0,1,4:2')   -- this is the SECOND line out device
obj.webcamMic = hs.audiodevice.findInputByUID('AppleUSBAudioEngine:Unknown Manufacturer:HD Webcam C525:92B1D710:1')
obj.headphonesMic = hs.audiodevice.findInputByUID('AppleHDAEngineInput:1F,3,0,1,0:4')


function obj:bindHotkeys(mapping)
  if (self.hotkeyToggle) then
    self.hotkeyToggle:delete()
  end
  local toggleMods = mapping["toggle"][1]
  local toggleKey  = mapping["toggle"][2]
  self.hotkeyToggle = hs.hotkey.new(toggleMods, toggleKey, function() self.clicked() end)

  return self
end

function obj:start()
  if not self.speakers or not self.headphones then
    hs.notify.new({title="Hammerspoon", informativeText="ERROR: Some audio devices are missing", ""}):send()
    return
  end

  self.outputIcon = hs.menubar.new()
  self.outputIcon:setClickCallback(self.clicked)

  if hs.audiodevice.defaultOutputDevice():name() == self.speakers:name() then
    self.outputIcon:setTitle('🔊')
  else
    self.outputIcon:setTitle('🎧')
  end

  if self.hotkeyToggle then
    self.hotkeyToggle:enable()
  end

  return self
end

function obj:stop()
  self.outputIcon:removeFromMenuBar()
  if self.hotkeyToggle then
    self.hotkeyToggle:disable()
  end

  return self
end

function obj.clicked()
  local currentOutput = hs.audiodevice.defaultOutputDevice()

  if currentOutput:name() == obj.speakers:name() then
    obj.headphones:setDefaultOutputDevice()
    obj.headphonesMic:setDefaultInputDevice()
  else
    obj.speakers:setDefaultOutputDevice()
    obj.webcamMic:setDefaultInputDevice()
  end
end

function obj:setMenuBarIcon(arg)
  obj.outputIcon:setTitle(arg)
end

function audiowatch(arg)
  -- print("Audiowatch arg: ", arg)
  if arg == "dIn " then
    if hs.audiodevice.defaultInputDevice():inputMuted() then
      spoon.MuteMic:setMenuBarIcon('🙊')
    else
      spoon.MuteMic:setMenuBarIcon('🎙')
    end
  end
  if (arg == "dOut") then
    if hs.audiodevice.defaultOutputDevice():name() == spoon.AudioSwitch.speakers:name() then
      spoon.AudioSwitch:setMenuBarIcon('🔊')
    else
      spoon.AudioSwitch:setMenuBarIcon('🎧')
    end
  end
end

hs.audiodevice.watcher.setCallback(audiowatch)
hs.audiodevice.watcher.start()

return obj
