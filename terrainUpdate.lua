-- This function should be called whenever we need to delete the far left column, and draw a new right column.
function updateTerrain()
   local difficulty = math.floor(now/12)

--print("difficulty is " .. difficulty)
   -- If the offset counter has reached 2 million
   -- then copy the map back to index 1 and reset the counter.

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

function countWalls(column)
local count = 0;
print("column")
   for i = 1, #column do
      print("  " .. column[i])
      if(column[i]) then
         count = count + 1
      end
   end
print("  has " .. count .. " walls")
return count
end

-- Function to compare the last column of the first piece with the first column of the second piece
-- A piece is a hand-generated set of columns which will be put into the game
function compare(p1, p2)
   local decision
   data1 = p1.data
   data2 = p2.data

   -- We need to acess this index within data1
   size1 = #data1

   -- The two columns we care about are data1[size1] and data2[1]
   wallCount1 = countWalls(data1[size1])
   wallCount2 = countWalls(data2[1])

   -- If there's too big of a difference i the number of walls between the linking parts
   -- of the two pieces, then we should fail.
   if(math.abs(wallCount1-wallCount2) > 3) then
      print("Failing comparison because of large # of walls difference.")
      return false
   end

   -- Make sure that somewhere between the two, there is a 2 square tall gap that connects.
   for i = 1, map.howHigh do
      -- If a given square in one piece is an empty spot, then check for an empty spot
      -- right after it as well. If we find both of these to be empty, then check
      -- the other piece for these matching empty squares. If we find both of these additional 
      -- matches, then decision is true, meaning these two pieces match up.
      if(data1[size1][i] == false) then
         -- Check if the one next to it is empty too.
         if(data1[size1][i+1] == false) then
            -- Check if both of these are empty in the other piece as well.
            if(data2[1][i] == false and data2[1][i+1] == false) then
               -- These two pieces are compatible
               print("Found two compatible pieces.")
               return true;
            end

         end
      end
   end

   -- If we made it through all this without returning true, then these pieces
   -- are incompatible
   print("Failing comparison because of no compatible gaps.")
   return false
end

