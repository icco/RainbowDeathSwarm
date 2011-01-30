-- animation and such of the swarm. Draw function goes here
function swarmDrawFunction()
   local gfx = love.graphics

   gfx.setColor(0, 255, 0)
   for count = 1, #Swarm do
      local squ = Swarm[count]
      --gfx.draw(runanimation:draw(squ.body:getX(), squ.body:getY()), squ.body:getX(), squ.body:getY(), 0, 1, 1, SQUIRREL_RADIUS, SQUIRREL_RADIUS)
      gfx.setColor(255-squ.redness, 255-squ.greenness, 255-squ.blueness)
      Swarm[count].Runani:draw(squ.body:getX(), squ.body:getY())
   end
end
