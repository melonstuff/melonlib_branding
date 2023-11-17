
local isize = 512
melon.branding.AddBit("melonlib", function(cx, cy, time, panel, st)
    local font = melon.Font(isize * .24)
    local mln_size = isize * .4
    local rx, ry = panel:LocalToScreen(0, 0)
    local tx, ty = cx + (st * 10), cy + mln_size / 2

    local center = Vector(cx + rx, cy + ry, 0)
    local matrix = Matrix()
    matrix:Translate(center)
    matrix:Rotate(Angle(0, st * -2, 0))
    matrix:Translate(-center)

    render.PushFilterMag(TEXFILTER.ANISOTROPIC)
    render.PushFilterMin(TEXFILTER.ANISOTROPIC)
    cam.PushModelMatrix(matrix)
    local _, th = draw.Text({
        text = "MelonLib",
        pos = {tx, ty},
        xalign = 1,
        font = font
    })

    local smallfont = melon.Font(isize * .06)
    surface.SetFont(smallfont)
    local tw = surface.GetTextSize("By modern men, for modern men")
    draw.Text({
        text = melon.branding.play_state.frame != 25 and "By modern men, for modern men" or "By modern men, for modern women :3",
        pos = {tx - tw / 2, ty + th * .7},
        font = smallfont,
        color = {r = 255, g = 255, b = 255, a = 60 - (st * 20)}
    })
    cam.PopModelMatrix()
    render.PopFilterMag()
    render.PopFilterMin()

    local smallerfont = melon.Font(isize * .05)
    draw.Text({
        text = "rendered ingame",
        pos = {cx - (isize / 2 - 10), cy + (isize / 2 - 10)},
        xalign = 0,
        yalign = 4,
        font = smallerfont,
        color = {r = 255, g = 255, b = 255, a = 20}
    })

    draw.Text({
        text = "if you dont see the model, hot-refresh on this tab",
        pos = {cx, cy + isize / 2 + 10},
        xalign = 1,
        yalign = 3,
        font = smallerfont,
        color = {r = 255, g = 255, b = 255, a = 20}
    })

    if not IsValid(panel.Model) then
        panel.Model = vgui.Create("DModelPanel", panel)
        panel.Model:SetSize(isize, isize)
        panel.Model:Center()
        panel.Model:SetModel("models/props_junk/watermelon01.mdl")
        panel.Model:SetDirectionalLight(BOX_TOP, Color(100, 255, 100))
        panel.Model:SetDirectionalLight(BOX_RIGHT, Color(100, 255, 100))
        panel.Model:SetDirectionalLight(BOX_FRONT, Color(100, 255, 100))

        function panel.Model:LayoutEntity(e)
            self:SetLookAt(e:GetPos())
            self:SetCamPos(e:GetPos() - Vector(0, 35, 0))
        end

        function panel.Model:Paint( w, h )
            if not IsValid(self.Entity) then return end
        
            local x,y = self:LocalToScreen(0, 0)
        
            self:LayoutEntity(self.Entity)
        
            local ang = self.aLookAngle
            if not ang then
                ang = (self.vLookatPos - self.vCamPos):Angle()
            end

            cam.Start3D(self.vCamPos, ang, self.fFOV, x, y, w, h, 5, self.FarZ)
                render.SuppressEngineLighting( true )
                render.SetLightingOrigin( self.Entity:GetPos() )
                render.ResetModelLighting( self.colAmbientLight.r / 255, self.colAmbientLight.g / 255, self.colAmbientLight.b / 255 )
                render.SetColorModulation( self.colColor.r / 255, self.colColor.g / 255, self.colColor.b / 255 )
                render.SetBlend( ( self:GetAlpha() / 255 ) * ( self.colColor.a / 255 ) ) -- * surface.GetAlphaMultiplier()
            
                for i = 0, 6 do
                    local col = self.DirectionalLight[ i ]
                    if col then
                        render.SetModelLighting( i, col.r / 255, col.g / 255, col.b / 255 )
                    end
                end
            
                self:DrawModel()
            
                render.SuppressEngineLighting(false)
            cam.End3D()

            self.LastPaint = RealTime()
        end
    end

    local r,p,y = 180 * st, 360 * time, 40
    panel.Model.Entity:SetAngles(Angle(r, p, y))

    return isize, isize
end, {"background"}, 25)

melon.branding.AddBit("melonlibwide", function(cx, cy, time, panel, st)
    local function d(x, y, c)
        local _, th = draw.Text({
            text = "MelonStuff",
            pos = {cx + x, cy + y},
            font = melon.Font(isize * 1),
            xalign = 1,
            yalign = 1,
            color = c
        })
    
        draw.Text({
            text = "Written with love",
            pos = {cx + x, cy + th / 3 + y},
            xalign = 1,
            yalign = 1,
            font = melon.Font(isize * 0.2),
            color = c or {r = 170, g = 170, b = 170, a = 255}
        })
    end

    local t = time * 6.2831853071796
    local x, y = math.cos(t), math.sin(t)

    local factor = 4
    d((factor * 1.5) + x * factor, (factor / 2) + y * factor, {r = 22, g = 22, b = 22, a = 70})
    d(0, 0)

    return isize * 2, isize
end, {"background"}, 25)

melon.Debug(melon.branding.Open)
