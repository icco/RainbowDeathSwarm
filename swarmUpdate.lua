-- update function for the individiual members of the swarm goes here
local phys = love.physics
--[[
function love.keypressed(key, unicode)
	for count = 1, #Swarm do
		local csqu = Swarm[count]
		if key == " " and csqu.body:getY() > ARENA_HEIGHT - SQUIRREL_RADIUS - 20   then
			csqu.body:applyImpulse(0, -140)
		end
	end
end
]]
function swarmUpdateFunction(dt)
	runanimation:update(dt)
	for count = 1, #Swarm do
		Swarm[count].body:applyForce(Swarm[count].Sspeed*dt, 0)
	end
end
