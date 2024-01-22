coin = {}

local goldCoin = love.graphics.newImage("Sprites/goldcoin.png")

function coinSpawner()
    local coinGrid = anim8.newGrid(8, 8, goldCoin:getWidth(), goldCoin:getHeight())
    local location = level.layers["coinspawn"].objects
    for i = 1, #location do
        local inst = location[i]
        coin[i] = {
            x = inst.x + 8,
            y = inst.y + 8,
            w = 8,
            h = 8,
            anim = anim8.newAnimation(coinGrid("1-6", 1), 0.1),
            index = i,
            isCoin = true
        }
        world:add(coin[i], coin[i].x - coin[i].w * 0.5, coin[i].y - coin[i].h, coin[i].w, coin[i].h)
    end
end

function coinUpdater(dt)
    for i, value in pairs(coin) do
        if coin[i] ~= nil then
            coin[i].anim:update(dt)
        end
    end
end

function drawCoins()
    for i, value in pairs(coin) do
        if coin[i] ~= nil then
            coin[i].anim:draw(goldCoin, coin[i].x, coin[i].y, nil, 1, 1, 4, 8)
        end
    end
end