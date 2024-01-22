Jelly = {}

local img = love.graphics.newImage("Sprites/JellyFish.png")

function jellyLoader()
    local jellyGrid = anim8.newGrid(16, 16, img:getWidth(), img:getHeight())
    local location = level.layers["jelly"].objects
    for i = 1, #location do
        local inst = location[i]
        Jelly[i] = {
            x = love.graphics.getWidth() / 2,
            y = love.graphics.getHeight() / 2,
            xVel = 0,
            yVel = 0,
            maxVel = 50,
            acc = 800,
            fric = 500,
            w = img:getWidth(),
            h = img:getHeight(),
            anim = anim8.newAnimation(jellyGrid("1-3", 1), 0.1),
            switch = 1,
            isJelly = true,
            index = i,
            jellyFilter = function(item, other)
                if     other.isCoin   then return 'cross'
                elseif other.isWall   then return 'slide'
                elseif other.isExit   then return 'touch'
                elseif other.isPlayer then return 'cross'
                end
                -- else return nil
            end
        }
        world:add(Jelly[i], Jelly[i].x - Jelly[i].w * 0.5, Jelly[i].y - Jelly[i].h, Jelly[i].w, Jelly[i].h)
    end
end

-- function Jelly:update(dt)
--     self.anim:update(dt)
--     self.x = self.x + self.xVel * dt
--     self.y = self.y + self.yVel * dt
--     Jelly:move(dt)
-- end
function jellyUpdater(Player, dt)
    for i, value in pairs(Jelly) do
        function jellyCollide(dt)
            local finalX = Jelly[i].x - Jelly[i].w * 0.5 + Jelly[i].xVel * dt
            local finalY = Jelly[i].y - Jelly[i].h + Jelly[i].yVel * dt
            local actualX, actualY, cols, len = world:move(Jelly[i], finalX, finalY, Jelly[i].jellyFilter)

            -- for i = 1, len do
            --     local other = cols[i]
            -- end

            Jelly[i].x = actualX + Jelly[i].w * 0.5
            Jelly[i].y = actualY + Jelly[i].h
        end

        function move(Player, dt)
            local a = Player.x
            local b = Player.y
            distance = math.sqrt(((a - Jelly[i].x) ^ 2) + ((b - Jelly[i].y) ^ 2))
            if distance < 100 then
                if Jelly[i].x < (a - 20) then
                    --Jelly[i].xVel = 30
                    Jelly[i].switch = -1
                    if Jelly[i].xVel < Jelly[i].maxVel then
                        Jelly[i].xVel = Jelly[i].xVel + Jelly[i].acc * dt
                    end
                end

                if Jelly[i].x > (a + 20) then
                    --Jelly[i].xVel = -30
                    Jelly[i].switch = 1
                    if Jelly[i].xVel > -Jelly[i].maxVel then
                        Jelly[i].xVel = Jelly[i].xVel - Jelly[i].acc * dt
                    end
                end

                if Jelly[i].y < (b - 20) then
                    --Jelly[i].yVel = 30
                    if Jelly[i].yVel < Jelly[i].maxVel then
                        Jelly[i].yVel = Jelly[i].yVel + Jelly[i].acc * dt
                    end
                end

                if Jelly[i].y > (b + 20) then
                    --Jelly[i].yVel = -30
                    if Jelly[i].yVel > -Jelly[i].maxVel then
                        Jelly[i].yVel = Jelly[i].yVel - Jelly[i].acc * dt
                    end
                end
            else
                if Jelly[i].xVel > 0 then
                    Jelly[i].xVel = Jelly[i].xVel - Jelly[i].fric * dt
                    if Jelly[i].xVel < 0 then Jelly[i].xVel = 0 end
                elseif Jelly[i].xVel < 0 then
                    Jelly[i].xVel = Jelly[i].xVel + Jelly[i].fric * dt
                    if Jelly[i].xVel > 0 then Jelly[i].xVel = 0 end
                end

                if Jelly[i].yVel > 0 then
                    Jelly[i].yVel = Jelly[i].yVel - Jelly[i].fric * dt
                    if Jelly[i].yVel < 0 then Jelly[i].yVel = 0 end
                elseif Jelly[i].yVel < 0 then
                    Jelly[i].yVel = Jelly[i].yVel + Jelly[i].fric * dt
                    if Jelly[i].yVel > 0 then Jelly[i].yVel = 0 end
                end
                
            end
        end

        if Jelly[i] ~= nil then
            Jelly[i].anim:update(dt)
            Jelly[i].x = Jelly[i].x + Jelly[i].xVel * dt
            Jelly[i].y = Jelly[i].y + Jelly[i].yVel * dt
            move(Player, dt)
            jellyCollide(dt)
        end
    end
end

-- function Jelly:draw()
--     self.anim:draw(self.img, self.x, self.y, nil, self.switch * 2, 1 * 2, self.w - (self.w * 0.75), self.h)
-- end

function jellyDrawer()
    for i, value in pairs(Jelly) do
        Jelly[i].anim:draw(img, Jelly[i].x, Jelly[i].y, nil, Jelly[i].switch, 1, Jelly[i].w - (Jelly[i].w * 0.75), Jelly[i].h)
    end
end