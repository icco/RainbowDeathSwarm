-- Terrain, 2D Array
map = { howHigh = 12, counter = 0, howLong = 36 }

map["boxw"] = math.floor(ARENA_HEIGHT / map.howHigh)
-- print("box width is " .. map["boxw"])

-- Load function for the terrain
function initTerrain()
   local gfx = love.graphics

   map["boxw"] = 50 -- for consistancy, but should be same as above
   local colCount = 0
   local rowCount = 0

   for colCount = 1, map.howLong, 1 do
      map[colCount] = {}
      -- Draw the far left wall
      if colCount == 1 then
         for rowCount = 1, map.howHigh, 1 do
            local x = (map["boxw"] * colCount)
            local y = (map["boxw"] * rowCount)
            map[colCount][rowCount] = makeCube(map["boxw"], x, y)
            map[colCount]["NumOfBlocks"] = 9
         end
      else
         -- Draw the floor & ceiling
         for rowCount = 1, map.howHigh, 1 do
            if rowCount == 1 or rowCount == 11 or rowCount == 12 then
               local x = (map["boxw"] * colCount)
               local y = (map["boxw"] * rowCount)
               map[colCount][rowCount] = makeCube(map["boxw"], x, y)
            else
               map[colCount][rowCount] = nil
            end
            map[colCount]["NumOfBlocks"] = 0
         end
      end
   end

   map[40] = {}
end

-- Posx and Posy should be top left
function makeCube(size, posx, posy)
   local gfx  = love.graphics
   local phys = love.physics
   local ret  = {}

   -- love.physics.newBody( world, x, y, mass, inertia )
   ret.body = phys.newBody(world, posx, posy, 0 ,0)

   -- love.physics.newRectangleShape( body, x, y, w, h, angle )
   ret.shape = phys.newRectangleShape(ret.body, 0, 0, size, size, 0)

   return ret
end
