-- This function should be called whenever we need to delete the far left column, and draw a new right column.
function updateTerrain()
   -- If the offset counter has reached 2 million
   -- then copy the map back to index 1 and reset the counter.

   -- Clear out the left hand column (map[1+offset])
   local colCount = (1 + map["counter"] + map["howLong"])

   -- Initialize this column to nothing
   map[colCount] = {}

   -- Generate a new far right column (map[1+offset + (numColums, AKA ARENA_WIDTH/map[howLong])
   for rowCount = 1, map.howHigh, 1 do
      if rowCount == 1 or rowCount == 11 or rowCount == 12 then
         local x = (map["boxw"] * colCount)
         local y = (map["boxw"] * rowCount)
         map[colCount][rowCount] = makeCube(map["boxw"], x, y)
      end
   end

   local randomBlockCount = map[colCount-1]["NumOfBlocks"] + math.ceil((math.random()-0.5) * 4)
   if randomBlockCount < 0 then
      randomBlockCount = 0 
   elseif randomBlockCount > 8 then
      randomBlockCount = 8
   end

   -- Generate a new far right column (map[1+offset + (numColums, AKA ARENA_WIDTH/map[howLong])
   for rowCount = map.howHigh-2, map.howHigh-randomBlockCount, -1 do
      local x = (map["boxw"] * colCount)
      local y = (map["boxw"] * rowCount)
      map[colCount][rowCount] = makeCube(map["boxw"], x, y)
   end

   map[colCount]["NumOfBlocks"] =  randomBlockCount
   
   -- Increment the offset counter by one
   map["counter"] = map["counter"]+1
end
