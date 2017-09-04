require('auto_reloader')
require('hyper')
require('mute_mic')

hostname = hs.host.localizedName()
if (hostname == "Magic Sierra") then
  require('audio_switch_hackintosh')
end

require('windows')
