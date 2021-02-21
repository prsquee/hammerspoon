hyper = {"ctrl", "alt", "shift"}
hypercmd = {"ctrl", "alt", "shift", "cmd"}
require('auto_reloader')
require('hyper')
--{{{ mutemic
hs.loadSpoon("MuteMic")
spoon.MuteMic:bindHotkeys({toggle={hyper, "f"}})
--}}}
-- {{{ audio switch
hs.loadSpoon("AudioSwitch")
yeti = hs.audiodevice.findInputByName("Yeti Stereo Microphone")
if yeti then
  yeti:setDefaultInputDevice()
  spoon.AudioSwitch:bindHotkeys({toggle={hyper, "a"}})
  spoon.AudioSwitch:start()
end

if hs.audiodevice.watcher.isRunning() then
  hs.audiodevice.watcher.stop()
end

-- this is run when output,input,device number are changed
hs.audiodevice.watcher.setCallback(function(arg)
  if string.find(arg, "dOut") then
    spoon.AudioSwitch:setOutputIcon()
  elseif string.find(arg, "dev#") then
    print('device number changed. checking for yeti')
    spoon.AudioSwitch:checkYeti()
  end
end)
hs.audiodevice.watcher.start()

hs.urlevent.bind("audiotoggle", function(eventName, params)
    spoon.AudioSwitch:clicked()
end)

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
--{{{ url dispatcher
hs.loadSpoon("URLDispatcher")
Firefox = "org.mozilla.firefox"

spoon.URLDispatcher.url_patterns = {
  {"https://rhvm%-%d+.+%.brq%.redhat%.com", Firefox},
  {"https://.+%.example%.ovirt",            Firefox},
  {"https://.+%.example%.vm",               Firefox},
  {"https://.+%.example%.com",              Firefox}
}
spoon.URLDispatcher.url_redir_decoders = {
  {"open twitter links in tweetbot", "(https://twitter%.com/)", "tweetbot://", true}
}
spoon.URLDispatcher:start()
--}}}
--
hostname = hs.host.localizedName()
if hostname == "Magic Catalina" then
  require("lights")
  require('plex_webhooks')
end
