local mvars = {}
local npc_rel = {}

table.insert( mvars, CreateClientConVar( "minimap_x_pos", "200" ) )
table.insert( mvars, CreateClientConVar( "minimap_y_pos", "200" ) )
table.insert( mvars, CreateClientConVar( "minimap_scale", "1" ) )
table.insert( mvars, CreateClientConVar( "minimap_b_r", "33" ) )
table.insert( mvars, CreateClientConVar( "minimap_b_g", "33" ) )
table.insert( mvars, CreateClientConVar( "minimap_b_b", "39" ) )
table.insert( mvars, CreateClientConVar( "minimap_b_a", "242" ) )
table.insert( mvars, CreateClientConVar( "minimap_l_r", "55" ) )
table.insert( mvars, CreateClientConVar( "minimap_l_g", "200" ) )
table.insert( mvars, CreateClientConVar( "minimap_l_b", "255" ) )
table.insert( mvars, CreateClientConVar( "minimap_l_a", "255" ) )
table.insert( mvars, CreateClientConVar( "minimap_lp_r", "55" ) )
table.insert( mvars, CreateClientConVar( "minimap_lp_g", "200" ) )
table.insert( mvars, CreateClientConVar( "minimap_lp_b", "255" ) )
table.insert( mvars, CreateClientConVar( "minimap_lp_a", "255" ) )
table.insert( mvars, CreateClientConVar( "minimap_p_r", "31" ) )
table.insert( mvars, CreateClientConVar( "minimap_p_g", "135" ) )
table.insert( mvars, CreateClientConVar( "minimap_p_b", "27" ) )
table.insert( mvars, CreateClientConVar( "minimap_p_a", "255" ) )
table.insert( mvars, CreateClientConVar( "minimap_nl_r", "31" ) )
table.insert( mvars, CreateClientConVar( "minimap_nl_g", "135" ) )
table.insert( mvars, CreateClientConVar( "minimap_nl_b", "27" ) )
table.insert( mvars, CreateClientConVar( "minimap_nl_a", "255" ) )
table.insert( mvars, CreateClientConVar( "minimap_nh_r", "212" ) )
table.insert( mvars, CreateClientConVar( "minimap_nh_g", "0" ) )
table.insert( mvars, CreateClientConVar( "minimap_nh_b", "0" ) )
table.insert( mvars, CreateClientConVar( "minimap_nh_a", "255" ) )

cvars.AddChangeCallback("minimap_x_pos", function(name, old, new)
    print(name, old, new)
end)

net.Receive( "minimap_check_npc_status_send", function( len )
	npc_rel[net.ReadEntity()] = net.ReadBool()
end)

function draw.Circle( x, y, radius )
	local cir = {}

	table.insert( cir, { x = x, y = y-1, u = 0.5, v = 0.5 } )
	for i = 0, 100 do
		local a = math.rad( ( i / 100 ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 )
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

hook.Add( "OnEntityCreated", "NicksMinimapNpcCheck", function( ent )
	if ent:IsNPC() then
		net.Start( "minimap_check_npc_status_get" )
			net.WriteEntity( ent )
		net.SendToServer()
	end
end)

timer.Create( "NicksMinimapTimer", 60, 0, function()
	for k, v in pairs(npc_rel) do
		if not IsValid(k) then
			npc_rel[k] = nil
		end
	end
end)

hook.Add( "HUDPaint", "NicksMinimapHud", function()
	local center = Vector( GetConVar( "minimap_x_pos" ):GetFloat(), GetConVar( "minimap_y_pos" ):GetFloat() )
	local line_clr = Color( GetConVar("minimap_l_r"):GetInt(), GetConVar("minimap_l_g"):GetInt(), GetConVar("minimap_l_b"):GetInt(), GetConVar("minimap_l_a"):GetInt() )
	local scl = GetConVar("minimap_scale"):GetFloat()
	
	--minimap
	surface.SetDrawColor( GetConVar("minimap_b_r"):GetInt(), GetConVar("minimap_b_g"):GetInt(), GetConVar("minimap_b_b"):GetInt(), GetConVar("minimap_b_a"):GetInt() )
	draw.Circle( center.x, center.y, (ScrW()/ScrH()*80-0.5)*scl )
	
	surface.SetDrawColor( line_clr:Unpack() )
	surface.DrawLine( center.x-ScrW()*0.074*scl, center.y, center.x+ScrW()*0.074*scl, center.y )
	surface.DrawLine( center.x, center.y-ScrH()*0.131*scl, center.x, center.y+ScrH()*0.131*scl )
	
	surface.DrawLine( center.x-ScrW()*0.052*scl, center.y-ScrH()*0.093*scl, center.x+ScrW()*0.052*scl, center.y+ScrH()*0.093*scl )
	surface.DrawLine( center.x+ScrW()*0.052*scl, center.y-ScrH()*0.093*scl, center.x-ScrW()*0.052*scl, center.y+ScrH()*0.093*scl )
	
	for i=0.0182, 0.08, 0.0186 do
		draw.Circle( center.x-(ScrW()*i)*scl, center.y, (ScrW()/ScrH()*1.5)*scl )
		draw.Circle( center.x+(ScrW()*i)*scl, center.y, (ScrW()/ScrH()*1.5)*scl )
	end

	for i=0.0325, 0.150, 0.0328 do
		draw.Circle( center.x, center.y-(ScrH()*i)*scl, (ScrW()/ScrH()*1.5)*scl )
		draw.Circle( center.x, center.y+(ScrH()*i)*scl, (ScrW()/ScrH()*1.5)*scl )
	end	
	
	--player/npc positions
	local Ppos = LocalPlayer():GetPos()
	local Pang = LocalPlayer():GetAngles()
	Pang.x = 0
	Pang.z = 0
	Pang.y = Pang.y - 90
	local Spos = Vector( Ppos.x, Ppos.y, Ppos.z-10000 )
	local Epos = Vector( Ppos.x, Ppos.y, Ppos.z+10000 )
	Ppos.z = 0
	local m = Matrix()
	m:Translate( center )
	m:Rotate( Pang )
	m:Translate( -center )
	local dr = {}
	for k, v in ipairs(ents.FindAlongRay( Spos, Epos, Vector( -1000, -1000, -1000 ), Vector( 1000, 1000, 1000 ) )) do
		local rPos = ((v:GetPos() - Ppos) * 0.13)*scl
		local x,y = center.x + rPos.x, center.y - rPos.y
		
		if v:IsPlayer() and v ~= LocalPlayer() then
			table.insert( dr, { x = x, y = y, s = (v:BoundingRadius()/7)*scl, c = Color( GetConVar("minimap_p_r"):GetInt(), GetConVar("minimap_p_g"):GetInt(), GetConVar("minimap_p_b"):GetInt(), GetConVar("minimap_p_a"):GetInt() ) })
		elseif v:IsNPC() then
			if npc_rel[v] ~= nil then
				table.insert( dr, { x = x, y = y, s = (v:BoundingRadius()/7)*scl, c = ( npc_rel[v] and Color( GetConVar("minimap_nh_r"):GetInt(), GetConVar("minimap_nh_g"):GetInt(), GetConVar("minimap_nh_b"):GetInt(), GetConVar("minimap_nh_a"):GetInt() ) ) or Color( GetConVar("minimap_nl_r"):GetInt(), GetConVar("minimap_nl_g"):GetInt(), GetConVar("minimap_nl_b"):GetInt(), GetConVar("minimap_nl_a"):GetInt() ) })
			else
				net.Start( "minimap_check_npc_status_get" )
					net.WriteEntity( v )
				net.SendToServer()
			end
		end
	end
	
	cam.PushModelMatrix( m )
		surface.DrawCircle( center.x, center.y, (ScrW()/ScrH()*80)*scl, line_clr:Unpack() )
		surface.DrawCircle( center.x, center.y, (ScrW()/ScrH()*60)*scl, line_clr:Unpack() )
		surface.DrawCircle( center.x, center.y, (ScrW()/ScrH()*40)*scl, line_clr:Unpack() )
		surface.DrawCircle( center.x, center.y, (ScrW()/ScrH()*20)*scl, line_clr:Unpack() )
			
		for k, v in pairs(dr) do
			surface.SetDrawColor( v.c:Unpack() )	
			surface.DrawRect(v.x-(v.s/2), v.y-(v.s)/2, v.s, v.s)
		end
	cam.PopModelMatrix()
	
	--player
	surface.SetDrawColor( GetConVar("minimap_lp_r"):GetInt(), GetConVar("minimap_lp_g"):GetInt(), GetConVar("minimap_lp_b"):GetInt(), GetConVar("minimap_lp_a"):GetInt() )	
	draw.Circle( center.x, center.y, (ScrW()/ScrH()*3.33)*scl )
end)

local function options( pnl )
	local reset = vgui.Create( "DButton" )
	reset:SetText( "Reset To Default" )
	reset.DoClick = function()
		for k, v in ipairs( mvars ) do
			v:Revert()
		end
	end
	pnl:AddItem( reset )
	
	pnl:NumSlider( "Minimap X coordinate", "minimap_x_pos", 0, ScrW() )
	pnl:NumSlider( "Minimap Y coordinate", "minimap_y_pos", 0, ScrH() )
	pnl:NumSlider( "Minimap scale", "minimap_scale", 0, 10 )
	
	local bc = vgui.Create( "DColorMixer" )
	bc:Dock(FILL)
	bc:SetConVarA( "minimap_b_a" )
	bc:SetConVarR( "minimap_b_r" )
	bc:SetConVarG( "minimap_b_g" )
	bc:SetConVarB( "minimap_b_b" )
	bc:SetColor( Color( GetConVar("minimap_b_r"):GetInt(), GetConVar("minimap_b_g"):GetInt(), GetConVar("minimap_b_b"):GetInt(), GetConVar("minimap_b_a"):GetInt() ) )
	
	pnl:Help( "Background Color" )
	pnl:AddItem( bc )
	
	local lc = vgui.Create( "DColorMixer" )
	lc:Dock(FILL)
	lc:SetConVarA( "minimap_l_a" )
	lc:SetConVarR( "minimap_l_r" )
	lc:SetConVarG( "minimap_l_g" )
	lc:SetConVarB( "minimap_l_b" )
	lc:SetColor( Color( GetConVar("minimap_l_r"):GetInt(), GetConVar("minimap_l_g"):GetInt(), GetConVar("minimap_l_b"):GetInt(), GetConVar("minimap_l_a"):GetInt() ) )
	
	pnl:Help( "Line Color" )
	pnl:AddItem( lc )
	
	local pyc = vgui.Create( "DColorMixer" )
	pyc:Dock(FILL)
	pyc:SetConVarA( "minimap_lp_a" )
	pyc:SetConVarR( "minimap_lp_r" )
	pyc:SetConVarG( "minimap_lp_g" )
	pyc:SetConVarB( "minimap_lp_b" )
	pyc:SetColor( Color( GetConVar("minimap_lp_r"):GetInt(), GetConVar("minimap_lp_g"):GetInt(), GetConVar("minimap_lp_b"):GetInt(), GetConVar("minimap_lp_a"):GetInt() ) )
	
	pnl:Help( "Player(you) Color" )
	pnl:AddItem( pyc )
	
	local poc = vgui.Create( "DColorMixer" )
	poc:Dock(FILL)
	poc:SetConVarA( "minimap_p_a" )
	poc:SetConVarR( "minimap_p_r" )
	poc:SetConVarG( "minimap_p_g" )
	poc:SetConVarB( "minimap_p_b" )
	poc:SetColor( Color( GetConVar("minimap_p_r"):GetInt(), GetConVar("minimap_p_g"):GetInt(), GetConVar("minimap_p_b"):GetInt(), GetConVar("minimap_p_a"):GetInt() ) )
	
	pnl:Help( "Players(others) Color" )
	pnl:AddItem( poc )
	
	local fnc = vgui.Create( "DColorMixer" )
	fnc:Dock(FILL)
	fnc:SetConVarA( "minimap_nl_a" )
	fnc:SetConVarR( "minimap_nl_r" )
	fnc:SetConVarG( "minimap_nl_g" )
	fnc:SetConVarB( "minimap_nl_b" )
	fnc:SetColor( Color( GetConVar("minimap_nl_r"):GetInt(), GetConVar("minimap_nl_g"):GetInt(), GetConVar("minimap_nl_b"):GetInt(), GetConVar("minimap_nl_a"):GetInt() ) )
	
	pnl:Help( "Friendly NPC Color" )
	pnl:AddItem( fnc )
	
	local fec = vgui.Create( "DColorMixer" )
	fec:Dock(FILL)
	fec:SetConVarA( "minimap_nh_a" )
	fec:SetConVarR( "minimap_nh_r" )
	fec:SetConVarG( "minimap_nh_g" )
	fec:SetConVarB( "minimap_nh_b" )
	fec:SetColor( Color( GetConVar("minimap_nh_r"):GetInt(), GetConVar("minimap_nh_g"):GetInt(), GetConVar("minimap_nh_b"):GetInt(), GetConVar("minimap_nh_a"):GetInt() ) )
	
	pnl:Help( "Enemy NPC Color" )
	pnl:AddItem( fec )
end

hook.Add( "PopulateToolMenu", "NicksMinimapOptions", function()
	spawnmenu.AddToolMenuOption( "Utilities", "Nicks Minimap", "MinimapOptions", "#Options", "", "", options )
end)