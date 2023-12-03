objectbutton = {}

objectbutton_mt = { __index = objectbutton }

function objectbutton:new(name, text, callback, x, y)
    local entity = {}
    setmetatable(entity, objectbutton_mt)

    entity.name = name
    entity.text = text
    entity.posx = x
    entity.posy = y
    entity.width = font:getWidth(text) + 5
    entity.height = font:getHeight(text) + 2
    entity.callback = callback
    entity.pressed = false

    return entity
end

function objectbutton:mousepressed(x, y, button, istouch, presses)
    if x > self.posx and x < self.posx + self.width + 5 and
        y > self.posy and y < self.posy + self.height then
            if self.name == "showpolygon1" then showpolygon1 = not showpolygon1 end
            if self.name == "showpolygon2" then showpolygon2 = not showpolygon2 end
            if self.name == "showpolygon3" then showpolygon3 = not showpolygon3 end
            if self.name == "showpolygon4" then showpolygon4 = not showpolygon4 end
            if self.name == "rand" then
                perlin:rerandom()
                local perlin_TWOPI = 6.28318530718
                
                polygon4 = {}
                local noiseMax = 2   -- 0.1 is a circle, 150 is chaotic.
                for a=0, perlin_TWOPI, 0.1 do
                    local xoff = map(math.cos(a), -1, 1, 0, noiseMax)
                    local yoff = map(math.sin(a), -1, 1, 0, noiseMax)
                    local r = map(perlin:noise(xoff,yoff),0,1,100,200)
                    local x = r * math.cos(a) + 640 / 2
                    local y = r * math.sin(a) + gameHeight / 2
                    table.insert(polygon4, x)
                    table.insert(polygon4,y)
                end
            end
            if self.name ~= "rand" then self.pressed = not self.pressed end
    end
end

function objectbutton:update(dt)
end

function objectbutton:draw()
    local text = ""
    if self.name ~= "rand" then
        if self.pressed == true then
            love.graphics.setColor(0.5,0.5,0.5)
            text = "Hide " .. string.sub(self.text,5)
        else
            love.graphics.setColor(0,1,0)
            text = "Show " .. string.sub(self.text,5)
        end
    else
        text = "Randomize polygon 4 points"
    end
    love.graphics.rectangle("fill", self.posx, self.posy, self.width, self.height)
    love.graphics.setColor(0,0,0)
    love.graphics.print(text, self.posx + 2, self.posy + 2)
    love.graphics.setColor(1,1,1)
end