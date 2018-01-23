hyper = {"ctrl", "alt", "shift"}
require('auto_reloader')
require('hyper')

hs.loadSpoon("MuteMic")
spoon.MuteMic:bindHotkeys({toggle={hyper, "f"}})
spoon.MuteMic:start()

hostname = hs.host.localizedName()
if (hostname == "Magic Hi Sierra") then
  require('audio_switch_hackintosh')
end
require('windows')

-- function audiowatch(arg)
--   print("Audiowatch arg: ", arg)
-- end

-- hs.audiodevice.watcher.setCallback(audiowatch)
-- hs.audiodevice.watcher.start()
