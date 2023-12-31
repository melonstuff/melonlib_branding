local text = Color(77, 77, 77)
local inactive = Color(94, 92, 230, 100)
local active = Color(94, 92, 230)

----
---@internal
---@module
---@name melon.branding
---@realm CLIENT
----
---- Renders MelonLib branding dynamically ingame
---- Feel free to look at this but I dont recommend modifying it lol
---- Always export gifs with 30ms between frames
----
melon.branding = melon.branding or {}
melon.branding.bits = melon.branding.bits or {}
melon.branding.play_state = {
    playing = true,
    frame = 0,
    rendering = false
}
melon.branding.fps = 30

melon.branding.RT = GetRenderTarget("MelonBranding", ScrW(), ScrH())
melon.branding.Mat = CreateMaterial("MelonBranding", "UnlitGeneric", {
    ["$basetexture"] = melon.branding.RT:GetName(),
    ["$translucent"] = "1",
    ["$vertexcolor"] = "1",
    ["$vertexalpha"] = "1"
})

file.CreateDir("melon")
file.CreateDir("melon/branding")

----
---@name melon.branding.Open
----
---- Opens the branding UI
----
function melon.branding.Open()
    if IsValid(melon.branding.UI) then
        melon.branding.UI:Remove()
    end

    melon.branding.UI = vgui.Create("DFrame")
    melon.branding.UI:SetTitle("MelonLib Branding")
    melon.branding.UI:SetSize(ScrW(), ScrH())
    melon.branding.UI:MakePopup()
    melon.branding.UI.Paint = nil

    melon.branding.UI.OnMouseWheeled = function(s, d)
        local max = melon.branding.bits[s.Tabs:GetActiveTab()].frames

        melon.branding.play_state.frame = melon.branding.play_state.frame + d
        melon.branding.play_state.frame = math.Clamp(melon.branding.play_state.frame, 0, max)
    end

    function melon.branding.UI:Think()
        local s = melon.branding.play_state
        local c = melon.branding.bits[melon.branding.UI.Tabs:GetActiveTab()]

        if s.rendering then
            return
        end

        if c.frames == 1 then
            s.frame = 1
            return
        end

        if not s.playing then return end
        s.last = s.last or 0
        if CurTime() < s.last then
            return
        end

        s.last = CurTime() + (1 / melon.branding.fps)

        s.frame = s.frame + 1

        if s.frame > c.frames then
            s.frame = 0
        end
    end

    if gui.IsGameUIVisible() then
        gui.HideGameUI()
    end

    melon.branding.UI.Sidebar = vgui.Create("DPanel", melon.branding.UI)
    melon.branding.UI.Tabs = vgui.Create("Melon:Tabs", melon.branding.UI)

    melon.branding.UI.Sidebar:Dock(LEFT)
    melon.branding.UI.Sidebar:SetWide(melon.Scale(200))

    melon.branding.UI.Tabs:Dock(FILL)

    melon.branding.UI.Sidebar.Controls = vgui.Create("Panel", melon.branding.UI.Sidebar)
    melon.branding.UI.Sidebar.Controls:Dock(TOP)
    melon.branding.UI.Sidebar.Controls:SetTall(melon.Scale(34))
    melon.branding.UI.Sidebar.Controls:DockMargin(2, 2, 2, 2)

    melon.branding.UI.Sidebar.Controls.Paint = function(s, w, h)
        draw.Text({
            text = math.Round((melon.branding.play_state.frame / melon.branding.bits[melon.branding.UI.Tabs:GetActiveTab()].frames) * 100) .. "%",
            pos = {w, h / 2},
            xalign = 2,
            yalign = 1,
            font = melon.Font(20, "Inter"),
            color = text
        })
    end

    melon.branding.UI.Sidebar.Controls.PlayPause = vgui.Create("Melon:Button", melon.branding.UI.Sidebar.Controls)
    melon.branding.UI.Sidebar.Controls.PlayPause:Dock(LEFT)
    melon.branding.UI.Sidebar.Controls.PlayPause:SetWide(melon.branding.UI.Sidebar.Controls:GetTall())
    melon.branding.UI.Sidebar.Controls.PlayPause.DoubleClickTime = 0

    melon.branding.UI.Sidebar.Controls.Stop = vgui.Create("Melon:Button", melon.branding.UI.Sidebar.Controls)
    melon.branding.UI.Sidebar.Controls.Stop:Dock(LEFT)
    melon.branding.UI.Sidebar.Controls.Stop:DockMargin(2, 0, 0, 0)
    melon.branding.UI.Sidebar.Controls.Stop:SetWide(melon.branding.UI.Sidebar.Controls:GetTall())
    melon.branding.UI.Sidebar.Controls.Stop.DoubleClickTime = 0

    melon.branding.UI.Sidebar.Controls.Visibility = vgui.Create("Melon:Button", melon.branding.UI.Sidebar.Controls)
    melon.branding.UI.Sidebar.Controls.Visibility:Dock(LEFT)
    melon.branding.UI.Sidebar.Controls.Visibility:DockMargin(2, 0, 0, 0)
    melon.branding.UI.Sidebar.Controls.Visibility:SetWide(melon.branding.UI.Sidebar.Controls:GetTall())
    melon.branding.UI.Sidebar.Controls.Visibility.DoubleClickTime = 0

    melon.branding.UI.Sidebar.Controls.PlayPause.Paint = function(s, w, h)
        local scale = .5
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(melon.Material(melon.branding.play_state.playing and "icon16/control_pause.png" or "icon16/control_play.png"))
        surface.DrawTexturedRectRotated(w / 2, h / 2, w * scale, h * scale, 0)
    end

    melon.branding.UI.Sidebar.Controls.Stop.Paint = function(s, w, h)
        local scale = .5
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(melon.Material("icon16/control_stop.png"))
        surface.DrawTexturedRectRotated(w / 2, h / 2, w * scale, h * scale, 0)
    end

    melon.branding.UI.Sidebar.Controls.Visibility.Paint = function(s, w, h)
        local scale = .5
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(melon.Material(melon.branding.visibility and "icon16/delete.png" or "icon16/eye.png"))
        surface.DrawTexturedRectRotated(w / 2, h / 2, w * scale, h * scale, 0)
    end

    melon.branding.UI.Sidebar.Controls.PlayPause.LeftClick = function()
        if melon.branding.play_state.rendering then return end
    
        melon.branding.play_state.playing = not melon.branding.play_state.playing
    end

    melon.branding.UI.Sidebar.Controls.Stop.LeftClick = function()
        if melon.branding.play_state.rendering then return end

        melon.branding.play_state = {
            playing = false,
            frame = 0
        }
    end

    melon.branding.UI.Sidebar.Controls.Visibility.LeftClick = function()
        if melon.branding.play_state.rendering then return end
       
        melon.branding.visibility = not melon.branding.visibility
    end

    melon.branding.UI.Sidebar.Render = vgui.Create("Melon:Button", melon.branding.UI.Sidebar)
    melon.branding.UI.Sidebar.Render:Dock(BOTTOM)
    melon.branding.UI.Sidebar.Render:SetTall(melon.Scale(34))
    melon.branding.UI.Sidebar.Render:DockMargin(2, 0, 2, 2)

    melon.branding.UI.Sidebar.Render.Paint = function(s,w,h)
        draw.RoundedBox(melon.Scale(6), 0, 0, w, h, melon.branding.play_state.rendering and active or inactive)

        draw.Text({
            text = melon.branding.play_state.rendering and "Rendering..." or "Render",
            pos = {w / 2, h / 2 + 2},
            color = color_white,
            xalign = 1,
            yalign = 1,
            font = melon.Font(30)
        })
    end

    melon.branding.UI.Sidebar.Render.LeftClick = function()
        if melon.branding.play_state.rendering then return end

        melon.branding.play_state = {
            playing = false,
            frame = 0,
            rendering = true
        }
    end

    for k,v in SortedPairsByMemberValue(melon.branding.bits, "order") do
        local btn = vgui.Create("Melon:Button", melon.branding.UI.Sidebar)
        AccessorFunc(btn, "Active", "Active") -- cursed af i know

        btn.DoubleClickTime = 0
        btn:Dock(TOP)
        btn:DockMargin(2, 2, 2, 0)
        btn:SetTall(melon.Scale(34))
        btn:SetActive(melon.branding.UI.Tabs:GetActiveTab() == nil)
        function btn:Paint(w, h)
            self.color = melon.colors.Lerp(FrameTime() * 10, self.color or (self:GetActive() and active or inactive), self:GetActive() and active or inactive)

            draw.RoundedBox(melon.Scale(6), 0, 0, w, h, self.color)

            local pad = melon.Scale(4)
            draw.RoundedBox(melon.Scale(4), pad, pad, w - pad - pad, h - pad - pad, color_white)
            
            draw.Text({
                text = k,
                pos = {w / 2, h / 2},
                xalign = 1,
                yalign = 1,
                font = melon.Font(20, "Inter", 900),
                color = text
            })
        end 

        function btn:LeftClick()
            if melon.branding.play_state.rendering then return end

            melon.branding.UI.Tabs:SetTab(k)
        end

        local tab = vgui.Create("Panel", melon.branding.UI.Tabs)
        melon.branding.UI.Tabs:AddTab(k, tab)
        tab.LinkedButton = btn

        tab.Paint = function(s, w, h)
            local time = melon.branding.play_state.frame / v.frames

            local rw, rh = v.func(w / 2, h / 2, time, s, math.sin(time * 6.2831853071796))

            if not rw or not rh then
                return
            end

            s.RenderSize = {w = rw, h = rh}

            if melon.branding.visibility then
                surface.SetDrawColor(22, 22, 22)
                surface.DrawRect(0, 0, w / 2 - rw / 2, h)
                surface.DrawRect(w / 2 + rw / 2, 0, w / 2 - rw / 2, h)
                surface.DrawRect(w / 2 - rw / 2, 0, rw, h / 2 - rh / 2)
                surface.DrawRect(w / 2 - rw / 2, h / 2 + rh / 2, rw, h / 2 - rh / 2)
                return
            end

            local pad = 4
            surface.SetDrawColor(255, 255, 255, 20)
            surface.DrawLine(pad, pad, w / 2 - rw / 2 - pad, h / 2 - rh / 2 - pad)
            surface.DrawLine(w - pad, pad, w / 2 + rw / 2 + pad, h / 2 - rh / 2 - pad)
            surface.DrawLine(w - pad, h - pad, w / 2 + rw / 2 + pad, h / 2 + rh / 2 + pad)
            surface.DrawLine(pad, h - pad, w / 2 - rw / 2 - pad, h / 2 + rh / 2 + pad)

            surface.SetDrawColor(255, 255, 255)
            surface.DrawLine(w / 2 - rw / 2, h / 2 - rh / 2, w / 2 - rw / 2, h / 2 + rh / 2)
            surface.DrawLine(w / 2 - rw / 2, h / 2 + rh / 2, w / 2 + rw / 2, h / 2 + rh / 2)
            surface.DrawLine(w / 2 + rw / 2, h / 2 + rh / 2, w / 2 + rw / 2, h / 2 - rh / 2)
            surface.DrawLine(w / 2 - rw / 2, h / 2 - rh / 2, w / 2 + rw / 2, h / 2 - rh / 2)
        end
    end

    function melon.branding.UI.Tabs:OnTabChanged(new, old)
        melon.branding.UI.Sidebar.Controls.Stop.LeftClick()
    
        if IsValid(old) then
            old.LinkedButton:SetActive(false)
        end

        melon.branding.OldActive = self:GetActiveTab()
        new.LinkedButton:SetActive(true)
        melon.branding.play_state.playing = true
    end

    if melon.branding.OldActive and melon.branding.UI.Tabs.tabs[melon.branding.OldActive] then
        melon.branding.UI.Tabs:SetTab(melon.branding.OldActive)
    end
end

local render_queued
function melon.branding.RenderFrame()
    if not melon.branding.play_state.rendering then return end

    if melon.branding.play_state.frame > melon.branding.bits[melon.branding.UI.Tabs:GetActiveTab()].frames then
        melon.branding.play_state.rendering = false
        melon.branding.play_state.frame = 0
        return
    end

    render_queued = true
end

hook.Add("PreRender", "MelonBrandingRender", function()
    melon.branding.RenderFrame()
end )

hook.Add("PostRender", "MelonBrandingRender", function()
    if not render_queued then return end
    
    local p = melon.branding.UI.Tabs.tabs[melon.branding.UI.Tabs:GetActiveTab()]
    local x,y = p:LocalToScreen(p:GetWide() / 2 - p.RenderSize.w / 2, p:GetTall() / 2 - p.RenderSize.h / 2)

    local data = render.Capture({
        format = "png",
        x = x,
        y = y,
        w = p.RenderSize.w,
        h = p.RenderSize.h,
        alpha = false
    })

    local fold = "melon/branding/" .. melon.branding.UI.Tabs:GetActiveTab() .. "/"
    file.CreateDir(fold)
    file.Write(fold .. melon.branding.play_state.frame .. ".png", data)

    melon.branding.play_state.frame = melon.branding.play_state.frame + 1

    render_queued = false
end )

local order = 0
----
---@name melon.branding.AddBit
----
---@arg (name:   string) Name of the bit
---@arg (render:   func) Render function for the bit
---@arg (pre:     table) Table of bits to render before this one
---@arg (frames: number) Number of frames to render when rendering this bit
----
---- Adds a "branding bit" which is basically one individual item
----
function melon.branding.AddBit(name, func, pre, frames)
    melon.branding.bits[name] = {
        order = order,
        func = function(...)
            for k, v in ipairs(pre or {}) do
                if melon.branding.bits[v] then
                    melon.branding.bits[v].func(...)
                end
            end

            return func(...) --- (centerx, centery, time, panel, sine_time) -> (w, h)
        end,
        frames = frames or melon.branding.fps
    }
    order = order + 1
end


concommand.Add("melon_branding", function(lp)
    if not IsValid(lp) then return end
    if not lp:IsSuperAdmin() then return end

    melon.Debug(melon.branding.Open)
end)