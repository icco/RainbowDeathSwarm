-- update function for the individiual members of the swarm goes here
local phys = love.physics

function swarmUpdateFunction(dt)
	runanimation:update(dt)
	for count = 1, #Swarm do
		Swarm[count].body:applyForce(Swarm[count].Sspeed*dt, 0)
		Swarm[count].Runani:update(dt)
		Swarm[count].Poofani:update(dt)
	end
end
