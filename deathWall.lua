function initWall()
   local phys = love.physics

   wall = {}
   wall.body = phys.newBody(world, 2, ARENA_HEIGHT / 2, 0, 0)
   wall.shape = phys.newRectangleShape(wall.body, 0, 0, 5, ARENA_HEIGHT, 0)
end

function updateWall()
    vec2 = cam:toCameraCoords(cam.pos)
	for i, nanoBot in ipairs(Swarm) do
		local vec = cam:toCameraCoords(hump.vector.new(nanoBot.body:getX(), nanoBot.body:getY()))
		if (vec.x < (vec2.x - SCREEN_WIDTH/2)) or (nanoBot.body:getY() + SQUIRREL_RADIUS > ( SCREEN_HEIGHT - 10)) then
			swarmPoof(i)
		end
	end
end

function drawWall()
   local gfx = love.graphics
   local x1, y1, x2, y2, x3, y3, x4, y4 = wall.shape:getBoundingBox()
   local w = x3 - x2

   gfx.setColor(255, 255, 255)
   gfx.draw(ASSETS.wall, x2, y2, 0, 1, 1, w-w, w-w-w)
end
