hs.hotkey.bind(hyper, 'b', function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

-- answer phone
-- hs.hotkey.bind(hyper, 'return', function()
--   telephoneApp = hs.application.find('Telephone')
--   telephoneApp:activate(allWindows)
--   hs.timer.usleep(1000)
--   if (telephoneApp:focusedWindow():title() ~= "Red Hat") then
--     telephoneApp:selectMenuItem({"Call", "Answer"})
-- 
--     if hostname == "Magic Mojave" then
--       spoon.AudioSwitch.headphonesMic:setDefaultInputDevice()
--       if spoon.AudioSwitch.headphonesMic:inputMuted() then
--         spoon.AudioSwitch.headphonesMic:setInputMuted(false)
--         spoon.AudioSwitch.headphonesMic:setInputVolume(100)
--       end
--     -- check if MBP's mic is muted
--     elseif hs.audiodevice.defaultInputDevice():inputMuted() then
--       hs.audiodevice.defaultInputDevice():setInputMuted(false)
--       hs.audiodevice.defaultInputDevice():setInputVolume(100)
--     end
--   else
--     print("not a phone call window.")
--   end
-- end)

-- use hyper -/= to move between spaces
-- cant change ctrl left/right because of logitech options
hs.hotkey.bind(hyper, '-', function() hs.eventtap.keyStroke({'ctrl'}, 'left') end)
hs.hotkey.bind(hyper, '=', function() hs.eventtap.keyStroke({'ctrl'}, 'right') end)
