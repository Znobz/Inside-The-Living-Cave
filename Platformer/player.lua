Player = {}

function Player:load()
    self.x = 250
    self.y = 200
    self.w = 8
    self.h = 8
    self.img = love.graphics.newImage("Sprites/8bitSheet.png")
    self.xVel = 0
    self.yVel = 0
    self.grav = -500
    self.acc = 1000
    self.maxSpeed = 500
    self.factor = 1
    self.isGrounded = false
    self.isPlayer = true
    self.playerFilter = function(item, other)
        if     other.isCoin   then return 'cross'
        elseif other.isWall   then return 'slide'
        elseif other.isExit   then return 'touch'
        elseif other.isSpring then return 'bounce'
        end
        -- else return nil
    end

    world:add(self, self.x - self.w * 0.5, self.y - self.h, self.w, self.h)
    
    Player:animation()
end

function Player:animation()
    --anim8 = anim8
    local g = anim8.newGrid(8, 8, self.img:getWidth(), self.img:getHeight())
    idle = anim8.newAnimation(g("1-13", 1), 0.1)
    run = anim8.newAnimation(g("14-15", 1), 0.1)
    air = anim8.newAnimation(g(24, 1), 0.1)
    fall = anim8.newAnimation(g(25, 1), 0.1)
    currAnim = idle
end

function Player:collide(dt)
    local finalX = self.x - self.w * 0.5 + self.xVel * dt
    local finalY = self.y - self.h + self.yVel * dt

    local actualX, actualY, cols, len = world:move(self, finalX, finalY, self.playerFilter)

    self.isGrounded = false
    for i = 1, len do
        local other = cols[i]
        if other.other.isWall then
            if other.normal.y == -1 or other.normal.y == 1 then
                self.yVel = 0
            end

            if other.normal.y == -1 then
                self.isGrounded = true
            end
        end
        if other.other.isCoin then
            --sets coin equal to nil
            coin[other.other.index] = nil
            --remove coin from world
            world:remove(other.other)
        end
    end

    self.x = actualX + self.w * 0.5
    self.y = actualY + self.h
end

function Player:appGravity(dt)
    if self.yVel <= self.maxSpeed then
        self.yVel = self.yVel - self.grav * dt
    end
end

function Player:playerMove(dt)
    if love.keyboard.isScancodeDown("d") then
        currAnim = run
        if self.xVel <= self.maxSpeed then
            self.xVel = self.xVel + self.acc * dt
        end
    elseif love.keyboard.isScancodeDown("a") then
        currAnim = run
        if self.xVel >= -self.maxSpeed then
            self.xVel = self.xVel - self.acc * dt
        end
    else
        currAnim = idle
        
        local friction = 1000
        
        if self.xVel > 0 then
            self.xVel = self.xVel - friction * dt
            if self.xVel < 0 then self.xVel = 0 end
        end

        if self.xVel < 0 then
            self.xVel = self.xVel + friction * dt
            if self.xVel > 0 then self.xVel = 0 end
        end

    end
end

function Player:animChecker()
    if not self.isGrounded then
        if self.yVel ~= 0 then
            if self.yVel < 0 then
                currAnim = air
            elseif self.yVel > 0 then
                currAnim = fall
            end
        end
    end
end

function Player:update(dt)
    currAnim:update(dt)
    Player:playerMove(dt)
    Player:collide(dt)
    Player:appGravity(dt)
    Player:animChecker()
end

function Player:draw()
    currAnim:draw(self.img, self.x, self.y, nil, self.factor, math.abs(self.factor), 4, 8)
end

function love.keypressed(key)
    if key == "w" and Player.isGrounded then
        Player.yVel = -300
    end
    if key == "d" then
        Player.factor = 1
    elseif key == "a" then
        Player.factor = -1
    end
end