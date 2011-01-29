require "hump.vector"
require "hump.camera"
Gamestate = require "hump.gamestate" --gamestates, title screen. intro. gameplay. game over
Class = require "hump.class" -- horaay OO!
require "hump.vector"

-- Random numbers
require "math"

-- Global Vars (technically, there's no constants)
-- Also, sadly we can't pull in from config...
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
ARENA_WIDTH = 40000
ARENA_HEIGHT = 600

ASSETS = { }

local menuDraw      = require("menuDraw")
local terrainLoad   = require("terrainLoad")
local terrainUpdate = require("terrainUpdate")
local terrainDraw   = require("terrainDraw")
local swarmLoad     = require("swarmLoad")
local swarmUpdate   = require("swarmUpdate")
local swarmDraw     = require("swarmDraw")
local deathWall     = require("deathWall")

-- convenience renaming (Aliases for ease of typing)
local vector = hump.vector
local camera = hump.camera

function love.load()
   -- convenience
   local gfx = love.graphics
   local phys = love.physics

   -- Init all of our textures and fonts
   ASSETS.swarm = gfx.newImage("assets/nat.jpg")
   ASSETS.tile  = gfx.newImage("assets/ground.png")
   -- ASSETS.tile  = gfx.newImage("assets/nat.jpg")
   ASSETS.wall  = gfx.newImage("assets/nat.jpg")

   -- Initialize the pseudo random number generator
   math.randomseed(os.time())
   -- The description page for Math says the first few values aren't so random. Burn a few.
   math.random(); math.random(); math.random()

   -- new physics world
   world = phys.newWorld(0, 0, ARENA_WIDTH, ARENA_HEIGHT)
   world:setGravity(0, 750)
   world:setCallbacks(Cadd, Cpersist, Cremove, nil)

   -- Init Terrain ... *&$#!$
   initTerrain()

   -- Init death wall
   initWall()

   -- Init the swarm
   swarmLoadFunction()

   Gamestate.registerEvents()
   Gamestate.switch(menuDraw)

   -- Init the Camera
   cam = camera.new(vector.new(SCREEN_WIDTH / 4, (ARENA_HEIGHT / 2) + 80))
   cam.moving = false
   cam.lastCoords = vector.new(-1, -1)

   -- Start the clock!
   seconds_font = love.graphics.newFont(25)
   now = 0
end

function love.update(dt)
   swarmUpdateFunction(dt)

   if wereInActualGameNowLoLGlobalsBad then
      -- TODO: Check if the furthest left column is completely off screen.
      -- If it is, then we should actually update the terrain.
      -- leftCameraBoundaryX - (boxW/2)
      if(map[1 + map["counter"]][1].body:getX() +(8*map["boxw"]) < ((now*100) - map["boxw"])) then
         updateTerrain()
      end

      -- Update Wall, kill all touching
      updateWall(dt)

      -- always update camera
      cam.pos = vector.new(now*100,ARENA_HEIGHT / 2 + 80)

      -- Update teh swarm
      swarmUpdateFunction(dt)

      for count = 1, #Swarm do
         local csqu = Swarm[count]
         x, y = csqu.body:getLinearVelocity( )

         if (love.keyboard.isDown("d")) and x <= 200 then
            csqu.body:applyImpulse(100, 0)
         end

         if (love.keyboard.isDown("a"))  and x > -200 then
            csqu.body:applyImpulse(-100, 0)
         end
      end

      world:update(dt)
   end
end

function love.draw()
   -- convenience
   local gfx = love.graphics

   -- lol background color
   gfx.setBackgroundColor(90, 90, 90) -- 0-255

   -- draw the world
   cam:predraw()

   -- draw the world
   drawTerrain()

   -- draw the wall
   drawWall()

   -- draw the swarm
   swarmDrawFunction()

   -- done drawing the world
   cam:postdraw()

   -- draw the clock
   if wereInActualGameNowLoLGlobalsBad then      
      now = love.timer.getTime() - load_time
      local secondsString = string.format("%4.2fs", now)
      love.graphics.setFont(seconds_font)
      gfx.setColor(255, 5, 5)
      love.graphics.print(secondsString, SCREEN_WIDTH-100, 70)

      local swarmLoopCount = 0
	   for count = 1, #Swarm do
         if Swarm[count] ~= nil then
               swarmLoopCount = swarmLoopCount + 1
         end
      end

      local swarmCountString = string.format("%d Nats", swarmLoopCount)
      love.graphics.setFont(seconds_font)
      gfx.setColor(255, 5, 5)
      love.graphics.print(swarmCountString, SCREEN_WIDTH-100, 90)
   end
end

function love.keypressed(key, unicode)
	for count = 1, #Swarm do
      local csqu = Swarm[count]
      if key == " "   then
            csqu.body:applyImpulse(0, -140)
      end
   end

   if key == 'escape' then
      love.event.push('q')
   end

   if key == 'f' then
	Swarm[#Swarm + 1] = Squirrel(now*100+50, 100,
	   SQUIRREL_SPEED + math.random())
   end

end
