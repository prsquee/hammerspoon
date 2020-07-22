hyper = {"ctrl", "alt", "shift"}
hypercmd = {"ctrl", "alt", "shift", "cmd"}
require('auto_reloader')
require('hyper')

-- hs.loadSpoon("MuteMic")
-- spoon.MuteMic:bindHotkeys({toggle={hyper, "f"}})
-- spoon.MuteMic:start()

hs.loadSpoon("Coffee")
spoon.Coffee:bindHotkeys({toggle={hyper, "m"}, startSaver={hyper, "s"} })
spoon.Coffee:start()
hostname = hs.host.localizedName()
if hostname == "Magic Catalina" then
  -- require('audio_switch_hackintosh')
  -- print('hackintosh')
  hs.loadSpoon("AudioSwitch")
  spoon.AudioSwitch:bindHotkeys({toggle={hyper, "a"}})
  spoon.AudioSwitch:start()

  hs.loadSpoon("RotateScreen")
  spoon.RotateScreen:bindHotkeys({toggle={hyper, "`"}})
  spoon.RotateScreen:start(hs.screen'BenQ')
  require("lights")
else
  require("mbpAudioSwitch")
end

hs.loadSpoon('MiroWindowsManager')
hs.window.animationDuration = 0
spoon.MiroWindowsManager:bindHotkeys({
  up = {hyper, "up"},
  right = {hyper, "right"},
  down = {hyper, "down"},
  left = {hyper, "left"},
  fullscreen = {hyper, "space"},
  vertical = {hyper, "\\"},
  resizeLeft = {hypercmd, "left"},
  resizeRight = {hypercmd, "right"},
  resizeUp = {hypercmd, "up"},
  resizeDown = {hypercmd, "down"}
})
