local ItemPrototypes = {
	Armor = "power-armor-mk2",
	Robot = "construction-robot",
	Fuel = "",
	Reactor = "fission-reactor-equipment",          --4x4
	Exoskeleton = "exoskeleton-equipment",          --2x4
	Shield = "energy-shield-mk2-equipment",         --2x2
	Roboport = "personal-roboport-mk2-equipment",   --2x2
	Battery = "battery-mk2-equipment",              --1x2
	LaserDefense = "personal-laser-defense-equipment", --2x2	
	Nightvision = "night-vision-equipment",         --2x2
}

local Items
local ArmorModules = {
	--Vanilla, 10x10 grid
	{ Name = ItemPrototypes["Reactor"],  Count = 4 },
	{ Name = ItemPrototypes["Roboport"], Count = 4 },
	{ Name = ItemPrototypes["Battery"],  Count = 2 },
	{ Name = ItemPrototypes["Shield"],   Count = 4 },
}

local mbs_Quality = "normal"
if (script.active_mods["quality"]) then
	local quality_setting = settings.global["mbs-quality"].value
end

--Space Age options
if script.active_mods["space-age"] then
	ItemPrototypes["Armor"] = "mech-armor"              --Mech Armor, 10x12 grid
	ItemPrototypes["Reactor"] = "fusion-reactor-equipment" --Fusion Reactor, 4x4			
	ArmorModules = {
		{ Name = ItemPrototypes["Reactor"],      Count = 4 },
		{ Name = ItemPrototypes["Roboport"],     Count = 4 },
		{ Name = ItemPrototypes["Exoskeleton"],  Count = 1 },
		{ Name = ItemPrototypes["Shield"],       Count = (settings.global["shield-start"].value and 4 or 0) },
		{ Name = ItemPrototypes["Nightvision"],  Count = 1 },
		{ Name = ItemPrototypes["Battery"],      Count = 6 },
		{ Name = ItemPrototypes["LaserDefense"], Count = (settings.global["defense-start"].value and 4 or 0) },
		{ Name = ItemPrototypes["Exoskeleton"],  Count = 2 }, --In case the two start options are off, fill in with extra exoskeletons to keep the same power level as the other sets.
	}
end

if script.active_mods["bobwarfare"] then
	ItemPrototypes["Armor"] = "bob-power-armor-mk5" --Bob's Warfare, mk 5, 11x12 grid
end

--Personal Equipment gives upgraded options, lets use a few.
if script.active_mods["bobequipment"] then
	ItemPrototypes["Reactor"] = "bob-fission-reactor-equipment-4"          --Reactor 4 4x4
	ItemPrototypes["Shield"] = "bob-energy-shield-mk6-equipment"           --Shield 6 2x2
	ItemPrototypes["Roboport"] = "bob-personal-roboport-mk4-equipment"     --Roboport 4 2x2
	ItemPrototypes["Battery"] = "bob-battery-mk5-equipment"                --Battery 5 1x2
	ItemPrototypes["LaserDefense"] = "bob-personal-laser-defense-equipment-6" --Laser Defense 6 2x2
	ItemPrototypes["Exoskeleton"] = "bob-exoskeleton-equipment-3"          --Exoskeleton 3 2x4
	ItemPrototypes["Nightvision"] = "bob-night-vision-equipment-3"         --2x2


	ArmorModules = {
		{ Name = ItemPrototypes["Reactor"],      Count = 4 },
		{ Name = ItemPrototypes["Roboport"],     Count = 4 },
		{ Name = ItemPrototypes["Exoskeleton"],  Count = 2 },
		{ Name = ItemPrototypes["Shield"],       Count = (settings.global["shield-start"].value and 3 or 0) },
		{ Name = ItemPrototypes["Battery"],      Count = 4 },
		{ Name = ItemPrototypes["Nightvision"],  Count = 1 },
		{ Name = ItemPrototypes["LaserDefense"], Count = (settings.global["defense-start"].value and 2 or 0) },
		{ Name = ItemPrototypes["Battery"],      Count = 2 },
	}
end

--Logistics gives us upgraded bots
if script.active_mods["boblogistics"] then
	ItemPrototypes["Robot"] = "bob-construction-robot-5"
end

if script.active_mods["Krastorio2"] then
	ItemPrototypes["Armor"] = "kr-power-armor-mk4"             --Mk 4 Power Armor, 12x12 grid
	ItemPrototypes["Reactor"] = "kr-antimatter-reactor-equipment" --Antimatter Reactor, 4x4
	--Reactors require fuel
	ItemPrototypes["Fuel"] = "kr-charged-antimatter-fuel-cell"
	ItemPrototypes["Shield"] = "kr-energy-shield-mk4-equipment"             --Shield 4 2x2
	ItemPrototypes["Battery"] = "kr-battery-mk3-equipment"                  --Battery 3 1x2
	ItemPrototypes["LaserDefense"] = "kr-personal-laser-defense-mk4-equipment" --Laser Defense 4 2x2
	ItemPrototypes["Exoskeleton"] = "kr-superior-exoskeleton-equipment"     --Exoskeleton 3 2x4
	ItemPrototypes["Nightvision"] = "kr-superior-night-vision-equipment"    --1x1


	ArmorModules = {
		{ Name = ItemPrototypes["Reactor"],      Count = 4 },
		{ Name = ItemPrototypes["Roboport"],     Count = 4 },
		{ Name = ItemPrototypes["Shield"],       Count = (settings.global["shield-start"].value and 4 or 0) },
		{ Name = ItemPrototypes["Battery"],      Count = 2 },
		{ Name = ItemPrototypes["Exoskeleton"],  Count = 4 },
		{ Name = ItemPrototypes["Nightvision"],  Count = 1 },
		{ Name = ItemPrototypes["LaserDefense"], Count = (settings.global["defense-start"].value and 2 or 0) },
	}
end

Items = { { ItemPrototypes["Robot"], settings.global["starting-robot-count"].value } }

if not (ItemPrototypes["Fuel"] == "") then
	table.insert(Items, { ItemPrototypes["Fuel"], 80 })
end

--Freeplay
script.on_init(function(event)

if not (settings.global["faster-robots"].value == 0) then
	for k, v in pairs(game.forces) do
		for z = 1, settings.global["faster-robots"].value, 1 do
			v.technologies["worker-robots-speed-" .. tostring(z)].researched = true
		end
	end
end

	storage.GivenArmor = storage.GivenArmor or {}
	if (storage.GivenArmor == nil) then
		storage.GivenArmor = {}
		print("test")
	end
end)

function EquipArmor(event)
	local Player = game.players[event.player_index]
	local ArmorInventory = Player.get_inventory(defines.inventory.character_armor)

	if not (ArmorInventory == nil) then --If the player doesn't have armor inventory, the player hasn't spawned, so we can skip this round.
		if not (Items == nil) then
			for i, v in pairs(Items) do
				Player.insert { name = v[1], count = v[2] }
			end
		end
		if not (ArmorInventory.is_empty()) then
			--We want to remove whatever armor they had to slot in what we want.
			local CurrentArmor = ArmorInventory[1].name
			ArmorInventory.clear()
			--Then for good measure we destroy it from the inventory.
			local PlayerInventory = Player.get_inventory(defines.inventory.character_main)
			PlayerInventory.remove(CurrentArmor);
		end
		local n = 0
		n = ArmorInventory.insert { name = ItemPrototypes["Armor"], count = 1, quality = mbs_Quality }
		if (n > 0) then -- we actually equipped the armor
			local grid = ArmorInventory[1].grid
			for i, module in pairs(ArmorModules) do
				for y = 1, module.Count, 1 do
					grid.put({ name = module.Name, quality = mbs_Quality })
				end
			end
		end

		--Now mark the player as given their tools
		storage.GivenArmor[game.players[event.player_index].name] = true
	end
end

--check the player inside of storage that we gave them armor already
function CheckStorage(event)
	if (storage.GivenArmor[game.players[event.player_index].name] == true) then
		return false --Player was given armor already
	end
	return true
end

--Classic start/no cutscene/multiplayer addition
script.on_event(defines.events.on_player_created, function(event)
	if CheckStorage(event) then
		EquipArmor(event)
	end
end)

--Freeplay/Cutscene start
script.on_event(defines.events.on_cutscene_cancelled, function(event)
	if CheckStorage(event) then
		EquipArmor(event)
	end
end)

--Multiplayer start
script.on_event(defines.events.on_player_joined_game, function(event)
	if CheckStorage(event) then
		EquipArmor(event)
	end
end)
