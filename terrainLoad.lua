
-- Terrain, 2D Array
map = {counter = 0 }

-- Load function for the terrain
function initTerrain()
   local boxw = SCREEN_HEIGHT / 25
   local colCount = 0
   local rowCount = 0

   for colCount = 1, 25, 1 do
      map[colCount] = {}

      for rowCount = 1, 13, 1 do
         print(' ', colCount, rowCount)
         map[colCount][rowCount] = makeCube(boxw, (boxw * (colCount-1)), (boxw * (rowCount-1)))
      end
   end
end

-- Posx and Posy should be top left
function makeCube(size, posx, posy)
   local gfx = love.graphics
   local phys = love.physics
   local ret = {}

   print(size, posx, posy)
   -- love.physics.newBody( world, x, y, mass, inertia )
   ret.body = phys.newBody(world, posx+(size/2), posy+(size/2), 0 ,0)

   -- love.physics.newRectangleShape( body, x, y, w, h, angle )
   ret.shape = phys.newRectangleShape(ret.body, posx, posy, size, size, 0)
   -- ret.shape = phys.newRectangleShape()

   return ret
end
