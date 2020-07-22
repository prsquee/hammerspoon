local function watch_for_screen(event)
  if event == hs.caffeinate.watcher.screensDidSleep then
    -- print(string.format("caffeinate event %d", event))
    -- print("screens went to sleep")
    hs.execute("/Users/squee/bin/computerlights.py off")
  elseif event == hs.caffeinate.watcher.screensDidUnlock then
    -- print(string.format("caffeinate event %d", event))
    -- print("screens woke up")
    hs.execute("/Users/squee/bin/computerlights.py on")
  end
end
local watcher = hs.caffeinate.watcher.new(watch_for_screen):start()
