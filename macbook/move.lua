function get_window_under_mouse()
  local _ = hs.application
  local my_pos = hs.geometry.new(hs.mouse.getAbsolutePosition())
  local my_screen = hs.mouse.getCurrentScreen()
  return hs.fnutils.find(hs.window.orderedWindows(), function(w)
    return my_screen == w:screen() and (not w:isFullScreen()) and my_pos:inside(w:frame())
  end)
end

dragging = {}                   -- global variable to hold the dragging/resizing state
drag_event = hs.eventtap.new({ hs.eventtap.event.types.mouseMoved }, function(e)
      if not dragging then return nil end
      if dragging.mode == 3 then -- just move
         -- local dx = e:getProperty(hs.eventtap.event.properties.mouseEventDeltaX)
         -- local dy = e:getProperty(hs.eventtap.event.properties.mouseEventDeltaY)
        dragging.win:move(
          {
            e:getProperty(hs.eventtap.event.properties.mouseEventDeltaX),
            e:getProperty(hs.eventtap.event.properties.mouseEventDeltaY)
          }, nil, false, 0
        )
      end
end)

flags_event = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function(e)
      local flags = e:getFlags()
      local mode=(flags.ctrl and 3 or 0)
      if mode == 3 then
         if dragging then
            if dragging.mode == mode then return nil end -- already working
         else
            -- only update window if we hadn't started dragging/resizing already
            dragging={win = get_window_under_mouse()}
            if not dragging.win then -- no good window
               dragging=nil
               return nil
            end
         end
         dragging.mode = mode   -- 3=drag, 5=resize
         drag_event:start()
      else                      -- not a valid mode
         if dragging then
            drag_event:stop()
            dragging = nil
         end
      end
      return nil
end)
flags_event:start()
