-- This function should be called whenever we need to delete the far left column, and draw a new right column.
function updateTerrain()
   -- If the offset counter has reached 2 million
      -- then copy the map back to index 1 and reset the counter.

   -- Clear out the left hand column (map[1+offset])
print(map["counter"])
   --map[1 + map["counter"]] = nil

   -- Generate a new far right column (map[1+offset + (numColums, AKA ARENA_WIDTH/map[howLong])
   for rowCount = 1, map.howHigh, 1 do
            local colCount = (1 + map["counter"] + map["howLong"])
            local x = (map["boxw"] * colCount)
            local y = (map["boxw"] * rowCount)
                                -- + map["boxw"][rowCount]
            --map[colCount][rowCount] = makeCube(map["boxw"], x, y)
   end

   -- Increment the offset counter by one
   map["counter"] = map["counter"]+1
end
