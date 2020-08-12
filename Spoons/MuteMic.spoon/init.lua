-- Mute Current Audio Input

local obj = {}
obj.__index = obj

function obj:updateMuteState(muted)
	if muted == -1 then
		muted = hs.audiodevice.defaultInputDevice():muted()
	end
	if muted then
    obj.menuBarItem:setIcon(obj.inactiveMicIcon:setSize({w=18,h=18}))
	else
    obj.menuBarItem:setIcon(obj.activeMicIcon:setSize({w=18,h=18}))
	end
end
function obj:toggleMute()
  local input = hs.audiodevice.defaultInputDevice()
  if input:muted() then
    input:setMuted(false)
  else
    input:setMuted(true)
  end
  obj:updateMuteState(-1)
end

function obj:bindHotkeys(mapping)
  if (self.hotkeyToggle) then
    self.hotkeyToggle:delete()
  end
  local toggleMods = mapping["toggle"][1]
  local toggleKey  = mapping["toggle"][2]
  self.hotkeyToggle = hs.hotkey.new(toggleMods, toggleKey, function() self:toggleMute() end)
  self.hotkeyToggle:enable()
  return self
end

function obj:init()
  obj.menuBarItem = hs.menubar.new()
  obj.activeMicIcon   = hs.image.imageFromPath(self.spoonPath.."activeMic.png")
  obj.inactiveMicIcon = hs.image.imageFromPath(self.spoonPath.."inactiveMic.png")

  obj.menuBarItem:setClickCallback(function() obj:toggleMute() end)
  obj:updateMuteState(-1)
end
return obj
