
melon.branding.AddBit("melonsmasks", function(cx, cy, time, panel, st)
    local w, h = 512, 512
    local x, y = cx - w / 2, cy - h / 2

    local ol = 4
    local matrix = Matrix()
    local center = Vector(x + w / 2, y + h / 2)

    matrix:Translate(center)
    matrix:Rotate(Angle(0, 45, 0))
    matrix:Translate(-center)

    local g1 = melon.GradientBuilder("melonsmasks_branding_colors")
        :Reset()
        :Step(0,   melon.colors.Lerp(st, Color(88, 154, 202), Color(151, 185, 237)))
        :Step(50, Color(113, 47, 255))
        :Step(100, melon.colors.Lerp(st, Color(113, 47, 255), Color(116, 237, 215)))

    local masks = melon.masks
    masks.Start()
        g1:Render(x, y, w, h)
    masks.Source()
        draw.RoundedBox(18, x, y, w, h, color_white)
    masks.And(masks.KIND_CUT) 
        draw.RoundedBox(18 - ol / 2, x + ol, y + ol, w - ol - ol, h - ol - ol, {
            r = 255,
            g = 255,
            b = 255,
            a = 100
        })
    masks.End(masks.KIND_STAMP)

    masks.Start()
        surface.SetDrawColor(33, 33, 33)
        surface.DrawRect(x, y, w, h)
    masks.Source()
        cam.PushModelMatrix(matrix)
        render.PushFilterMin(TEXFILTER.ANISOTROPIC)
        render.PushFilterMag(TEXFILTER.ANISOTROPIC)
        draw.Text({
            text = "Melon's Masks",
            pos = {x + (w / 2) + 2, y + (h / 2) + 2},
            xalign = 1,
            yalign = 1,
            font = melon.Font(w * .25)
        })
        render.PopFilterMin()
        render.PopFilterMag()
        cam.PopModelMatrix()
    masks.End(masks.KIND_CUT)

    local mat = g1:Material()

    masks.Start()
        surface.SetMaterial(mat)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRectRotated(cx, cy, w, h, 90)
    masks.Source()
        cam.PushModelMatrix(matrix)
        render.PushFilterMin(TEXFILTER.ANISOTROPIC)
        render.PushFilterMag(TEXFILTER.ANISOTROPIC)
        draw.Text({
            text = "Melon's Masks",
            pos = {x + (w / 2), y + (h / 2)},
            xalign = 1,
            yalign = 1,
            font = melon.Font(w * .25)
        })
        render.PopFilterMin()
        render.PopFilterMag()
        cam.PopModelMatrix()
    masks.End(masks.KIND_CUT)

    return 1024, 542
end, {}, 30)
melon.Debug(melon.branding.Open)
