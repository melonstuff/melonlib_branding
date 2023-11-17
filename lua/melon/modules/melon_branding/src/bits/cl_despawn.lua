

melon.branding.AddBit("despawn", function(cx, cy, time, panel, st)
    surface.SetDrawColor(26, 26, 26)
    surface.DrawRect(0, 0, ScrW(), ScrH())

    if not IsValid(panel.Model) then
        panel.Model = vgui.Create("DModelPanel", panel)
        panel.Model:SetSize(512, 512)
        panel.Model:Center()
        panel.Model:SetModel("models/weapons/w_toolgun.mdl")
        panel.Model:SetPaintedManually(true)

        function panel.Model:LayoutEntity(e)
            local center = e:GetPos() + Vector(6,0,2)
            self:SetLookAt(center)
            self:SetCamPos(center - Vector(0, 15, 0))
        end

        function panel.Model:PreDrawModel(e) 
            -- self.Entity:SetMaterial("Models/effects/comball_tape")
            -- self.Entity:DrawModel()

            self:Scissor()
            self.Entity:SetMaterial("models/props_combine/tprings_globe")
            -- self.Entity:DrawModel()
        end

        function panel.Model:Scissor(o, y)
            local rx, ry = self:LocalToScreen()

            ry = ry + (y or 0)
            local offset = ry - ((self:GetTall() * 2) * self.time) + self:GetTall() + (o or 0)
            render.SetScissorRect(-rx, offset, rx + ScrW(), offset + self:GetTall(), true)
        end
    end

    panel.Model.material = melon.GradientBuilder("branding_despawn")
        :Reset()
        :Step(0,   melon.colors.Lerp(st, Color(88, 154, 202), Color(151, 185, 237)))
        :Step(50, Color(113, 47, 255))
        :Step(100, melon.colors.Lerp(st, Color(113, 47, 255), Color(116, 237, 215)))
        :Material()
    panel.Model.time = time
    panel.Model.Entity:SetAngles(Angle(10 * st, 20 * st, 20 * st + (5 * st)))

    local x,y = cx - 256, cy - 256
    local dist = 35
    
    melon.masks.Start()
        surface.SetDrawColor(255,255,255)
        surface.SetMaterial(panel.Model.material)
        surface.DrawTexturedRectRotated(cx, cy, 512, 512, 0)

        for i = -1, (512 / dist) + 1 do
            local pos = i * dist
            surface.SetDrawColor(255, 255, 255, 80)
            surface.DrawLine(x + pos - dist, y, x + pos + dist, y + 512)
        end
    melon.masks.Source()
        panel.Model:PaintAt(cx - 256, cy - 256, 512, 512)

        local t = {
            text = "despawn",
            pos = {cx, cy},
            xalign = 1,
            yalign = 1,
            font = melon.Font(110, "SF Pro Rounded Heavy"),
        }

        panel.Model:Scissor(512, -30)
        draw.Text(t)

        panel.Model:Scissor(-512, -30)
        draw.Text(t)
    
        -- t.text = "labs"
        -- t.pos[2] = cy + 256
        -- t.yalign = 4
        -- draw.Text(t)

        render.SetScissorRect(0,0,0,0,false)
    
        for i = -1, (512 / dist) + 1 do
            local pos = i * dist
            surface.SetDrawColor(255, 255, 255, 40)
            surface.DrawLine(x, y + pos - dist, x + 512, y + pos + dist)
        end
    melon.masks.End()

    return 512, 512
end, nil, 60)
melon.Debug(melon.branding.Open)
