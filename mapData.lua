-- We load in mapString.txt and store it in world_pieces to use in our map
-- generation algorithms. We originally planned on doing this entirely through
-- random generation, but this makes for levels that are more fun and
-- enjoyable.

world_string = {}

function load_map_file(filename) 
   contents, size = love.filesystem.read(filename)
   local idx = 0
   local rowc, colc = 1
   local ret = {}

   for row in contents:gmatch("[^\r\n]+") do
      if row:gmatch("^\d$") then
         idx = idx + 1
         ret[idx] = {}
         ret[idx].difficulty = tonumber(row)
         ret[idx].data = {}
         colc = 1
         ret[idx].data[colc] = {}
      else
         for char in row:gmatch(".") do
            ret[idx].data[colc][rowc] = (char == "#")
         end
      end

      rowc = 1
      colc = colc + 1
   end

   return ret
end

world_pieces = load_map_file('mapStrings.txt')
