mvars = {}

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

center = Vector( GetConVar( "minimap_x_pos" ):GetFloat(), GetConVar( "minimap_y_pos" ):GetFloat() )
scl = GetConVar("minimap_scale"):GetFloat()
bck_clr = Color( GetConVar("minimap_b_r"):GetInt(), GetConVar("minimap_b_g"):GetInt(), GetConVar("minimap_b_b"):GetInt(), GetConVar("minimap_b_a"):GetInt() )
line_clr = Color( GetConVar("minimap_l_r"):GetInt(), GetConVar("minimap_l_g"):GetInt(), GetConVar("minimap_l_b"):GetInt(), GetConVar("minimap_l_a"):GetInt() )
ply_clr = Color( GetConVar("minimap_lp_r"):GetInt(), GetConVar("minimap_lp_g"):GetInt(), GetConVar("minimap_lp_b"):GetInt(), GetConVar("minimap_lp_a"):GetInt() )
plys_clr = Color( GetConVar("minimap_p_r"):GetInt(), GetConVar("minimap_p_g"):GetInt(), GetConVar("minimap_p_b"):GetInt(), GetConVar("minimap_p_a"):GetInt() )
fnpc_clr = Color( GetConVar("minimap_nl_r"):GetInt(), GetConVar("minimap_nl_g"):GetInt(), GetConVar("minimap_nl_b"):GetInt(), GetConVar("minimap_nl_a"):GetInt() )
enpc_clr = Color( GetConVar("minimap_nh_r"):GetInt(), GetConVar("minimap_nh_g"):GetInt(), GetConVar("minimap_nh_b"):GetInt(), GetConVar("minimap_nh_a"):GetInt() )

local chngs = {
	function( new ) center.x = new end,
	function( new ) center.y = new end,
	
	function( new ) scl = new end,
	
	function( new ) bck_clr.r = new end,
	function( new ) bck_clr.g = new end,
	function( new ) bck_clr.b = new end,
	function( new ) bck_clr.a = new end,
	
	function( new ) line_clr.r = new end,
	function( new ) line_clr.g = new end,
	function( new ) line_clr.b = new end,
	function( new ) line_clr.a = new end,
	
	function( new ) ply_clr.r = new end,
	function( new ) ply_clr.g = new end,
	function( new ) ply_clr.b = new end,
	function( new ) ply_clr.a = new end,
	
	function( new ) plys_clr.r = new end,
	function( new ) plys_clr.g = new end,
	function( new ) plys_clr.b = new end,
	function( new ) plys_clr.a = new end,
	
	function( new ) fnpc_clr.r = new end,
	function( new ) fnpc_clr.g = new end,
	function( new ) fnpc_clr.b = new end,
	function( new ) fnpc_clr.a = new end,
	
	function( new ) enpc_clr.r = new end,
	function( new ) enpc_clr.g = new end,
	function( new ) enpc_clr.b = new end,
	function( new ) enpc_clr.a = new end
}

for k, v in ipairs( mvars ) do
	cvars.AddChangeCallback( v:GetName(), function( name, old, new )
		chngs[k]( new )
	end)
end