-- load fuction for swarm
require "math"

local gfx = love.graphics
local phys = love.physics

SQUIRREL_RADIUS =2 



Squirrel = Class(function(self, posx, posy, spee)
	--self.Sposition = vector.new(posx,posy)
	
	gfx.setBackgroundColor(220, 220, 220) -- 0-255
	self.Sspeed = spee

	self.img = gfx.newImage("nat.jpg")
	self.body = phys.newBody(world, posx, posy, 10, 15)
	self.shape = phys.newCircleShape(self.body, 0, 0, SQUIRREL_RADIUS)
	self.shape:setRestitution(.5)
end)

--make something that maintains a table of Squirrels that init and delete
	math.randomseed(329840)	


function swarmLoadFunction()
   --ball.img = gfx.newImage("ball.png")
   --ball.body = phys.newBody(world, 2 * ball.RADIUS, ARENA_HEIGHT/2, 10, 15)
   --ball.shape = phys.newCircleShape(ball.body, 0, 0, ball.RADIUS)
   --ball.shape:setRestitution(.5)
	ball = Squirrel(2* SQUIRREL_RADIUS, ARENA_HEIGHT/2, 9)
end
