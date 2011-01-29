require "hump.vector"
require "hump.camera"
require "hump.gamestate"  --gamestates, title screen. intro. gameplay. game over
Class = require "hump.class"  -- horaay OO!
require "hump.vector"

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
ARENA_WIDTH = 2400
ARENA_HEIGHT = 400

walls = {
   left = {},
   right = {},
   top = {},
   bottom = {}
}

ball = { RADIUS = 50 }

function love.load()
   -- convenience
   local gfx = love.graphics
   local phys = love.physics

   -- lol background color
   gfx.setBackgroundColor(220, 220, 220) -- 0-255

   --camera
   cam = camera.new(vector.new(SCREEN_WIDTH / 4, ARENA_WIDTH/2))

   -- new physics world
   world = phys.newWorld(0,0, ARENA_WIDTH, ARENA_HEIGHT)
   world:setGravity(0, 350)

   --define teh walls. In Physics, define point and shape
   walls.left.body = phys.newBody(world, 2, ARENA_HEIGHT/2, 0 ,0)
   walls.left.shape = phys.newRectangleShape(walls.left.body, 0,0, 5, ARENA_HEIGHT )

   walls.right.body = phys.newBody(world, ARENA_WIDTH-2, ARENA_HEIGHT/2, 0 ,0)
   walls.right.shape = phys.newRectangleShape(walls.right.body, 0,0, 5, ARENA_HEIGHT )

   walls.top.body = phys.newBody(world, ARENA_WIDTH/2, 2, 0 ,0)
   walls.top.shape = phys.newRectangleShape(walls.top.body, 0,0, ARENA_WIDTH, 5 )

   walls.bottom.body = phys.newBody(world, ARENA_WIDTH/2, ARENA_HEIGHT - 2, 0 ,0)
   walls.bottom.shape = phys.newRectangleShape(walls.bottom.body, 0,0, ARENA_WIDTH, 5 )

   --BALLS
   ball.img = gfx.newImage("ball.png")
   ball.body = phys.newBody(world, 2 * ball.RADIUS, ARENA_HEIGHT/2, 10, 15)
   ball.shape = phys.newCircleShape(ball.body, 0, 0, ball.RADIUS)
   ball.shape:setRestitution(.5)
end

function love.update(dt)
   -- applying a force of 1000 units er seconds
   ball.body:applyForce(300*dt, 0)
   world:update(dt)
   cam.pos = vector.new(ball.body:getX(), ball.body:getY() - 100)
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

   --pre-draw camera thingies
   cam:predraw();

   --draw Arena
   gfx.setColor(255,255,200)
   gfx.rectangle("fill", 0 ,0, ARENA_WIDTH, ARENA_HEIGHT)

   --ur winnar zone
   gfx.setColor(0,255,0,100)
   gfx.rectangle("fill", ARENA_WIDTH - 150, 0, 150, ARENA_HEIGHT)

   --draw wallz
   gfx.setColor(0,0,0)
   drawSimpleRect(walls.left)
   drawSimpleRect(walls.right)
   drawSimpleRect(walls.top)
   drawSimpleRect(walls.bottom)

   --ball
   gfx.setColor(255,255,255)
   gfx.draw(ball.img, ball.body:getX(), ball.body:getY(), ball.body:getAngle(), 1, 1, ball.RADIUS, ball.RADIUS)

   --camera postdraw
   cam:postdraw();

   --Anything stuck to screen is drawn after postdraw
end

function love.keypressed(key, unicode)
   if key == " " and ball.body:getY() > ARENA_HEIGHT - ball.RADIUS - 20   then
      ball.body:applyImpulse(0, -140)
   end
end
