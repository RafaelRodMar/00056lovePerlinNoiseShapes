-- Perlin Noise variables and constants
local PERLIN_YWRAPB = 4
local PERLIN_YWRAP = 2 ^ PERLIN_YWRAPB
local PERLIN_ZWRAPB = 8
local PERLIN_ZWRAP = 2 ^ PERLIN_ZWRAPB
local PERLIN_SIZE = 4095

local perlin_octaves = 4
local perlin_amp_falloff = 0.5

-- Initialize Perlin Noise tables
local perlin_TWOPI = 6.28318530718
local perlin_PI
local perlin_cosTable
local perlin = {}
local perlinRandom

-- Function to compute noise
function noise(x, y, z)
    if y == nil then y = 0 end
    if z == nil then z = 0 end

    perlin = {}
    for i = 1, PERLIN_SIZE + 1 do
        perlin[i] = math.random()
    end

    -- Absolutize negative values
    x = math.abs(x)
    y = math.abs(y)
    z = math.abs(z)

    local xi, yi, zi = math.floor(x), math.floor(y), math.floor(z)
    local xf, yf, zf = x - xi, y - yi, z - zi
    local rxf, ryf = 0, 0

    local r = 0
    local ampl = 0.5

    local n1, n2, n3 = 0, 0, 0

    for i = 1, perlin_octaves do
        local of = xi + (yi * PERLIN_YWRAP) + (zi * PERLIN_ZWRAP)

        rxf = noise_fsc(xf)
        ryf = noise_fsc(yf)

        n1 = perlin[(of % PERLIN_SIZE) + 1]
        n1 = n1 + rxf * (perlin[((of + 1) % PERLIN_SIZE) + 1] - n1)
        n2 = perlin[((of + PERLIN_YWRAP) % PERLIN_SIZE) + 1]
        n2 = n2 + rxf * (perlin[((of + PERLIN_YWRAP + 1) % PERLIN_SIZE) + 1] - n2)
        n1 = n1 + ryf * (n2 - n1)

        of = of + PERLIN_ZWRAP
        n2 = perlin[(of % PERLIN_SIZE) + 1]
        n2 = n2 + rxf * (perlin[((of + 1) % PERLIN_SIZE) + 1] - n2)
        n3 = perlin[((of + PERLIN_YWRAP) % PERLIN_SIZE) + 1]
        n3 = n3 + rxf * (perlin[((of + PERLIN_YWRAP + 1) % PERLIN_SIZE) + 1] - n3)
        n2 = n2 + ryf * (n3 - n2)

        n1 = n1 + noise_fsc(zf) * (n2 - n1)

        r = r + n1 * ampl
        ampl = ampl * perlin_amp_falloff
        xi = xi * 2
        xf = xf * 2
        yi = yi * 2
        yf = yf * 2
        zi = zi * 2
        zf = zf * 2

        if xf >= 1.0 then
            xi = xi + 1
            xf = xf - 1
        end
        if yf >= 1.0 then
            yi = yi + 1
            yf = yf - 1
        end
        if zf >= 1.0 then
            zi = zi + 1
            zf = zf - 1
        end
    end
    return r
end

-- Helper function for noise
function noise_fsc(i)
    return 0.5 * (1.0 - math.cos(i * math.pi))
end
