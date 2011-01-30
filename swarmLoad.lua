local gfx = love.graphics
local phys = love.physics

SQUIRREL_RADIUS = 23
SQUIRREL_SPEED = 108

Squirrel = Class(function(self, posx, posy, spee)
   self.Sspeed = spee

   self.img = ASSETS.swarm
   self.body = phys.newBody(world, posx, posy, 10, 15)
   self.shape = phys.newCircleShape(self.body, 0, 0, SQUIRREL_RADIUS)
   self.shape:setRestitution(.2)
   self.isTouching = false
   self.redness = math.random(0,20);
   self.greenness = math.random(0,50);
   self.blueness = math.random(0,150);

   -- disappear and stuff
   self.poof = function(self)
      self.body:applyImpulse(0, -50)
   end
end)

--make something that maintains a table of Squirrels that init and delete
function initSwarm()
   local count = 0
   math.randomseed(329840)
   Swarm = {}
   --SwarmAnimations = {}
   local aniimg = gfx.newImage("assets/SquirrelAnimation128x128.png")
   runanimation = newAnimation(aniimg, 128, 128, .1, 8)

   --init the first swarm
   for count = 1 , 20 do
      local radius = 2*SQUIRREL_RADIUS + 100
      local spawnx = ARENA_HEIGHT/2 + math.random()
      local spawny = 20 + math.random()
      local speed = SQUIRREL_SPEED

      Swarm[count] = Squirrel(radius, spawnx, spawny, speed)
   end
end

function swarmLoadFunction()
   initSwarm()
end

function swarmPoof(i)
   Swarm[i]:poof()
   table.remove(Swarm, i)
end
