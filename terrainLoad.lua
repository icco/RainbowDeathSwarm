
-- Terrain, 2D Array
map = {
   counter = 0,
   howHigh = 12,
   howLong = 16
}

-- Load function for the terrain
function initTerrain()
   local boxw = ARENA_HEIGHT / map.howHigh
   local colCount = 0
   local rowCount = 0

   for colCount = 1, map.howLong, 1 do
      map[colCount] = {}

      for rowCount = 1, map.howHigh, 1 do
         local x = (boxw * colCount) - boxw/2
         local y = (boxw * rowCount) - boxw/2
         map[colCount][rowCount] = makeCube(boxw, x, y)
      end
   end
end

-- Posx and Posy should be top left
function makeCube(size, posx, posy)
   local gfx = love.graphics
   local phys = love.physics
   local ret = {}

   -- love.physics.newBody( world, x, y, mass, inertia )
   ret.body = phys.newBody(world, posx, posy, 0 ,0)

   -- love.physics.newRectangleShape( body, x, y, w, h, angle )
   ret.shape = phys.newRectangleShape(ret.body, 0, 0, size, size, 0)

   return ret
end
