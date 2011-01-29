function initWall()

end

function updateWall()

end

function drawWall()
   --[[
   local gfx = love.graphics
   local x1, y1, x2, y2, x3, y3, x4, y4 = wall.shape:getBoundingBox()
   local w = x3 - x2

   gfx.setColor(255, 255, 255)
   gfx.draw(cubeTexture, x2, y2, 0, 1, 1, w-w, w-w-w)
   ]]
end
