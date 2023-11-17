local brandingsize = ScrW()
melon.branding.AddBit("background", function(cx, cy, time, panel, st)
    local w,h = brandingsize, brandingsize
    local x,y = cx - w / 2, cy - h / 2
    local dist = 45
    local lines = math.ceil(math.max(w, h) / dist)
    surface.SetDrawColor(12, 104, 129)
    surface.DrawRect(x, y, w, h)

    surface.SetMaterial(melon.Material("vgui/gradient-l"))
    surface.SetDrawColor(0, 107, 106)
    surface.DrawTexturedRectRotated(cx, cy, w * 1.5 + st, h * 1.5, st * 20)

    local offset = st * 10
    for i = -1, lines + 1 do
        surface.SetDrawColor(255, 255, 255, 35 - (st * (math.abs(math.sin(i / lines) + st) * 25)))

        local dst = (math.max(w, h) / lines) * i
        surface.DrawLine(x + dst - dist - offset, y, x + dst + dist + offset, y + h)
        surface.DrawLine(x, y + dst + dist + offset, x + w, y + dst - dist - offset)
    end

    return w, h
end, {})

local scale = .75
local scaled_w, scaled_h = ScrW() * scale, ScrH() * scale
melon.branding.AddBit("demo_background", function(cx, cy, time, panel, st)
    local x, y = cx - (scaled_w / 2), cy - (scaled_h / 2)
    local melonsize = scaled_w * 0.04

    surface.SetDrawColor(255, 255, 255, 20)
    local tw = draw.Text({
        text = "MelonLib",
        pos = {x + 10, y + (melonsize - 10)},
        font = melon.Font(scaled_w * 0.03),
        color = surface.GetDrawColor()
    })

    melon.DrawImage("https://i.imgur.com/rUpDQFy.png", x + 10 + tw / 2 - (melonsize / 2), y, melonsize, melonsize)

    draw.Text({
        text = "rendered ingame",
        pos = {x + 14, y + scaled_h - 10},
        yalign = 4,
        font = melon.Font(scaled_w * 0.02),
        color = {r = 255, g = 255, b = 255, a = 20}
    })

    return scaled_w, scaled_h
end, {"background"})
melon.Debug(melon.branding.Open)
