util.AddNetworkString( "minimap_check_npc_status_get" )
util.AddNetworkString( "minimap_check_npc_status_send" )

net.Receive( "minimap_check_npc_status_get", function( len, ply )
	local npc = net.ReadEntity()
	
	net.Start("minimap_check_npc_status_send")
		net.WriteEntity( npc )
		net.WriteBool( npc:Disposition(ply) == D_HT )
	net.Send(ply)
end)