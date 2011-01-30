-- Main file that LOVE runs
--
-- @author Nat Welch
-- @author Taylor Arnicar
-- @author Katherine Blizard
-- @author James Pearon
-- @author Ryuho Kudo

-- Require HUMP
require "hump.vector"
require "hump.camera"
Gamestate = require "hump.gamestate"
Class = require "hump.class"

-- Anal is an animation library you sicko
Anal = require "Anal/AnAL"

-- highscore lib
highscore = require("sick")

-- For Random numbers
require "math"

-- Global Vars (technically, there's no constants)
-- Also, sadly we can't pull in from config...
SCREEN_WIDTH   = 800
SCREEN_HEIGHT  = 600
ARENA_WIDTH    = 40000
ARENA_HEIGHT   = 600
ZOOM_VALUE     = 0.05
ZOOM_MINVALUE     = 0.5
SEXY_MULTIPLICATION_TIME = 200
MAX_SQUIRRELS  = 150

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
local background    = require("Background")
local physicscallbacks    = require("physFuncs")

-- convenience renaming (Aliases for ease of typing)
local vector = hump.vector
local camera = hump.camera

function love.load()
   -- convenience
   local gfx = love.graphics
   local phys = love.physics

   -- Init all of our textures and fonts
   ASSETS.swarm        = gfx.newImage("assets/nat.jpg")
   ASSETS.tile         = gfx.newImage("assets/block50x50.png")--"assets/dirtblock50x50.png")
   ASSETS.wall         = gfx.newImage("assets/dirtblock128x128.png")
   ASSETS.rainbow      = gfx.newImage("assets/deathbow.png")
   ASSETS.squAnimation = gfx.newImage("assets/SquirrelAnimation128x128.png")
   ASSETS.squDance     = gfx.newImage("assets/SquirrelDance128x128.png")
   ASSETS.background1  = gfx.newImage("assets/star2.png")--"assets/back1_2048x1024.png")
   ASSETS.background2  = gfx.newImage("assets/star1.png")--"assets/back2_2048x1024.png")
   ASSETS.background3  = gfx.newImage("assets/starrybg.png") --"assets/back3_2048x1024.png")
   ASSETS.smallFont    = love.graphics.newFont(25)
   ASSETS.largeFont    = love.graphics.newFont(50)
   ASSETS.bgMusic      = love.audio.newSource("assets/music/teru_-_Goodbye_War_Hello_Peace.mp3")
   ASSETS.jumpSound    = love.audio.newSource("assets/yipee2.wav", "static")

   -- Initialize the pseudo random number generator
   math.randomseed(os.time())
   -- The description page for Math says the first few values aren't so random. Burn a few.
   math.random(); math.random(); math.random()

   Gamestate.registerEvents()
   Gamestate.switch(menuGameState)

   -- Start the music, and just keep it looping
   love.audio.play(ASSETS.bgMusic)

   -- Init the Camera
   cam = camera.new(vector.new(SCREEN_WIDTH / 4, (ARENA_HEIGHT / 2) + 80))
   cam.moving = false
   cam.lastCoords = vector.new(-1, -1)
   lastZoomed = love.timer.getTime()

   -- Load the Highscore (Only call once!)
   highscore_filename = "highscores.txt"
   local places = 10

   highscore.set(highscore_filename, places, "Anony", 0)

   resetGame()
end

function resetGame()
   -- convenience
   local gfx = love.graphics
   local phys = love.physics

   -- new physics world
   world = phys.newWorld(0, 0, ARENA_WIDTH, ARENA_HEIGHT)
   world:setGravity(0, 750)
   --world:setCallbacks(Cadd, Cpersist, Cremove,Cresult )

   -- Init Terrain ... *&$#!$
   initTerrain()

   -- Init death wall
   initWall()

   -- Init the swarm
   swarmLoadFunction()

   -- Start the clock!
   now = 0
   score = 0
   
   -- Reset clock-time 'til reproduction
   timeTilSexyMultiplication = SEXY_MULTIPLICATION_TIME

   --asdasdasd asdasdasd
   backgroundLoad()
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
      backgroundUpdate(dt)
      rainAni:update(dt)

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
         
         if (not love.keyboard.isDown("d")) and
            (not love.keyboard.isDown("a")) and
            (not love.keyboard.isDown(" ")) then
            timeTilSexyMultiplication = timeTilSexyMultiplication - dt
            if timeTilSexyMultiplication < 0 then
               for i=1, #Swarm/2 do
                  if #Swarm < MAX_SQUIRRELS then
                     Swarm[#Swarm + 1] = Squirrel(now*100+50, 100, SQUIRREL_SPEED + math.random())
                  end
               end
               timeTilSexyMultiplication = SEXY_MULTIPLICATION_TIME
            end
         end
      end

      -- STATS.
      score = score + ((now/100) * (#Swarm / 10))
      now = love.timer.getTime() - load_time

      world:update(dt)

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

   --background behind camera
   backgroundDraw()

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

   drawDeathWall()

   if wereInActualGameNowLoLGlobalsBad then

      -- draw the stats (seconds, # of swarm, score)
      gfx.setColor(250, 250, 250, 150)
      love.graphics.rectangle('fill', 100, SCREEN_HEIGHT-40, SCREEN_WIDTH-240, 30)

      local secondsString = string.format("%4.2fs", now)
      love.graphics.setFont(ASSETS.smallFont)
      gfx.setColor(255, 5, 5)
      love.graphics.print(secondsString, 160, SCREEN_HEIGHT-40)

      local swarmCountString = string.format("%d Nats", #Swarm)
      love.graphics.setFont(ASSETS.smallFont)
      gfx.setColor(5, 255, 5)
      love.graphics.print(swarmCountString, 290, SCREEN_HEIGHT-40)

      local scoreCountString = string.format("%.2f Points", score)
      gfx.setColor(5, 5, 255)
      love.graphics.print(scoreCountString, 440, SCREEN_HEIGHT-40)

      -- Camera Draw Logic
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
         if vec.x > (vec2.x + SCREEN_WIDTH/2 - SCREEN_WIDTH/4) and cam.zoom >= 0.5 then
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
      --gfx.circle('fill', (vec2.x + SCREEN_WIDTH/2), SCREEN_HEIGHT/2, 5, 50)
   end
end

function love.keypressed(key, unicode)
   for count = 1, #Swarm do
      local csqu = Swarm[count]
      if key == " " --[[and csqu.isTouching]]  then
         csqu.body:applyImpulse(0, -140)
      end
   end

   if key == " " --[[and csqu.isTouching]]  then
      local source = ASSETS.jumpSound

      if source:isStopped() then
         love.audio.play(source)
      else
         love.audio.stop(source)
         love.audio.play(source)
      end
   end

   -- Quit on escape key
   if key == 'escape' then
      love.event.push('q')
   end

   if key == 'f' then
      Swarm[#Swarm + 1] = Squirrel(now*100+50, 100, SQUIRREL_SPEED + math.random())
   elseif key == 'm' then
      if love.audio.getVolume() == 0 then
         love.audio.setVolume(1)
      else
         love.audio.setVolume(0)
      end
   end
end

function love.quit()
   highscore.save()

   for i, score, name in highscore() do
      -- print(i .. '. ' .. name .. "\t:\t" .. score)
   end

   print("Thanks for playing. Please play again soon!")
end
