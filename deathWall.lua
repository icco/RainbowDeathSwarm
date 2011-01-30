function initWall()
   local phys = love.physics

   deathWall = {}
   deathWall.body = phys.newBody(world, 2, ARENA_HEIGHT / 2, 0, 0)
   deathWall.shape = phys.newRectangleShape(deathWall.body, 0, 0, 5, ARENA_HEIGHT, 0)
   deathWall.img = ASSETS.rainbow
   rainAni = newAnimation(deathWall.img, 155, 600, .2, 0)
   rainAni:setMode("bounce")
end

function updateWall()
   vec2 = cam:toCameraCoords(cam.pos)
   for i, nanoBot in ipairs(Swarm) do
      local vec = cam:toCameraCoords(hump.vector.new(nanoBot.body:getX(), nanoBot.body:getY()))
      if (vec.x < (vec2.x - SCREEN_WIDTH/2 + 130)) or (nanoBot.body:getY() + SQUIRREL_RADIUS > ( SCREEN_HEIGHT - 10)) then
         swarmPoof(i)
      end
   end

   for i, nanoBot in ipairs(Swarm) do
      local vec = cam:toCameraCoords(hump.vector.new(nanoBot.body:getX(), nanoBot.body:getY()))
      if (vec.x > (vec2.x + SCREEN_WIDTH/2 - 30)) then
         swarmPoof(i)
      end
   end
end

function drawDeathWall()
   local gfx = love.graphics
   local x1, y1, x2, y2, x3, y3, x4, y4 = deathWall.shape:getBoundingBox()
   local w = x3 - x2

   gfx.setColor(255, 255, 255)
   --gfx.draw(deathWall.img, x2, y2, )
   rainAni:draw(0, 0, 0, 1, 1, 0,0)
end
