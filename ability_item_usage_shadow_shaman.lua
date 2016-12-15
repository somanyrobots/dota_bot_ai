

----------------------------------------------------------------------------------------------------

castEtherShockDesire = 0;
castHexDesire = 0;
castShacklesDesire = 0;
castMassSerpentWardsDesire = 0;

function AbilityUsageThink()

	local npcBot = GetBot();

	-- Check if we're already using an ability
	if ( npcBot:IsUsingAbility() ) then return end;

	abilityEtherShock = npcBot:GetAbilityByName( "shadow_shaman_ether_shock" );
	abilityHex = npcBot:GetAbilityByName( "shadow_shaman_voodoo" );
	abilityShackles = npcBot:GetAbilityByName( "shadow_shaman_shackles" );
	abilityMassSerpentWards = npcBot:GetAbilityByName( "shadow_shaman_mass_serpent_ward" );

	-- Consider using each ability
	castEtherShockDesire, castEtherShockTarget = ConsiderEtherShock();
	castHexDesire, castHexTarget = ConsiderHex();
	castShacklesDesire, castShacklesTarget = ConsiderShackles();
	castMassSerpentWardsDesire, castMassSerpentWardsLocation = ConsiderMassSerpentWards();

	if ( castHexDesire > 0 )
	then
		npcBot:Action_UseAbilityOnEntity( abilityHex, castHexLocation );
		return;
	end

	if ( castMassSerpentWardsDesire > 0 )
	then
		npcBot:Action_UseAbilityOnLocation( abilityMassSerpentWards, castMassSerpentWardsLocation );
		return;
	end

	if (castEtherShockDesire > 0 )
	then
		npcBot:Action_UseAbilityOnEntity( abilityEtherShock, castQTarget );
		return;
	end

	if (castShacklesDesire > 0 )
	then
		npcBot:Action_UseAbilityOnEntity( abilityShackles, castETarget );
		return;
	end

end

----------------------------------------------------------------------------------------------------

function CanCastTargetedSpellOnTarget( npcTarget )
	return npcTarget:CanBeSeen() and not npcTarget:IsMagicImmune() and not npcTarget:IsInvulnerable();
end

function CanWardTrapTarget( npcTarget )
	return npcTarget:CanBeSeen() and not npcTarget:IsInvulnerable();
end

----------------------------------------------------------------------------------------------------

-- Ether Shock
function ConsiderEtherShock()

	local npcBot = GetBot();

	-- Make sure it's castable
	if ( not abilityEtherShock:IsFullyCastable() )
	then
		return BOT_ACTION_DESIRE_NONE, 0;
	end;

	-- Get some of its values
	-- TODO: figure out how to get ether shock's cone radius
	-- local nRadius = abilityQ:GetSpecialValueInt( "light_strike_array_aoe" );
	local nCastRange = abilityEtherShock:GetCastRange();
	local nDamage = abilityEtherShock:GetAbilityDamage();

	--------------------------------------
	-- Mode based usage
	--------------------------------------

	-- TODO: Implement function to determine if, by ether shocking a unit within range, we can hit units within the cone distance


	-- TODO: implement
	-- if we're farming, and can hit several units with ether shock
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM ) then
		-- local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), nCastRange, nRadius, 0, nDamage );

		-- if ( locationAoE.count >= 3 ) then
			-- return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
		-- end
	end

	-- If we're pushing or defending a lane and can hit 4+ creeps, go for it
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOTTOM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOTTOM )
	then
		-- TODO: Implement
		-- local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), nCastRange, nRadius, 0, 0 );

		-- if ( locationAoE.count >= 4 )
		-- then
			-- return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc;
		-- end
	end

	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_GANK or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY )
	then
		local npcTarget = npcBot:GetTarget();

		if ( npcTarget ~= nil )
		then
			if ( CanCastTargetedSpellOnTarget( npcTarget ) )
			then
				return BOT_ACTION_DESIRE_HIGH, npcTarget:GetLocation();
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
end

----------------------------------------------------------------------------------------------------

function ConsiderHex()

	local npcBot = GetBot();

	-- Make sure it's castable
	if ( not abilityHex:IsFullyCastable() ) then
		return BOT_ACTION_DESIRE_NONE, 0;
	end;

	-- Get some of its values
	local nCastRange = abilityDS:GetCastRange();

	--------------------------------------
	-- Mode based usage
	--------------------------------------

	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_GANK or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY )
	then
		local npcTarget = npcBot:GetTarget();

		if ( npcTarget ~= nil )
		then
			if ( CanCastTargetedSpellOnTarget( npcTarget ) )
			then
				return BOT_ACTION_DESIRE_MODERATE, npcEnemy:GetLocation();
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;

end


----------------------------------------------------------------------------------------------------

function ConsiderShackles()

	local npcBot = GetBot();

	-- Make sure it's castable
	if ( not abilityShackles:IsFullyCastable() ) then
		return BOT_ACTION_DESIRE_NONE, 0;
	end

	-- Get some of its values
	local nCastRange = abilityMassSerpentWards:GetCastRange();

	-- If we're in a teamfight, use it on the scariest enemy
	-- TODO: add an exception to avoid ward-trapping heroes who can get out
	local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes( 1000, false, BOT_MODE_ATTACK );
	if ( #tableNearbyAttackingAlliedHeroes >= 4 )
	then

		local npcMostDangerousEnemy = nil;
		local nMostDangerousDamage = 0;

		local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( nCastRange, true, BOT_MODE_NONE );
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( CanWardTrapTarget( npcEnemy ) )
			then
				local nDamage = npcEnemy:GetEstimatedDamageToTarget( false, npcBot, 3.0, DAMAGE_TYPE_ALL );
				if ( nDamage > nMostDangerousDamage )
				then
					nMostDangerousDamage = nDamage;
					npcMostDangerousEnemy = npcEnemy;
				end
			end
		end

		if ( npcMostDangerousEnemy ~= nil )
		then
			return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy:GetLocation();
		end
	end

	-- If we're pushing a tower, drop wards near the tower
	-- TODO: implement
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOTTOM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOTTOM )
	then
		-- TODO: figure out method signature for GetNearbyTowers()
		-- local tableNearbyTowers = npcBot:GetNearbyTowers( nCastRange, true );
		-- TODO: Implement
		-- local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), nCastRange, nRadius, 0, 0 );
	end

	-- If we're taking Roshan, drop wards in the Rosh pit
	-- TODO: Implement

	return BOT_ACTION_DESIRE_NONE, 0;

end

function ConsiderMassSerpentWards()
  return BOT_ACTION_DESIRE_NONE, 0;
end
