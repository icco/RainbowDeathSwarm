require "hump.vector"
require "hump.camera"
require "hump.gamestate"  --gamestates, title screen. intro. gameplay. game over
Class = require "hump.class"  -- horaay OO!
require "hump.vector"

-- Random numbers
require "math"

local terrainLoad = require("terrainLoad")
local terrainUpdate = require("terrainUpdate")
local terrainDraw = require("terrainDraw")
local swarmLoad = require("swarmLoad")
local swarmUpdate = require("swarmUpdate")
local swarmDraw = require("swarmDraw")

-- convenience renaming (Alases for ease of typing)
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

   -- lol background color
   gfx.setBackgroundColor(220, 220, 220) -- 0-255

   -- new physics world
   world = phys.newWorld(0, 0, ARENA_WIDTH, ARENA_HEIGHT)
   world:setGravity(0, 350)

   -- Init Terrain ... *&$#!$
   initTerrain()

   --init
   swarmLoadFunction()
end

function love.update(dt)
   world:update(dt)

   updateTerrain()
   swarmUpdateFunction(dt)
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

   --draw your mom
   drawTerrain()

   swarmDrawFunction()
end

function love.keypressed(key, unicode)
end
