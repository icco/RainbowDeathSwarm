require "hump.vector"
require "hump.camera"
Gamestate = require "hump.gamestate"  --gamestates, title screen. intro. gameplay. game over
Class = require "hump.class"  -- horaay OO!
require "hump.vector"

-- Random numbers
require "math"

local menuDraw = require("menuDraw")
local terrainLoad = require("terrainLoad")
local terrainUpdate = require("terrainUpdate")
local terrainDraw = require("terrainDraw")
local swarmLoad = require("swarmLoad")
local swarmUpdate = require("swarmUpdate")
local swarmDraw = require("swarmDraw")

-- convenience renaming (Aliases for ease of typing)
local vector = hump.vector
local camera = hump.camera

-- Global Vars (technically, there's no constants)
-- Also, sadly we can't pull in from config...
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
ARENA_WIDTH = 800
ARENA_HEIGHT = 600

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
   world:setGravity(0, 350)

   -- Init Terrain ... *&$#!$
   initTerrain()

   -- init
   swarmLoadFunction()
   
   Gamestate.registerEvents()
   Gamestate.switch(menuDraw)

   -- Start the clock!
   load_time = love.timer.getTime()
end

function love.update(dt)
   -- TODO: Check if the furthest left column is completely off screen.
   -- If it is, then we should actually update the terrain.
   -- leftCameraBoundaryX - (boxW/2)
   --if(map[1+map["counter"]][1].body.getX() < (leftCameraBoundaryX - (math.floor(ARENA_HEIGHT / map.howHigh))) then
   updateTerrain()
   swarmUpdateFunction(dt)

   world:update(dt)
end

function drawSimpleRect(obj)
   local x1, y1, x2, y2, x3, y3, x4, y4 = obj.shape:getBoundingBox()
   local w = x3 - x2
   local h = y2 - y1
   love.graphics.rectangle("fill", obj.body:getX() - (w / 2), obj.body:getY() - (h / 2), w, h)
end

function love.draw()
   -- convenience
   local gfx = love.graphics

   -- draw the world
   drawTerrain()

   -- draw the swarm
   swarmDrawFunction()

   -- draw the clock
   local now = love.timer.getTime() - load_time
   print("Playing for " .. (now) .. " seconds.")
end

function love.keypressed(key, unicode)
end
