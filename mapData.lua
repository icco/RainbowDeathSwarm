-- We load in mapString.txt and store it in world_pieces to use in our map
-- generation algorithms. We originally planned on doing this entirely through
-- random generation, but this makes for levels that are more fun and
-- enjoyable.

world_string = {}

function load_map_file(filename) 
   contents, size = love.filesystem.read(filename)
   local idx = 0

   for idx = 1, string.len(contents), 1 do
      --print(idx .. " " .. tostring(contents[i]))
   end

   return {}
end

world_pieces = load_map_file('mapStrings.txt')
