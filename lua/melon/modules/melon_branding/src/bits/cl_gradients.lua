

--- this is meant to be pretty, not optimized
--- do NOT copy from this istg
melon.branding.AddBit("gradients", function(cx, cy, time, panel, st)
    local c = {
        {0,   HSVToColor((time * 360) + 0,   0.9, 0.9)},
        {35,  HSVToColor((time * 360) + 25,  0.9, 0.9)},
        {70,  HSVToColor((time * 360) + 50,  0.9, 0.9)},
        {90,  HSVToColor((time * 360) + 75,  0.9, 0.9)},
        {100, HSVToColor((time * 360) + 100, 0.9, 0.9)},
    }

    local c2 = {
        {0,   c[5][2]},
        {35,  c[4][2]},
        {70,  c[3][2]},
        {90,  c[2][2]},
        {100, c[1][2]},
    }

    local g = melon.GradientBuilder()
    
    for k,v in pairs(c) do
        g:Step(v[1], v[2])
    end

    g:LocalTo(panel)

    local size = 300
    g:Render(cx - size / 2, cy - size / 2, size, size)

    surface.SetDrawColor(22, 22, 22, 100)
    surface.DrawOutlinedRect(cx - size / 2, cy - size / 2, size, size, 2)

    local dtext = "this is real"
    local font = melon.Font(40)
    surface.SetFont(font)
    local tw, th = surface.GetTextSize(dtext)
    
    draw.NoTexture()
    surface.DrawTexturedRectRotated(cx, cy, size - 4, th + 20, 0)

    draw.Text({
        text = dtext,
        pos = {cx + 1, cy + 1},
        xalign = 1,
        yalign = 1,
        font = font,
        color = surface.GetDrawColor()
    })

    melon.TextGradient(dtext, font, cx - tw / 2, cy - th / 2, c2)

    return scaled_w, scaled_h
end, {"demo_background"}, 60)
melon.Debug(melon.branding.Open)
