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

   -- Initialize the number of pieces with each difficulty to 0
   ret.difficulties = {}
   for idx = 1, 10, 1 do
      ret.difficulties[idx] = 0
   end

   -- Initialize the starting index where each difficulty can be found to 0
   ret.startIndeces = {}
   for idx = 1, 10, 1 do
      ret.startIndeces[idx] = 0
   end

   idx = 0

   -- Break the file input into lines
   for row in contents:gmatch("[^\r\n]+") do
      -- If the row just has a number on it.
      if row:gmatch("^\d$") and tonumber(row) then
         idx = idx + 1
         ret[idx] = {}

         -- If the start Index for this difficulty level is 0, store the real 
         -- start index for this difficulty
         if (ret.startIndeces[ret[idx].difficulty] == 0) then
            ret.startIndeces[ret[idx].difficulty] = idx
         end

         ret[idx].difficulty = tonumber(row)
         ret[idx].data = {}
         ret.difficulties[ret[idx].difficulty] = ret.difficulties[ret[idx].difficulty] + 1
         colc = 1
         ret[idx].data[colc] = {}
      else -- all other rows
         for char in row:gmatch(".") do
            if char then
               ret[idx].data[colc][rowc] = (char == "#")
               print("storing " .. tostring(char == "#") .. " for " .. char .. " " .. idx .. " " .. rowc .. " " .. colc)
               rowc = rowc + 1
            end
         end
         colc = colc + 1
      end

      rowc = 1
      ret[idx].data[colc] = {}
   end

   return ret
end

-- The input file MUST have the maps in order of difficulty!
world_pieces = load_map_file('mapStrings.txt')
