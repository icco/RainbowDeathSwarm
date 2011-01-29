-- load fuction for swarm

SQUIRREL_RADIUS =2 

Squirrel = Class(function(self, posx, posy, spee)
	self.Sposition = vector.new(posx,posy)
	self.Sspeed = spee
	--self.img = gfx.NewImage("ball.png")
	self.body = phys.newBody(world, posx, posy, 10, 15)
	self.shape = phys.newCircleShape(self.body, 0, 0, SQUIRREL_RADIUS)
	self.shape:setRestitution(.5)
end)


function swarmLoad()
   --ball.img = gfx.newImage("ball.png")
   --ball.body = phys.newBody(world, 2 * ball.RADIUS, ARENA_HEIGHT/2, 10, 15)
   --ball.shape = phys.newCircleShape(ball.body, 0, 0, ball.RADIUS)
   --ball.shape:setRestitution(.5)
	ball = Squirrel(2* SQUIRREL_RADIUS, ARENA_HEIGHT/2, 9)
end
