

----------------------------------------------------------------------------------------------------

castEtherShockDesire = 0;
castHexDesire = 0;
castShacklesDesire = 0;
castMassSerpentWardsDesire = 0;

function AbilityUsageThink()
  -- print("shadow shaman AbilityUsageThink");

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
		npcBot:Action_UseAbilityOnEntity( abilityHex, castHexTarget );
		return;
	end

	if ( castMassSerpentWardsDesire > 0 )
	then
		npcBot:Action_UseAbilityOnLocation( abilityMassSerpentWards, castMassSerpentWardsLocation );
		return;
	end

	if (castEtherShockDesire > 0 )
	then
		npcBot:Action_UseAbilityOnEntity( abilityEtherShock, castEtherShockTarget );
		return;
	end

	if (castShacklesDesire > 0 )
	then
		npcBot:Action_UseAbilityOnEntity( abilityShackles, castShacklesTarget );
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

  -- print("shadow shaman ConsiderEtherShock");

	-- Get some of its values
	-- TODO: figure out how to get ether shock's cone radius
	local nCastRange = abilityEtherShock:GetCastRange();
	local nDamage = abilityEtherShock:GetAbilityDamage();
  local nStartRadius = abilityEtherShock:GetSpecialValueInt("start_radius");
  local nEndRadius = abilityEtherShock:GetSpecialValueInt("end_radius");
  local nEndDistance = abilityEtherShock:GetSpecialValueInt("end_distance");
  local nTargets = abilityEtherShock:GetSpecialValueInt("targets");

	--------------------------------------
	-- Mode based usage
	--------------------------------------

	-- TODO: Implement function to determine if, by ether shocking a unit within range, we can hit units within the cone


	-- TODO: implement
	-- if we're farming, and can hit several units with ether shock
	if ( npcBot:GetActiveMode() == BOT_MODE_FARM ) then
    -- local creeps = npcBot:GetNearbyCreeps();
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
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
     npcBot:GetActiveMode() == BOT_MODE_ATTACK )
	then
		local npcTarget = npcBot:GetTarget();

		if ( npcTarget ~= nil )
		then
			if ( CanCastTargetedSpellOnTarget( npcTarget ) )
			then
				return BOT_ACTION_DESIRE_VERYHIGH, npcTarget;
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

  -- print("shadow shaman ConsiderHex");

	-- Get some of its values
	local nCastRange = abilityHex:GetCastRange();

  --------------------------------------
  -- Global high-priorty usage
  --------------------------------------

  -- Check for a channeling enemy
  local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( nCastRange + 400, true, BOT_MODE_NONE );
  for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
  do
  	if ( npcEnemy:IsChanneling() )
  	then
  		return BOT_ACTION_DESIRE_HIGH, npcEnemy;
  	end
  end

	--------------------------------------
	-- Mode based usage
	--------------------------------------

  -- If we're seriously retreating, see if we can land a stun on someone who's damaged us recently
	if ( npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH )
	then
		local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( nCastRange + 400, true, BOT_MODE_NONE );
		for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
		do
			if ( npcBot:WasRecentlyDamagedByHero( npcEnemy, 2.0 ) )
			then
				if ( CanCastTargetedSpellOnTarget( npcEnemy ) )
				then
					return BOT_ACTION_DESIRE_MODERATE, npcEnemy;
				end
			end
		end
	end

	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_GANK or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
     npcBot:GetActiveMode() == BOT_MODE_ATTACK )
	then
		local npcTarget = npcBot:GetTarget();

		if ( npcTarget ~= nil )
		then
			if ( CanCastTargetedSpellOnTarget( npcTarget ) )
			then
				return BOT_ACTION_DESIRE_VERYHIGH, npcTarget;
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

  -- print("shadow shaman ConsiderShackles");

	-- Get some of its values
	-- local nCastPoint = abilityShackles:GetCastPoint();
	local nCastRange = abilityShackles:GetCastRange();
	local nTotalDamage = abilityShackles:GetSpecialValueFloat('total_damage');

  --------------------------------------
  -- Global high-priorty usage
  --------------------------------------

	-- Check for a channeling enemy
	local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( nCastRange + 300, true, BOT_MODE_NONE );
	for _,npcEnemy in pairs( tableNearbyEnemyHeroes )
	do
		if ( npcEnemy:IsChanneling() )
		then
			return BOT_ACTION_DESIRE_HIGH, npcEnemy;
		end
	end

	--------------------------------------
	-- Mode based usage
	--------------------------------------

	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_GANK or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
     npcBot:GetActiveMode() == BOT_MODE_ATTACK )
	then
		local npcTarget = npcBot:GetTarget();

		if ( npcTarget ~= nil )
		then
			if ( CanCastTargetedSpellOnTarget( npcTarget ) )
			then
				return BOT_ACTION_DESIRE_VERYHIGH, npcTarget;
			end
		end
	end

	return BOT_ACTION_DESIRE_NONE, 0;
end

function ConsiderMassSerpentWards()
	local npcBot = GetBot();
	local nCastRange = abilityMassSerpentWards:GetCastRange();
  local wardRange = 600; -- hardcoded for now, because it's not saved as an ability property

	-- Make sure it's castable
	if ( not abilityShackles:IsFullyCastable() ) then
		return BOT_ACTION_DESIRE_NONE, 0;
	end

	-- If we're in a teamfight, use it on the scariest enemy
	-- TODO: add an exception to avoid ward-trapping heroes who can get out
	-- If we're in a teamfight, use it on the scariest enemy
	local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes( 1000, false, BOT_MODE_ATTACK );
	if ( #tableNearbyAttackingAlliedHeroes >= 0 )
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
	if ( npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOTTOM or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOTTOM )
	then
		-- TODO: figure out method signature for GetNearbyTowers()
		-- local tableNearbyTowers = npcBot:GetNearbyTowers( nCastRange + 400, true );
		-- TODO: Implement
		-- local locationAoE = npcBot:FindAoELocation( true, false, npcBot:GetLocation(), nCastRange, nRadius, 0, 0 );
	end

  	-- If we're going after someone
	if ( npcBot:GetActiveMode() == BOT_MODE_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or
		 npcBot:GetActiveMode() == BOT_MODE_GANK or
		 npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or
     npcBot:GetActiveMode() == BOT_MODE_ATTACK )
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

	-- If we're taking Roshan, drop wards in the Rosh pit
	-- TODO: Implement


  -- print("shadow shaman ConsiderMassSerpentWards");

  return BOT_ACTION_DESIRE_NONE, 0;
end
