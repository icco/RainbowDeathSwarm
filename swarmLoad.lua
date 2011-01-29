-- load fuction for swarm
--require "math"

local gfx = love.graphics
local phys = love.physics

SQUIRREL_RADIUS =2
SQUIRREL_SPEED = 108

Squirrel = Class(function(self, posx, posy, spee)
	--self.Sposition = vector.new(posx,posy)

	gfx.setBackgroundColor(220, 220, 220) -- 0-255
	self.Sspeed = spee

	self.img = ASSETS.swarm
	self.body = phys.newBody(world, posx, posy, 10, 15)
	self.shape = phys.newCircleShape(self.body, 0, 0, SQUIRREL_RADIUS)
	self.shape:setRestitution(.2)
	self.isTouching = false
	
	self.poof = function(self)
		-- disappear and stuff
		self.body:applyImpulse(0, -50)
	end
end)

--make something that maintains a table of Squirrels that init and delete
function initSwarm()
	math.randomseed(329840)
	Swarm = {}
	--init the first swarm
	for count = 1 , 20 do
	Swarm[count] = Squirrel(2*SQUIRREL_RADIUS + math.random() + 100, ARENA_HEIGHT/2 + math.random(),
			SQUIRREL_SPEED + math.random())
	end
end

function swarmLoadFunction()
	initSwarm()
end

function swarmPoof(i)
	Swarm[i]:poof()
	table.remove(Swarm, i)
end
