-- draw function for the terrain goes here

function drawTerrain()
   local gfx = love.graphics
   local colCount = 0
   local rowCount = 0

   gfx.setColor(0, 255, 0)

   for colCount = 1, map.howLong, 1 do
      for rowCount = 1, map.howHigh, 1 do
         drawSimpleRect(map[colCount][rowCount])
      end
   end
end
