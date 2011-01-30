require "hump.vector"
require "hump.camera"
Gamestate = require "hump.gamestate"
Class = require "hump.class"
Anal = require "Anal/AnAL"
-- highscore lib
highscore = require("sick")

-- Random numbers
require "math"

-- Global Vars (technically, there's no constants)
-- Also, sadly we can't pull in from config...
SCREEN_WIDTH   = 800
SCREEN_HEIGHT  = 600
ARENA_WIDTH    = 40000
ARENA_HEIGHT   = 600
ZOOM_VALUE     = 0.05
ZOOM_MINVALUE     = 0.5

ASSETS = { }

local mapData       = require("mapData")
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
   ASSETS.tile  = gfx.newImage("assets/dirtblock64x64.png")
   -- ASSETS.tile  = gfx.newImage("assets/nat.jpg")
   ASSETS.wall  = gfx.newImage("assets/dirtblock128x128.png")
   ASSETS.squAnimation = gfx.newImage("assets/SquirrelAnimation128x128.png")
   ASSETS.squDance = gfx.newImage("assets/SquirrelDance128x128.png")
   ASSETS.background1 = gfx.newImage("assets/back1_2048x1024.png")
   ASSETS.background2 = gfx.newImage("assets/back2_2048x1024.png")
   ASSETS.background3 = gfx.newImage("assets/back3_2048x1024.png")
   

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
   Gamestate.switch(menuGameState)

   -- Init the Camera
   cam = camera.new(vector.new(SCREEN_WIDTH / 4, (ARENA_HEIGHT / 2) + 80))
   cam.moving = false
   cam.lastCoords = vector.new(-1, -1)
   lastZoomed = love.timer.getTime()

   -- Start the clock!
   seconds_font= love.graphics.newFont(25)
   now = 0
   score = 0

   -- Load the Highscore
   highscore_filename = "highscores.txt"
   local places = 10

   highscore.set(highscore_filename, places, "Anonymous", 0)
end

function love.update(dt)
   swarmUpdateFunction(dt)

   if wereInActualGameNowLoLGlobalsBad then
      -- TODO: Check if the furthest left column is completely off screen.
      -- If it is, then we should actually update the terrain.
      -- leftCameraBoundaryX - (boxW/2)
      if(map[1 + map["counter"]][1].body:getX() +(16*map["boxw"]) < ((now*100) - map["boxw"])) then
         updateTerrain()
      end

      -- Update Wall, kill all touching
      updateWall(dt)

      -- always update camera
      cam.pos = vector.new(now*100,ARENA_HEIGHT / 2 + 30)

      -- Update teh swarm
      swarmUpdateFunction(dt)

      -- SWARM CONTROL!
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
      score = score + ((now/100) * (#Swarm / 10))

      -- Game Over, save score...
      if #Swarm == 0 then
         local username =  os.getenv("USERNAME")
         highscore.add(username, score)

         Gamestate.switch(gameOverState)
      end
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

   -- draw the top right stats (seconds, # of swarm, score)
   if wereInActualGameNowLoLGlobalsBad then      
      now = love.timer.getTime() - load_time
      local secondsString = string.format("%4.2fs", now)
      love.graphics.setFont(seconds_font)
      gfx.setColor(255, 5, 5)
      love.graphics.print(secondsString, SCREEN_WIDTH-150, 20)

      local swarmLoopCount = #Swarm
      local vec, vec2

      vec2 = cam:toCameraCoords(cam.pos)
      vec2.x = vec2.x - 50
      local swarmXMax = -1
	   for count = 1, #Swarm do
         vec = cam:toCameraCoords(vector.new(Swarm[count].body:getX(),Swarm[count].body:getY()))

         if swarmXMax < vec.x then
            swarmXMax = vec.x
         end

         --gfx.circle( 'fill', vec.x, SCREEN_HEIGHT/2+10, 5, 50 )
         -- zoom out when Nats go off the right side of the screen
         if vec.x > (vec2.x + SCREEN_WIDTH/2) and cam.zoom >= 0.5 then
            if now - lastZoomed > 0.2 then
               lastZoomed = now
               cam.zoom = cam.zoom * 1.0 - ZOOM_VALUE 
               if cam.zoom <= ZOOM_MINVALUE then
                  cam.zoom = ZOOM_MINVALUE
               end
            end
         end
      end


      -- this is for zooming in
      if swarmXMax > -1 and swarmXMax < vec2.x + SCREEN_WIDTH/4 and cam.zoom < 1.0 then
         if now - lastZoomed > 0.2 then
            lastZoomed = now
            cam.zoom = cam.zoom * 1.0 + ZOOM_VALUE
            if cam.zoom >= 1.0 then
               cam.zoom = 1.0
            end
         end
      end

      --gfx.setColor(5, 5, 255)
      --gfx.circle( 'fill', (vec2.x + SCREEN_WIDTH/2), SCREEN_HEIGHT/2, 5, 50 )

      local swarmCountString = string.format("%d Nats", #Swarm)
      love.graphics.setFont(seconds_font)
      gfx.setColor(5, 255, 5)
      love.graphics.print(swarmCountString, SCREEN_WIDTH-150, 40)

      local swarmCountString = string.format("%4.2f Score", score)
      gfx.setColor(5, 5, 255)
      love.graphics.print(swarmCountString, SCREEN_WIDTH-150, 60)
   end
end

function love.keypressed(key, unicode)
   for count = 1, #Swarm do
      local csqu = Swarm[count]
      if key == " "   then
         csqu.body:applyImpulse(0, -140)
      end
   end

   -- Quit on escape key
   if key == 'escape' then
      love.event.push('q')
   end

   if key == 'f' then
      Swarm[#Swarm + 1] = Squirrel(now*100+50, 100, SQUIRREL_SPEED + math.random())
   end
end

function love.quit()
   highscore.save()

   for i, score, name in highscore() do
      print(i .. '. ' .. name .. "\t:\t" .. score)
   end

   print("Thanks for playing. Please play again soon!")
end
