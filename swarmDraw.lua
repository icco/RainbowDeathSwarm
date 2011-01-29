-- animation and such of the swarm. Draw function goes here
local gfx = love.graphics

function swarmDrawFunction()
   gfx.setColor(255,255,255)
   gfx.draw(ball.img, 
      ball.body:getX(), 
      ball.body:getY(), 
      ball.body:getAngle(), 1, 1, SQUIRREL_RADIUS, SQUIRREL_RADIUS)
end
