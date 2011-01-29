
-- Terrain, 2D Array
map = {counter = 0 }

-- Load function for the terrain
function initTerrain()
   local boxw = SCREEN_WIDTH / 24

   for colCount = 1, colCount == 24, colCount + 1 do
      map[colCount] = {}

      for rowCount = 1, rowCount == 24, rowCount + 1 do
         map[colCount][rowCount] = makeCube(boxw, (boxw * colCount), (boxw * rowCount))
      end
   end
end

-- Posx and Posy should be top left
function makeCube(size, posx, posy)
   local ret = {}

   -- love.physics.newBody( world, x, y, mass, inertia )
   ret.body = phys.newBody(world, posx+(size/2), posy+(size/2), 0 ,0)

   -- love.physics.newRectangleShape( body, x, y, w, h, angle )
   ret.shape = phys.newRectangleShape(ret.body, posx, posy, size, size, 0)
   -- ret.shape = phys.newRectangleShape()
   return ret
end
