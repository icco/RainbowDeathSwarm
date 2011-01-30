-- This function should be called whenever we need to delete the far left column, and draw a new right column.
function updateTerrain()
   print("update terrain called")

   -- Difficulty starts at 1 and counts up
   local difficulty = math.floor(now/12) + 1

   print("difficulty is " .. difficulty)
   -- If the offset counter has reached 2 million
   -- then copy the map back to index 1 and reset the counter.

   -- Clear out the left hand column (map[1+offset])
   --map[map["counter"]] = nil

   -- colCount is the column we'll be starting to draw into.
   local colCount = (1 + map["counter"] + map["howLong"])

   -- We need to pick out a world_piece to use.

   -- Get the starting index in the world_pieces list for this difficulty type.
   local startIndex = world_pieces.startIndeces[difficulty]

   -- Get how many entries of this difficulty type there are in the world_pieces list
   local numToChooseFrom = world_pieces.difficulties[difficulty]

   -- Start off using the first index available for this difficulty.
   --local toUse = world_pieces[math.random(startIndex, startIndex + numToChooseFrom - 1)]

   local toUse = world_pieces[1]
   for i=1, #world_pieces[1].data[1], 1 do
      --print(world_pieces[1].data[1][i])
   end

   --  -- If difficulty is not 1, let's test compare
   --  if(difficulty ~= 1) then
   --     -- Compare the last known column with the upcoming piece
   --     while (compare(toUse.data, map[map["counter"] + map["howLong"]]) == false) do
   --        print("trying to find a new piece to use")
   --        --toUse = world_pieces[math.random(startIndex, startIndex + numToChooseFrom - 1)]
   --        toUse = world_pieces[1]
   --     end
   --  end

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

   local piece = world_pieces[2]
   for i = 1, #piece.data, 1 do
      for j = 1, #piece.data[i], 1 do
         local x = (map["boxw"] * colCount)
         local y = (map["boxw"] * rowCount)
         if piece.data[i][j] == true then
            map[colCount][j] = makeCube(map["boxw"], x, y)
         end
      end

      colCount = 1
   end


   --   local randomBlockCount = map[colCount-1]["NumOfBlocks"] + math.ceil((math.random()-0.5) * 4)
   --   if randomBlockCount < 0 then
   --      randomBlockCount = 0 
   --   elseif randomBlockCount > 8 then
   --      randomBlockCount = 8
   --   end

   -- Generate a new far right column (map[1+offset + (numColums, AKA ARENA_WIDTH/map[howLong])
   --   for rowCount = map.howHigh-2, map.howHigh-randomBlockCount, -1 do
   --      local x = (map["boxw"] * colCount)
   --      local y = (map["boxw"] * rowCount)
   --      map[colCount][rowCount] = makeCube(map["boxw"], x, y)
   --   end

   --   map[colCount]["NumOfBlocks"] =  randomBlockCount

   -- Increment the offset counter by one
   map["counter"] = map["counter"]+1
end

-- Count the number of walls in a given column. Helper function used as a criteria
-- in compare()
function countWalls(column)
   local count = 0;
   print("column")
   for i = 1, map.howHigh, 1 do
      print("column[i] is " .. tostring(column[i]))
      if(column[i] == true) then
         count = count + 1
      end
   end
   print("  has " .. count .. " walls")
   return count
end

-- Function to compare the last column of the first piece with the first column of the second piece
-- A piece is a hand-generated set of columns which will be put into the game
function compare(data1, data2)
   local decision

   for i = 1, #data1, 1 do
      for j = 1, map.howHigh, 1  do
         --   print(i .. ", " .. j .. " is: " .. data1[i][j])
      end
   end
   -- We need to acess this index within data1
   size1 = #data1
   print("size of data1 is " .. size1)

   -- The two columns we care about are data1[size1] and data2[1]
   local wallCount1 = countWalls(data1[size1-1])
   local wallCount2 = countWalls(data2[1])

   -- If there's too big of a difference i the number of walls between the linking parts
   -- of the two pieces, then we should fail.
   if(math.abs(wallCount1-wallCount2) > 4) then
      print("Failing comparison because of large # of walls difference.")
      return true--return false
   end

   -- Make sure that somewhere between the two, there is a 2 square tall gap that connects.
   for i = 1, map.howHigh, 1 do
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
   return true--return false
end

