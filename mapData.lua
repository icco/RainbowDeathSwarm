-- We load in mapString.txt and store it in world_pieces to use in our map
-- generation algorithms. We originally planned on doing this entirely through
-- random generation, but this makes for levels that are more fun and
-- enjoyable.

world_string = {}

function load_map_file(filename) 

   -- Read from file
   contents, size = love.filesystem.read(filename)

   -- init values
   local idx = 0
   local rowc = 1
   local colc = 1
   local ret = {}
   ret.difficulties = {}
   for idx = 1, 10, 1 do
      ret.difficulties[idx] = 0
   end
   idx = 0

   -- Break into lines
   for row in contents:gmatch("[^\r\n]+") do

      -- If the row just has a number on it.
      if row:gmatch("^\d$") and tonumber(row) then
         idx = idx + 1
         ret[idx] = {}
         ret[idx].difficulty = tonumber(row)
         ret[idx].data = {}
         ret.difficulties[ret[idx].difficulty] = ret.difficulties[ret[idx].difficulty] + 1
         colc = 1
         ret[idx].data[colc] = {}
      else -- all other rows
         for char in row:gmatch(".") do
            ret[idx].data[colc][rowc] = (char == "#")
         end
      end

      rowc = 1
      colc = colc + 1
      ret[idx].data[colc] = {}
   end

   return ret
end

world_pieces = load_map_file('mapStrings.txt')
