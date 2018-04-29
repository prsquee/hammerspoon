hyper = {"ctrl", "alt", "shift"}
require('auto_reloader')
require('hyper')

hs.loadSpoon("MuteMic")
spoon.MuteMic:bindHotkeys({toggle={hyper, "f"}})
spoon.MuteMic:start()

hostname = hs.host.localizedName()
if hostname == "Magic Hi Sierra" then
  -- require('audio_switch_hackintosh')
  -- print('hackintosh')
  hs.loadSpoon("AudioSwitch")
  spoon.AudioSwitch:bindHotkeys({toggle={hyper, "a"}})
  spoon.AudioSwitch:start()
end
if hostname == "multivac" then
  -- spoon.MuteMic:mbpHeadphonesWatcher()
  require("mbpAudioSwitch")
end

hs.loadSpoon('MiroWindowsManager')
hs.window.animationDuration = 0
spoon.MiroWindowsManager:bindHotkeys({
  up = {hyper, "["},
  right = {hyper, "]"},
  down = {hyper, "p"},
  left = {hyper, "o"},
  fullscreen = {hyper, "space"},
  vertical = {hyper, "\\"}

})
