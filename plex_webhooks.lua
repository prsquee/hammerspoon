plex = hs.httpserver.new():setPort(50001):setCallback(function(method, path, headers, body)
  if method == "POST" then
    for line in body:gmatch("[^\r\n]+") do
      if line:find('event') then
        local json = hs.json.decode(line)
        if json.Player.title == 'Magic box' then
          if json.Metadata.type == 'movie' or json.Metadata.type == 'episode' then
            if json.event == "media.play" or json.event == "media.resume" then
              hs.execute("/Users/squee/bin/wall_lights.py off")
            end
            if json.event == "media.pause" or json.event == "media.stop" then
              hs.execute("/Users/squee/bin/wall_lights.py on")
            end
          end
        end
        return
      end
    end
  end
  return "", 200, {}
end):start()
