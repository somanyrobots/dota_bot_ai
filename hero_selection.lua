-- mandate that the bots will pick these heroes - for testing purposes
requiredHeroes = {
};

-- change quickMode to true for testing
-- quickMode eliminates the 30s delay before picks begin
-- it also eliminates the delay between bot picks
quickMode = false;

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

picks = {};
allSlots = {};

-- TODO
-- 1. determine which slots contain players - don't pick for those slots
-- 2. determine which slots are assigned to which teams - enables strategy
-- 3. add some jitter, so the bots pick at slightly more random times
-- 4. implement various smart picking strategies
-- 5. activate quick mode once all humans have picked
function Think()
  local startPickTime = -70;
  local timePerPick = 1;
  local radiantSlots = GetTeamPlayers(TEAM_RADIANT);
  local direSlots = GetTeamPlayers(TEAM_DIRE);
  for k,v in pairs(radiantSlots) do allSlots[v] = v end
  for k,v in pairs(direSlots) do allSlots[v] = v end

  if not quickMode and (DotaTime() < startPickTime) then
    return;
  end

  picks = GetPicks(allSlots);
  local pickCount = 0;
  for k,v in pairs(picks) do -- have to iterate here, as conditions are not right to use #
    pickCount = pickCount + 1;
  end
  local pickTime = startPickTime + (timePerPick * pickCount);

  if not quickMode and  (DotaTime() < pickTime) then
    return;
  end

	if ( GetTeam() == TEAM_RADIANT and IsTeamsTurnToPick(TEAM_RADIANT)) then
		for i, potentialSlot in pairs(radiantSlots) do
			if (IsPlayerBot(potentialSlot) and IsSlotEmpty(potentialSlot)) then
				PickHero(potentialSlot);
  			return;
			end
		end
	elseif ( GetTeam() == TEAM_DIRE and IsTeamsTurnToPick(TEAM_DIRE)) then
		for i, potentialSlot in pairs(direSlots) do
			if (IsPlayerBot(potentialSlot) and IsSlotEmpty(potentialSlot)) then
				PickHero(potentialSlot);
  			return;
			end
		end
	end
end

function printSlots(slots)
  print("slots are");
  for k,v in pairs(slots) do
    print(k,v);
  end
end

function IsTeamsTurnToPick(team)
  local radiantHeroCount = 0;
  local direHeroCount = 0;
  for pickedSlot, hero in pairs(picks) do
    if slotBelongsToTeam(pickedSlot, TEAM_RADIANT) then
      radiantHeroCount = radiantHeroCount + 1;
    else
      direHeroCount = direHeroCount + 1;
    end
  end
  if (team == TEAM_RADIANT) then
    return (radiantHeroCount <= direHeroCount);
  else
    return (direHeroCount <= radiantHeroCount);
  end
end

function slotBelongsToTeam(slot, team)
  for i in pairs(GetTeamPlayers(team)) do
    return true if i == slot;
  end
  return false;
end

function IsSlotEmpty(slot)
  local slotEmpty = true;
  for pickedSlot, hero in pairs(picks) do
    -- print("pickedSlot is", pickedSlot);
    -- print("hero is", hero);
		if (pickedSlot == slot) then
			slotEmpty = false;
		end
  end
  -- print("slotempty is ", slotEmpty);
  return slotEmpty;
end

function PickHero(slot)
  local hero = GetRandomHero();
  -- print("picking hero ", hero, " for slot ", slot);
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
function GetRandomHero()
	local hero;
	local picks = GetPicks(allSlots);
  local selectedHeroes = {};
  for slot, hero in pairs(picks) do
    selectedHeroes[hero] = true;
  end

	hero = requiredHeroes[RandomInt(1, #requiredHeroes)];
	if (hero == nil) then
		hero = allBotHeroes[RandomInt(1, #allBotHeroes)];
	end

	while ( selectedHeroes[hero] == true ) do
		-- print("repicking because " .. hero .. " was taken.")
		hero = allBotHeroes[RandomInt(1, #allBotHeroes)];
	end

	return hero;
end
