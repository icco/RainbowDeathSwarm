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
ARENA_WIDTH = 800
ARENA_HEIGHT = 600

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

   -- Initialize the pseudo random number generator
   math.randomseed(os.time())
   -- The description page for Math says the first few values aren't so random. Burn a few.
   math.random(); math.random(); math.random()

   -- lol background color
   gfx.setBackgroundColor(220, 220, 220) -- 0-255

   -- new physics world
   world = phys.newWorld(0, 0, ARENA_WIDTH, ARENA_HEIGHT)
   world:setGravity(0, 750)
   world:setCallbacks(Cadd, Cpersist, nil, nil)

   -- Init Terrain ... *&$#!$
   initTerrain()

   -- Init death wall
   initWall()

   -- init
   swarmLoadFunction()

   Gamestate.registerEvents()
   Gamestate.switch(menuDraw)

   -- camera
   cam = camera.new(vector.new(SCREEN_WIDTH / 4, ARENA_HEIGHT / 2))
   cam.moving = false
   cam.lastCoords = vector.new(-1, -1)

   -- Start the clock!
   seconds_font = love.graphics.newFont(25)
   load_time = love.timer.getTime()
   now = 0
end

function love.update(dt)
   swarmUpdateFunction(dt)

   if wereInActualGameNowLoLGlobalsBad then
      -- TODO: Check if the furthest left column is completely off screen.
      -- If it is, then we should actually update the terrain.
      -- leftCameraBoundaryX - (boxW/2)
      if(map[1+map["counter"]][1].body:getX() < ((now*100) - (math.floor(ARENA_HEIGHT / map.howHigh)))) then
         --updateTerrain()
      end

      -- Update Wall, kill all touching
      updateWall(dt)

      -- always update camera
      cam.pos = vector.new(now*100, Swarm[1].body:getY() - 100)

      -- Update teh sarm
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
   now = love.timer.getTime() - load_time
   local playing_string = string.format("%4.2fs", now)
   love.graphics.setFont(seconds_font)
   gfx.setColor(255, 5, 5)
   love.graphics.print(playing_string, SCREEN_WIDTH-100, 70)
end

function love.keypressed(key, unicode)
	for count = 1, #Swarm do
      local csqu = Swarm[count]
      if key == " " and csqu.body:getY() > ARENA_HEIGHT - SQUIRREL_RADIUS - 100   then
            csqu.body:applyImpulse(0, -140)
      end
   end

   if key == 'escape' then
      love.event.push('q')
   end

end
