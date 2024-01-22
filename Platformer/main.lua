local bump = require "bump/bump"
anim8 = require "anim8/anim8"
local camera = require "gamera/gamera"
local Game = require "states/Game"
local Menu = require "states/menu"
love.graphics.setDefaultFilter("nearest", "nearest")
require("player")
require("coin")
require("jellyfish")
local STI = require("sti")
level = require("Map/testMap")

function levelLoader(level)
    Map = STI(level)
    local objects = level.layers["solids"].objects
    for i = 1, #objects do
        local obj = objects[i]
        obj.isWall = true
        world:add(obj, obj.x, obj.y, obj.width, obj.height)
    end
end

function love.load()
    world = bump.newWorld()
    Player:load()
    levelLoader(level)
    coinSpawner()
    jellyLoader()
    game = Game()
    menu = Menu()
    menu.loadMenu()
    game:changeGameState("menu")
    cam = camera.new(0, 0, Map.width * Map.tilewidth, Map.height * Map.tileheight)
    cam:setScale(2.0)
end

function love.update(dt)
    if game.state.running then
        Player:update(dt)    
        cam:setPosition(Player.x, Player.y)
        coinUpdater(dt)
        jellyUpdater(Player, dt)
    end 
end

function love.draw()
    if game.state.running then
        cam:draw(function()
            Map:drawLayer(Map.layers["tiles"])
            --currAnim:draw(Player.img, Player.x, Player.y, nil, Player.factor * Player.zoom, Player.zoom, 4, 8)
            Player:draw()
            drawCoins()
            jellyDrawer()
        end)
    elseif game.state.menu then
        menu.drawMenu()
    end
end 

function love.mousepressed(x, y, button)
    if game.state.menu then
        if button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
            for i, value in ipairs(buttons) do
                if ((y > buttons[i].y) and (y < buttons[i].y + font:getHeight(buttons[i].text))) and ((x > buttons[i].x - font:getWidth(buttons[i].text) / 2) and (x < buttons[i].x + font:getWidth(buttons[i].text) / 2)) then
                    game:changeGameState("running")
                end
           end
        end
    end
end
