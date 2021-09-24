hyper = {"ctrl", "alt", "shift"}
hypercmd = {"ctrl", "alt", "shift", "cmd"}
hostname = hs.host.localizedName()
if hostname == "Magic Catalina" then
  require("lights")
  require('plex_webhooks')
  -- {{{ audio switch
  hs.loadSpoon("AudioSwitch")
  spoon.AudioSwitch:bindHotkeys({toggle={hyper, "a"}})
  spoon.AudioSwitch:start()

  -- this is run when output,input,device number are changed
  hs.audiodevice.watcher.setCallback(function(arg)
    if string.find(arg, "dOut") then
      spoon.AudioSwitch:setOutputIcon()
      hs.timer.doAfter(1, function()
        spoon.AudioSwitch:changeInputToYeti()
      end)
    end
  end)
  hs.audiodevice.watcher.start()

  hs.urlevent.bind("audiotoggle", function(eventName, params)
      spoon.AudioSwitch:clicked()
  end)
  --}}}
end
require('auto_reloader')
require('hyper')
--{{{ mutemic
hs.loadSpoon("MuteMic")
spoon.MuteMic:bindHotkeys({toggle={hyper, "f"}})
--}}}
--{{{ screen rotation
hs.loadSpoon("RotateScreen")
spoon.RotateScreen:bindHotkeys('F12')
-- }}}-
-- {{{ windows manager
hs.loadSpoon('MiroWindowsManager')
hs.window.animationDuration = 0
spoon.MiroWindowsManager:bindHotkeys({
  up =          {hyper, "up"},
  right =       {hyper, "right"},
  down =        {hyper, "down"},
  left =        {hyper, "left"},
  fullscreen =  {hyper, "space"},
  nextScreen =  {hyper, "delete"},
  vertical =    {hyper, "\\"},
  resizeLeft =  {hypercmd, "left"},
  resizeRight = {hypercmd, "right"},
  resizeUp =    {hypercmd, "up"},
  resizeDown =  {hypercmd, "down"}
})
--}}}
--{{{ coffee
hs.loadSpoon("Coffee")
spoon.Coffee:bindHotkeys({toggle={hyper, "m"}, startSaver={hyper, "s"} })
spoon.Coffee:start()
--}}}
