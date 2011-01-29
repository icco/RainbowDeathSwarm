-- update function for the individiual members of the swarm goes here
--local phys = love.physics

function swarmUpdateFunction(dt)
	ball.body:applyForce(ball.Sspeed*dt, 0)
end
