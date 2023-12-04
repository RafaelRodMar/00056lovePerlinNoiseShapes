require 'perlinnoise'
require 'objectbutton'
require 'perlinnoise2'
local perlin_TWOPI = 6.28318530718

-- interpret a value in a range as a value in other range
function map(value, start1, stop1, start2, stop2)
    return start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1))
end

function love.load()
    --variables
    gameWidth = 840
    gameHeight = 480
    love.window.setMode(gameWidth, gameHeight, {resizable=false, vsync=false})
    love.graphics.setBackgroundColor(1,1,1) --white

    --load font
    font = love.graphics.newFont("sansation.ttf",15)
    love.graphics.setFont(font)

    vMouse = {x=0, y=0}
    vClicked = {x=-1, y = -1}

    love.graphics.setPointSize(4)
    math.randomseed(os.time())

    -- generate polygon1 (circle)
    polygon1 = {}
    for a=0, perlin_TWOPI, 0.01 do
        local r = 100
        local x = r * math.cos(a) + 640 / 2
        local y = r * math.sin(a) + gameHeight / 2
        table.insert(polygon1, x)
        table.insert(polygon1,y)
    end

    -- generate polygon2 (circle with random points)
    polygon2 = {}
    for a=0, perlin_TWOPI, 0.1 do
        local r = math.random(50,100)
        local x = r * math.cos(a) + 640 / 2
        local y = r * math.sin(a) + gameHeight / 2
        table.insert(polygon2, x)
        table.insert(polygon2,y)
    end

    -- generate polygon3 (perlin noise)
    polygon3 = {}
    local t = 0
    for a=0, perlin_TWOPI, 0.1 do
        local r = map(noise(t),0,1,100,200)
        local x = r * math.cos(a) + 640 / 2
        local y = r * math.sin(a) + gameHeight / 2
        table.insert(polygon3, x)
        table.insert(polygon3,y)
        t = t + 0.01
    end

    -- generate polygon4 (perlin noise)
    polygon4 = {}
    local noiseMax = 2   -- 0.1 is a circle, 150 is chaotic.
    for a=0, perlin_TWOPI, 0.1 do
        local xoff = map(math.cos(a), -1, 1, 0, noiseMax)
        local yoff = map(math.sin(a), -1, 1, 0, noiseMax)
        local r = map(perlin:noise(xoff,yoff),-1,1,100,200)
        local x = r * math.cos(a) + 640 / 2
        local y = r * math.sin(a) + gameHeight / 2
        table.insert(polygon4, x)
        table.insert(polygon4,y)
    end

    -- create some buttons
    buttons = {}

    table.insert(buttons, objectbutton:new("showpolygon1", "Show polygon 1", 0, 650, 20))
    table.insert(buttons, objectbutton:new("showpolygon2", "Show polygon 2", 0, 650, 40))
    table.insert(buttons, objectbutton:new("showpolygon3", "Show polygon 3", 0, 650, 60))
    table.insert(buttons, objectbutton:new("showpolygon4", "Show polygon 4", 0, 650, 80))
    table.insert(buttons, objectbutton:new("rand", "Randomize polygon 4 points", 0, 650, 100))
    showpolygon1 = false
    showpolygon2 = false
    showpolygon3 = false
    showpolygon4 = false
end

function love.mousemoved( x, y, dx, dy, istouch )
    vMouse.x = x
    vMouse.y = y
end

function love.mousepressed(x,y,button, istouch, presses)
	if button == 1 then
        vClicked.x = x
        vClicked.y = y
	end

    for i=1, #buttons do
        buttons[i]:mousepressed(x,y,button,istouch,presses)
    end
end

function love.update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(1,1,1)
    love.graphics.setColor(0,0,0)

    -- draw the polygon1
    if showpolygon1 then
        love.graphics.polygon("line", polygon1)
    end

    if showpolygon2 then
        love.graphics.polygon("line", polygon2)
    end

    if showpolygon3 then
        love.graphics.polygon("line", polygon3)
    end

    if showpolygon4 then
        love.graphics.polygon("line", polygon4)
    end

    for i=1, #buttons do
        buttons[i]:draw()
    end

    -- Draw Debug Info
    --draw UI
    love.graphics.setColor(1,0,0)
    love.graphics.print("Mouse: " .. vMouse.x .. "," .. vMouse.y, 650, 400)
    love.graphics.print("Clicked: " .. vClicked.x .. "," .. vClicked.y, 650, 420)
end