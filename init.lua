hyper = {"ctrl", "alt", "cmd", "shift"}
require('auto_reloader')
require('hyper')

hs.loadSpoon("MuteMic")
spoon.MuteMic:bindHotkeys({toggle={hyper, "f"}})
spoon.MuteMic:start()

hostname = hs.host.localizedName()
if (hostname == "Magic Sierra") then
  require('audio_switch_hackintosh')
end
require('windows')
