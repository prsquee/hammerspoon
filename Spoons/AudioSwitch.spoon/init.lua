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
obj.speakers = nil
obj.speakersIcon = nil
obj.headphones = nil

local function script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end
obj.spoonPath = script_path()


obj.speakers     = hs.audiodevice.findDeviceByName("Built-in Output")
obj.speakersIcon = hs.image.imageFromPath(script_path() .. "harman.png"):setSize({w=18,h=18})
obj.headphones   = hs.audiodevice.findDeviceByName('Built-in Line Output')
obj.headphonesIcon = "􀑈"
obj.speakersIcon   = "􀝏"
obj.airpodsProIcon = "􀪷"
obj.airpodsMaxIcon = "􀺹"
obj.iconFontSize   = 19
obj.iconOffset     = -1


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
  self.outputIcon = hs.menubar.new()
  self.outputIcon:setClickCallback(self.clicked)

  self.setOutputIcon()

  hs.audiodevice.watcher.setCallback(function(event)
    if event == "dOut" then
      obj.setOutputIcon()
    elseif event == "dev#" then
      -- a device (dis)connected; give macOS a moment to settle the default
      hs.timer.doAfter(1, function() obj.setOutputIcon() end)
    end
  end)
  hs.audiodevice.watcher.start()

  if self.hotkeyToggle then
    self.hotkeyToggle:enable()
  end

  return self
end

function obj:stop()
  if self.outputIcon then
    self.outputIcon:removeFromMenuBar()
    self.outputIcon = nil
  end

  if self.hotkeyToggle then
    self.hotkeyToggle:disable()
  end
  return self
end

function obj.clicked()
  local currentOutput = hs.audiodevice.defaultOutputDevice()

  if currentOutput:name() == obj.speakers:name() then
    obj.headphones:setDefaultOutputDevice()
  else
    obj.speakers:setDefaultOutputDevice()
  end
end

function obj.iconForDevice(dev)
  local name = (dev and dev:name()) or ""

  if obj.speakers and name == obj.speakers:name() then
    return obj.speakersIcon
  elseif name:find("AirPods Max", 1, true) then
    return obj.airpodsMaxIcon
  elseif name:find("AirPods Pro", 1, true) then
    return obj.airpodsProIcon
  else
    return obj.headphonesIcon
  end
end

function obj.setOutputIcon()
  local dev = hs.audiodevice.defaultOutputDevice()
  print(dev and dev:name())

  local glyph = obj.iconForDevice(dev)

  obj.outputIcon:setIcon(nil)
  obj.outputIcon:setTitle(hs.styledtext.new(glyph, {
    font = { name = ".AppleSystemUIFont", size = obj.iconFontSize },
    baselineOffset = obj.iconOffset
  }))
end

return obj
