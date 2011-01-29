-- This function should be called whenever we need to delete the far left column, and draw a new right column.
function updateTerrain()
   -- If the offset counter has reached 2 million
      -- then copy the map back to index 1 and reset the counter.

   -- Clear out the left hand column (map[1+offset])
   map[1+map["counter"]] = nil
   -- Generate a new far right column (map[1+offset + (numColums, AKA ARENA_WIDTH/map[howLong])
   

   -- Increment the offset counter by one
   map["counter"] = map["counter"]+1
end
