include( "nicks_radar_convars.lua" )

local npc_rel = {}

net.Receive( "minimap_check_npc_status_send", function( len )
	npc_rel[net.ReadEntity()] = net.ReadBool()
end)

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

hook.Add( "HUDPaint", "NicksMinimapHud", function()
	--minimap
	surface.SetDrawColor( bck_clr:Unpack() )
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
	local Spos = Vector( Ppos.x, Ppos.y, Ppos.z-10000 )
	local Epos = Vector( Ppos.x, Ppos.y, Ppos.z+10000 )
	
	local m = Matrix()
	m:Translate( center )
	m:Rotate( Angle( 0, LocalPlayer():GetAngles().y-90, 0 ) )
	m:Translate( -center )
	
	local dr = {}
	for k, v in ipairs( ents.FindAlongRay( Spos, Epos, Vector( -1000, -1000, -1000 ), Vector( 1000, 1000, 1000 ) ) ) do
		local rPos = ( ( v:GetPos() - Ppos ) * 0.11 ) * scl
		local x, y = center.x + rPos.x, center.y - rPos.y
		
		if v:IsPlayer() and v ~= LocalPlayer() then
			table.insert( dr, { x = x, y = y, s = v:BoundingRadius()/7*scl, c = plys_clr } )
		elseif v:IsNPC() then
			if npc_rel[v] ~= nil then
				table.insert( dr, { x = x, y = y, s = v:BoundingRadius()/7*scl, c = ( npc_rel[v] and enpc_clr ) or fnpc_clr } )
			else
				net.Start( "minimap_check_npc_status_get" )
					net.WriteEntity( v )
				net.SendToServer()
			end
		end
	end
	
	cam.PushModelMatrix( m )
		for i=1, 3 do
			surface.DrawCircle( center.x, center.y, ScrW()/ScrH()*20*i*scl, line_clr:Unpack() )
		end
			
		for k, v in pairs(dr) do
			surface.SetDrawColor( v.c:Unpack() )	
			surface.DrawRect( v.x-(v.s/2), v.y-(v.s)/2, v.s, v.s )
		end
	cam.PopModelMatrix()
	
	--player
	surface.SetDrawColor( ply_clr:Unpack() )	
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
	
	pnl:Help( "Background Color" )
	pnl:AddItem( bc )
	
	local l = vgui.Create( "DColorMixer" )
	l:Dock(FILL)
	l:SetConVarA( "minimap_l_a" )
	l:SetConVarR( "minimap_l_r" )
	l:SetConVarG( "minimap_l_g" )
	l:SetConVarB( "minimap_l_b" )
	
	pnl:Help( "Line Color" )
	pnl:AddItem( l )
	
	local ply = vgui.Create( "DColorMixer" )
	ply:Dock(FILL)
	ply:SetConVarA( "minimap_lp_a" )
	ply:SetConVarR( "minimap_lp_r" )
	ply:SetConVarG( "minimap_lp_g" )
	ply:SetConVarB( "minimap_lp_b" )
	
	pnl:Help( "Player(you) Color" )
	pnl:AddItem( ply )
	
	local plys = vgui.Create( "DColorMixer" )
	plys:Dock(FILL)
	plys:SetConVarA( "minimap_p_a" )
	plys:SetConVarR( "minimap_p_r" )
	plys:SetConVarG( "minimap_p_g" )
	plys:SetConVarB( "minimap_p_b" )
	
	pnl:Help( "Players(others) Color" )
	pnl:AddItem( plys )
	
	local fnpc = vgui.Create( "DColorMixer" )
	fnpc:Dock(FILL)
	fnpc:SetConVarA( "minimap_nl_a" )
	fnpc:SetConVarR( "minimap_nl_r" )
	fnpc:SetConVarG( "minimap_nl_g" )
	fnpc:SetConVarB( "minimap_nl_b" )
	
	pnl:Help( "Friendly NPC Color" )
	pnl:AddItem( fnpc )
	
	local fepc = vgui.Create( "DColorMixer" )
	fepc:Dock(FILL)
	fepc:SetConVarA( "minimap_nh_a" )
	fepc:SetConVarR( "minimap_nh_r" )
	fepc:SetConVarG( "minimap_nh_g" )
	fepc:SetConVarB( "minimap_nh_b" )
	
	pnl:Help( "Enemy NPC Color" )
	pnl:AddItem( fepc )
end

hook.Add( "PopulateToolMenu", "NicksMinimapOptions", function()
	spawnmenu.AddToolMenuOption( "Utilities", "Nicks Minimap", "MinimapOptions", "#Options", "", "", options )
end)