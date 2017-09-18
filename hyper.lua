hs.hotkey.bind(hyper, 'b', function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

hs.hotkey.bind(hyper, 's', function()
  ActivateScreenSaverScript = [[
    tell application "System Events"
      start current screen saver
    end tell
  ]]
  hs.osascript.applescript(ActivateScreenSaverScript)
end)

-- hyper + c to copy solution:

hs.hotkey.bind(hyper, 'c', function()
  if hs.application.frontmostApplication():name() == 'Safari' then
  CopySolution = [[
    tell application "Safari"
      set separator to "----------------------------------------" as string
      set varURL to the URL of front document as string
      set varTITLE to the name of front document as string
      set solution to separator & "
" & varTITLE & "
" & varURL & "
" & separator
      set the clipboard to solution
    end tell
  ]]
    if hs.osascript.applescript(CopySolution) then
      hs.notify.new({title="Copy Solution", informativeText="copied to clipboard"}):send()
    end
  end
end)

-- answer phone
--
hs.hotkey.bind(hyper, 'return', function()
  telephoneApp = hs.application.find('Telephone')
  telephoneApp:activate(allWindows)
  hs.timer.usleep(1000)
  if (telephoneApp:focusedWindow():title() ~= "Red Hat") then
    telephoneApp:selectMenuItem({"Call", "Answer"})

    -- really nasty workaround until audioswitch is a single spoon:
    if hostname == "Magic Sierra" then
      if headphonesMic:inputMuted() then
        headphonesMic:setInputMuted(false)
        headphonesMic:setInputVolume(100)
        --- hs.spoon.MuteMic:setIconState(false)
      end
    else
      -- check if MBP's mic is muted
      if hs.audiodevice.defaultInputDEvice():inputMuted() then
        hs.audiodevice.defaultInputDevice():setInputMuted(false)
        hs.audiodevice.defaultInputDevice():setInputVolume(100)
        -- hs.spoon.MuteMic:setIconState(true)
      end
    end
  else
    print("not a phone call window.")
  end
end)
