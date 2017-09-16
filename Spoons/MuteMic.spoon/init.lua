-- Mute Current Audio Input

-- Download: 

local obj = {}
obj.__index = obj

-- metadata

obj.name = "MuteMic"
obj.version = "0.1"
obj.author = "sQuEE"
obj.homepage = "https://github.com/prsquee"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.menuBarItem  = nil
obj.hotkeyToggle = nil

local function script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end
obj.spoonPath = script_path()

function obj:init()
  self.menuBarItem = hs.menubar.new(false)
  self.menuBarItem:setClickCallback(self.clicked)
  self.setIconState(hs.audiodevice.defaultInputDevice():inputMuted())
end

function obj:setIconState(state)
  if state then
    obj.menuBarItem:setTitle('🙊')
  else
    obj.menuBarItem:setTitle('🗣')
  end
end

function obj:bindHotkeys(mapping)
  if (self.hotkeyToggle) then
    self.hotkeyToggle:delete()
  end
  local toggleMods = mapping["toggle"][1]
  local toggleKey = mapping["toggle"][2]
  self.hotkeyToggle = hs.hotkey.new(toggleMods, toggleKey, function() self.clicked() end)

  return self
end

function obj:start()
  self.menuBarItem:returnToMenuBar()
  if self.hotkeyToggle then
    self.hotkeyToggle:enable()
  end

  return self
end

function obj:stop()
  self.menuBarItem:removeFromMenuBar()
  if self.hotkeyToggle then
    self.hotkeyToggle:disable()
  end

  return self
end

function obj.clicked()
  if hs.audiodevice.defaultInputDevice():inputMuted() then
    obj.unmute()
  else
    obj.mute()
  end
end

function obj:unmute()
  hs.audiodevice.defaultInputDevice():setInputMuted(false)
  hs.audiodevice.defaultInputDevice():setInputVolume(100)
  obj:setIconState(false)
end

function obj:mute()
  hs.audiodevice.defaultInputDevice():setInputMuted(true)
  obj:setIconState(true) -- muted, show the muted icon
end

return obj
