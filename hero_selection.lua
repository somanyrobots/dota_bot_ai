-- mandate that the bots will pick these heroes - for testing purposes
requiredHeroes = {
};

allBotHeroes = {
		'npc_dota_hero_axe',
		'npc_dota_hero_bane',
		'npc_dota_hero_bloodseeker',
		'npc_dota_hero_bounty_hunter',
		'npc_dota_hero_bristleback',
		'npc_dota_hero_chaos_knight',
		'npc_dota_hero_crystal_maiden',
		'npc_dota_hero_dazzle',
		'npc_dota_hero_death_prophet',
		'npc_dota_hero_dragon_knight',
		'npc_dota_hero_drow_ranger',
		'npc_dota_hero_earthshaker',
		'npc_dota_hero_jakiro',
		'npc_dota_hero_juggernaut',
		'npc_dota_hero_kunkka',
		'npc_dota_hero_lich',
		'npc_dota_hero_lina',
		'npc_dota_hero_lion',
		'npc_dota_hero_luna',
		'npc_dota_hero_necrolyte',
		'npc_dota_hero_nevermore',
		'npc_dota_hero_omniknight',
		'npc_dota_hero_oracle',
		'npc_dota_hero_phantom_assassin',
		'npc_dota_hero_pudge',
		'npc_dota_hero_razor',
		'npc_dota_hero_sand_king',
		'npc_dota_hero_skeleton_king',
		'npc_dota_hero_skywrath_mage',
		'npc_dota_hero_sniper',
		'npc_dota_hero_sven',
		'npc_dota_hero_tidehunter',
		'npc_dota_hero_tiny',
		'npc_dota_hero_vengefulspirit',
		'npc_dota_hero_viper',
		'npc_dota_hero_warlock',
		'npc_dota_hero_windrunner',
		'npc_dota_hero_witch_doctor',
		'npc_dota_hero_zuus'
};

allHeroesByRole = {
  core = {
		'npc_dota_hero_axe',
		'npc_dota_hero_bloodseeker',
		'npc_dota_hero_bristleback',
		'npc_dota_hero_chaos_knight',
		'npc_dota_hero_death_prophet',
		'npc_dota_hero_dragon_knight',
		'npc_dota_hero_drow_ranger',
		'npc_dota_hero_juggernaut',
		'npc_dota_hero_kunkka',
		'npc_dota_hero_luna',
		'npc_dota_hero_necrolyte',
		'npc_dota_hero_nevermore',
		'npc_dota_hero_sand_king',
		'npc_dota_hero_skeleton_king',
		'npc_dota_hero_sniper',
		'npc_dota_hero_sven',
		'npc_dota_hero_tiny',
		'npc_dota_hero_vengefulspirit',
		'npc_dota_hero_windrunner',
		'npc_dota_hero_zuus'
  },
  support = {
		'npc_dota_hero_bane',
		'npc_dota_hero_bounty_hunter',
		'npc_dota_hero_crystal_maiden',
		'npc_dota_hero_dazzle',
		'npc_dota_hero_earthshaker',
		'npc_dota_hero_jakiro',
		'npc_dota_hero_lich',
		'npc_dota_hero_lina',
		'npc_dota_hero_lion',
		'npc_dota_hero_omniknight',
		'npc_dota_hero_oracle',
		'npc_dota_hero_phantom_assassin',
		'npc_dota_hero_pudge',
		'npc_dota_hero_razor',
		'npc_dota_hero_skywrath_mage',
		'npc_dota_hero_tidehunter',
		'npc_dota_hero_vengefulspirit',
		'npc_dota_hero_warlock',
		'npc_dota_hero_witch_doctor',
  }
};

allHeroesWithRoles = {
  npc_dota_hero_axe               = 'core',
  npc_dota_hero_bane              = 'support',
  npc_dota_hero_bloodseeker       = 'core',
  npc_dota_hero_bounty_hunter     = 'support',
  npc_dota_hero_bristleback       = 'core',
  npc_dota_hero_chaos_knight      = 'core',
  npc_dota_hero_crystal_maiden    = 'support',
  npc_dota_hero_dazzle            = 'support',
  npc_dota_hero_death_prophet     = 'core',
  npc_dota_hero_dragon_knight     = 'core',
  npc_dota_hero_drow_ranger       = 'core',
  npc_dota_hero_earthshaker       = 'support',
  npc_dota_hero_jakiro            = 'support',
  npc_dota_hero_juggernaut        = 'core',
  npc_dota_hero_kunkka            = 'core',
  npc_dota_hero_lich              = 'support',
  npc_dota_hero_lina              = 'support',
  npc_dota_hero_lion              = 'support',
  npc_dota_hero_luna              = 'core',
  npc_dota_hero_necrolyte         = 'core',
  npc_dota_hero_nevermore         = 'core',
  npc_dota_hero_omniknight        = 'support',
  npc_dota_hero_oracle            = 'support',
  npc_dota_hero_phantom_assassin  = 'core',
  npc_dota_hero_pudge             = 'core',
  npc_dota_hero_razor             = 'core',
  npc_dota_hero_sand_king         = 'support',
  npc_dota_hero_skeleton_king     = 'core',
  npc_dota_hero_skywrath_mage     = 'support',
  npc_dota_hero_sniper            = 'core',
  npc_dota_hero_sven              = 'core',
  npc_dota_hero_tidehunter        = 'support',
  npc_dota_hero_tiny              = 'core',
  npc_dota_hero_vengefulspirit    = 'support',
  npc_dota_hero_viper             = 'core',
  npc_dota_hero_warlock           = 'support',
  npc_dota_hero_windrunner        = 'core',
  npc_dota_hero_witch_doctor      = 'support',
  npc_dota_hero_zuus              = 'core'
};

picks = {};
allSlots = {};

-- TODO
-- 4. implement various smart picking strategies
function Think()
  local radiantSlots = GetTeamPlayers(TEAM_RADIANT);
  local direSlots = GetTeamPlayers(TEAM_DIRE);
  for k,v in pairs(radiantSlots) do allSlots[v] = v end
  for k,v in pairs(direSlots) do allSlots[v] = v end

  if not ShouldPick() then
    return;
  end

	if ( GetTeam() == TEAM_RADIANT ) then
    slot = radiantSlots[RandomInt(1, #radiantSlots)];

		if (IsPlayerBot(slot) and IsSlotEmpty(slot)) then
			PickHero(slot);
			return;
		end
	elseif ( GetTeam() == TEAM_DIRE ) then
    slot = direSlots[RandomInt(1, #direSlots)];

		if (IsPlayerBot(slot) and IsSlotEmpty(slot)) then
			PickHero(slot);
			return;
		end
	end
end

-- decides if it's a good time to pick
-- if there are no humans in the match, all picks should happen instantly
-- if there are humans, picks should not start right away, and then should occur
--   at regular-but-jittery intervals
function ShouldPick()
  local minimumPickTime = -70; -- no picks should happen earlier than this
  local timePerPick;
  local jitter;

  if (HaveAllHumansPicked(allSlots)) then
    minimumPickTime = -75;
    timePerPick = 0.1;
    jitter = 0;
  else
    timePerPick = ((-minimumPickTime - 5) / 10);
    jitter = RandomFloat(-5,5)
  end

  if (DotaTime() < minimumPickTime) then
    return false;
  end

  picks = GetPicks(allSlots);
  local pickCount = 0;
  for k,v in pairs(picks) do -- have to iterate here, as conditions are not right to use #
    pickCount = pickCount + 1;
  end
  local pickTime = minimumPickTime + (timePerPick * pickCount) + jitter

  if (DotaTime() < pickTime) then
    return false
  end

  return true
end

-- probably you're always passing allSlots to this
function HaveAllHumansPicked(slots)
  for i,slot in pairs(slots) do
    if (not IsPlayerBot(slot) and IsSlotEmpty(slot)) then
      return false
    else
      return true
    end
  end
end

function IsSlotEmpty(slot)
  local slotEmpty = true;
  for pickedSlot, hero in pairs(picks) do
		if (pickedSlot == slot) then
			slotEmpty = false;
		end
  end
  return slotEmpty;
end

function PickHero(slot)
  local nCores = 0;
  local nSupports = 0;
  local slots = (GetTeam() == TEAM_RADIANT) and GetTeamPlayers(TEAM_RADIANT) or GetTeamPlayers(TEAM_DIRE);

  for index,teamSlot in pairs(slots) do
    local hName = GetSelectedHeroName(teamSlot);
		if (hName ~= nil and hName ~= "") then
      local role = allHeroesWithRoles[hName];
      if role == 'core' then
        nCores = nCores + 1
      elseif role == 'support' then
        nSupports = nSupports + 1
      end
    end
  end

  local hero;
  if (nCores >= 3) then
    hero = GetRandomHero('support');
  elseif (nSupports >= 2) then
    hero = GetRandomHero('core');
  else
    hero = GetRandomHero();
  end

  SelectHero(slot, hero);
end

-- haven't found a better way to get already-picked heroes than just looping over all the players
-- takes a list of slots to search over
function GetPicks(slots)
	local selectedHeroes = {};
  for i, slot in pairs(slots) do
		local hName = GetSelectedHeroName(i);
		if (hName ~= nil and hName ~= "") then
			selectedHeroes[slot] = hName;
		end
	end
	return selectedHeroes;
end

-- first, check the list of required heroes and pick from those
-- then try the whole bot pool
function GetRandomHero(role)
	local hero;
	local picks = GetPicks(allSlots);
  local selectedHeroes = {};
  local pickableHeroes;
  role = role or nil;
  for slot, hero in pairs(picks) do
    selectedHeroes[hero] = true;
  end

  if (role == nil) then
    pickableHeroes = allBotHeroes;
  elseif (role == 'core') then
    pickableHeroes = allHeroesByRole['core'];
  elseif (role == 'support') then
    pickableHeroes = allHeroesByRole['support'];
  end

	hero = requiredHeroes[RandomInt(1, #requiredHeroes)];
	if (hero == nil) then
		hero = pickableHeroes[RandomInt(1, #pickableHeroes)];
	end

	while ( selectedHeroes[hero] == true ) do
		hero = pickableHeroes[RandomInt(1, #pickableHeroes)];
	end

	return hero;
end
