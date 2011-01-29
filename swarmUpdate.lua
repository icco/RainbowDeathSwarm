-- update function for the individiual members of the swarm goes here
local phys = love.physics

function swarmUpdateFunction(dt)
	ball.body:applyForce(ball.Sspeed*dt, 0)
	for count = 1, #Swarm do
		Swarm[count].body:applyForce(Swarm[count].Sspeed*dt, 0)
	end
end
