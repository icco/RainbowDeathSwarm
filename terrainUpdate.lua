-- This function should be called whenever we need to delete the far left column, and draw a new right column.
function updateTerrain()
   local difficulty = math.floor(now/12)

   -- Clear out the left hand column (map[1+offset])
   map[map["counter"]] = nil

   local colCount = (1 + map["counter"] + map["howLong"])

   -- Initialize this column to nothing
   map[colCount] = {}

   -- Generate a new far right column (map[1+offset + (numColums, AKA ARENA_WIDTH/map[howLong])
   for rowCount = 1, map.howHigh, 1 do
      if rowCount == 1 then
         local x = (map["boxw"] * colCount)
         local y = (map["boxw"] * rowCount)
         map[colCount][rowCount] = makeCube(map["boxw"], x, y)
      end
   end

   local randomBlockCount = math.floor((math.random(0, map.howHigh/2)))

   -- Generate a new far right column (map[1+offset + (numColums, AKA ARENA_WIDTH/map[howLong])
   for rowCount = map.howHigh, map.howHigh-randomBlockCount, -1 do
      local x = (map["boxw"] * colCount)
      local y = (map["boxw"] * rowCount)
      map[colCount][rowCount] = makeCube(map["boxw"], x, y)
   end

   map[colCount]["NumOfBlocks"] = randomBlockCount
   
   -- Increment the offset counter by one
   map["counter"] = map["counter"]+1
end

