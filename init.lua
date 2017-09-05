require('auto_reloader')
require('hyper') 
-- remapping capslock to hyper can be done via karabiner-elements now
-- http://brettterpstra.com/2017/06/15/a-hyper-key-with-karabiner-elements-full-instructions/
require('mute_mic')
hostname = hs.host.localizedName()
if (hostname == "Magic Sierra") then
  require('audio_switch_hackintosh')
end
require('windows')
