local dayone_cmd = '/usr/local/bin/dayone2 --journal Entertainment --tags '
local log = hs.logger.new('plex', 'debug')

log.i('init plex')
plex = hs.httpserver.new():setPort(50001):setCallback(function(method, path, headers, body)
  if method == "POST" then
    for line in body:gmatch("[^\r\n]+") do
      if line:find('event') then
        local json = hs.json.decode(line)
        if json.Player.title == 'Magic box' then
          if json.Metadata.type == 'movie' or json.Metadata.type == 'episode' then
            if json.event == "media.play" or json.event == "media.resume" then
              hs.execute("/Users/squee/bin/plex_lights.py off")
            end
            if json.event == "media.pause" or json.event == "media.stop" then
              hs.execute("/Users/squee/bin/plex_lights.py on")
            end
          end
        end
        -- log watched stuff to dayone
        if json.event == "media.scrobble" then
          local entry = ''
          local tag = json.Metadata.type
          if tag == 'movie' then
            local imdb_id = string.match(json.Metadata.guid, "tt%d+")
            local imdb = 'https://www.imdb.com/title/' .. imdb_id
            entry = string.format("%s - %s\n\n> %s\n\n[IMDB](%s)\n\n", json.Metadata.title, json.Metadata.year, json.Metadata.summary,imdb)
          end
          if tag == 'episode' then
            local tvdb = 'https://thetvdb.com/series/' ..  json.Metadata.grandparentTitle:gsub(' ', '-'):lower() ..  '/seasons/official/' .. json.Metadata.parentIndex
            entry = string.format("%s - S%02dE%02d - %s\n\n[TVDB](%s)\n\n", json.Metadata.grandparentTitle, json.Metadata.parentIndex,json.Metadata.index, json.Metadata.title, tvdb)
          end
          local cmd = dayone_cmd .. tag .. ' -- new ' .. '"' .. entry .. '"'
          log.d(cmd)
          hs.execute(cmd)
        end
        return "", 200, {}
      end
    end
  end
  return "", 200, {}
end):start()
