
AddCSLuaFile()

DEFINE_BASECLASS( "player_default" )

if ( CLIENT ) then

	CreateConVar( "cl_playerskin", "0", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The skin to use, if the model has any" )
	CreateConVar( "cl_playerbodygroups", "0", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The bodygroups to use, if the model has any" )

end

local PLAYER = {}

PLAYER.SlowWalkSpeed		= 75
PLAYER.WalkSpeed 			= 175
PLAYER.RunSpeed			= 300

PLAYER.CrouchedWalkSpeed	= 1		-- Multiply move speed by this when crouching

PLAYER.DuckSpeed			= 0.1		-- How fast to go from not ducking, to ducking
PLAYER.UnDuckSpeed		= 0.1		-- How fast to go from ducking, to not ducking

PLAYER.JumpPower			= 200		-- How powerful our jump should be
PLAYER.CanUseFlashlight		= true		-- Can we use the flashlight
PLAYER.MaxHealth			= 100		-- Max health we can have
PLAYER.MaxArmor			= 100		-- Max armor we can have
PLAYER.StartHealth			= 100		-- How much health we start with
PLAYER.StartArmor			= 100		-- How much armour we start with
PLAYER.DropWeaponOnDie		= false		-- Do we drop our weapon when we die
PLAYER.TeammateNoCollide	= true		-- Do we collide with teammates or run straight through them
PLAYER.AvoidPlayers			= true		-- Automatically swerves around other players
PLAYER.UseVMHands			= true		-- Uses viewmodel hands

PLAYER.TauntCam = TauntCamera()

function PLAYER:SetupDataTables()

	BaseClass.SetupDataTables( self )

end

function PLAYER:SetModel()
	BaseClass.SetModel( self )

	local skin = self.Player:GetInfoNum( "cl_playerskin", 0 )
	self.Player:SetSkin( skin )

	local bodygroups = self.Player:GetInfo( "cl_playerbodygroups" )
	if ( bodygroups == nil ) then bodygroups = "" end

	local groups = string.Explode( " ", bodygroups )
	for k = 0, self.Player:GetNumBodyGroups() - 1 do
		self.Player:SetBodygroup( k, tonumber( groups[ k + 1 ] ) or 0 )
	end
end

function PLAYER:Spawn()
	BaseClass.Spawn( self )
end

function PLAYER:Loadout()

	local GameState = GAMEMODE:GetGameState()

	self.Player:RemoveAllAmmo()

	if GameState > GAMESTATE_BUILD then
		if not hook.Run( "LVS.PlayerLoadoutWeapons", self.Player ) and GetConVar( "lvs_weapons" ):GetBool() then
			self.Player:GiveAmmo( 2, "RPG_Round", true )
			self.Player:GiveAmmo( 24, "GaussEnergy", true )

			self.Player:Give( "weapon_lvslasergun" )
			self.Player:Give( "weapon_lvsantitankgun" )
			self.Player:Give( "weapon_lvslaserrifle" )
			self.Player:Give( "weapon_lvsmines" )
		end
	end

	self.Player:Give( "weapon_lvsspawnpoint" )

	if GameState > GAMESTATE_WAIT_FOR_PLAYERS then
		if not hook.Run( "LVS.PlayerLoadoutTools", self.Player ) then
			if GameState == GAMESTATE_BUILD or GameState == GAMESTATE_DEBUG then
				self.Player:Give( "weapon_lvsfortifications" )
			end

			if GameState >= GAMESTATE_START then
				self.Player:Give( "weapon_lvsvehicles" )
				self.Player:Give( "weapon_lvsweldingtorch" )
			end
		end
	end

	self.Player:SwitchToDefaultWeapon()

end

function PLAYER:ShouldDrawLocal()

	if ( self.TauntCam:ShouldDrawLocalPlayer( self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

end

function PLAYER:CreateMove( cmd )

	if ( self.TauntCam:CreateMove( cmd, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

end

function PLAYER:CalcView( view )

	if ( self.TauntCam:CalcView( view, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

	-- Your stuff here

end

function PLAYER:StartMove( move )
end

function PLAYER:FinishMove( move )
end

player_manager.RegisterClass( "player_lvs", PLAYER, "player_default" )
