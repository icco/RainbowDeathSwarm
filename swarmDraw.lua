-- animation and such of the swarm. Draw function goes here
function swarmDrawFunction()
   local gfx = love.graphics

   gfx.setColor(0, 255, 0)
   for count = 1, #Swarm do
      local squ = Swarm[count]
      gfx.draw(squ.img, squ.body:getX(), squ.body:getY(), 0, 1, 1, SQUIRREL_RADIUS, SQUIRREL_RADIUS)
   end
end
