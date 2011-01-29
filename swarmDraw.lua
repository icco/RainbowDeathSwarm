-- animation and such of the swarm. Draw function goes here
local gfx = love.graphics

function swarmDrawFunction()
   gfx.setColor(255,255,255)
   for count = 1, #Swarm do
      local squ = Swarm[count]
      gfx.draw(squ.img, squ.body:getX(), squ.body:getY(), 0, 1, 1, SQUIRREL_RADIUS, SQUIRREL_RADIUS)
   end
end
