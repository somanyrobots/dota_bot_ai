require( GetScriptDirectory().."/mode_defend_ally_generic" );

----------------------------------------------------------------------------------------------------

function OnStart()
	-- print( "mode_defend_ally_shadow_shaman.OnStart" );

	-- Do the standard OnStart
	mode_generic_defend_ally.OnStart();
end

----------------------------------------------------------------------------------------------------

function OnEnd()
	-- print( "mode_defend_ally_shadow_shaman.OnEnd" );
	-- Do the standard OnEnd
	mode_generic_defend_ally.OnEnd();
end

----------------------------------------------------------------------------------------------------

function Think()
	-- print( "mode_defend_ally_shadow_shaman.Think" );

	local npcBot = GetBot();

	-- Do the standard Think
	mode_generic_defend_ally.Think()

	-- Check if we're already using an ability
	if ( npcBot:IsUsingAbility() ) then return end;

	-- If we have a target and can cast Hex on them, do so
	if ( npcBot:GetTarget() ~= nil ) then
		abilityHex = npcBot:GetAbilityByName( "shadow_shaman_voodoo" );
		if ( abilityHex:IsFullyCastable() )
		then
			npcBot:Action_UseAbilityOnLocation( abilityHex, npcBot:GetTarget() );
		end
	end
end

----------------------------------------------------------------------------------------------------

function GetDesire()
	local npcBot = GetBot();
	local fBonus = 0.0;

	-- If we have a target and can cast Hex, our desire to help defend should be higher than normal
	if ( npcBot:GetTarget() ~= nil )
	then
		abilityHex = npcBot:GetAbilityByName( "shadow_shaman_voodoo" );
		if ( abilityHex:IsFullyCastable() )
		then
			fBonus = 0.25;
		end

		abilityShackle = npcBot:GetAbilityByName( "shadow_shaman_shackles" );
		if ( abilityShackle:IsFullyCastable() )
		then
			fBonus = 0.25;
		end
	end

	return Clamp( mode_generic_defend_ally.GetDesire() + fBonus, BOT_MODE_DESIRE_NONE, BOT_MODE_DESIRE_ABSOLUTE );
end

----------------------------------------------------------------------------------------------------
