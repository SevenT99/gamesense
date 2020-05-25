-- ~~ created by SevenT ~~
-- require https://gamesense.pub/forums/viewtopic.php?id=18807

local csgo_weapons = require "gamesense/csgo_weapons"
local qkscope = ui.new_checkbox("misc", "miscellaneous", "Quick Switch")
local qkscopekey = ui.new_hotkey("misc", "miscellaneous", "Quick Switch Hotkey")
local quickswitch = ui.new_multiselect("misc", "miscellaneous", "Quick Switch", "AWP", "Scout", "Deagle")
local select = {"AWP", "Scout", "Deagle"}
local quickswitchdelayawp = ui.new_slider("misc", "miscellaneous", "Quick Switch Delay AWP",1,200)
local quickswitchdelayssg = ui.new_slider("misc", "miscellaneous", "Quick Switch Delay SSG 08",1,200)
local quickswitchdelaydeagle = ui.new_slider("misc", "miscellaneous", "Quick Switch Delay Deagle",1,200)
ui.set_visible(quickswitchdelayawp,false)
ui.set_visible(quickswitchdelayssg,false)
ui.set_visible(quickswitchdelaydeagle,false)
ui.set_visible(quickswitch,false)
ui.set_visible(qkscopekey,false)

local function contains(table, val)

  for i = 1, #table do

    if table[i] == val then

      return true

    end

  end

  return false

end

client.set_event_callback("setup_command", function()
local selection = ui.get(quickswitch)
	if ui.get(qkscope) then
		ui.set_visible(quickswitch,true)
		ui.set_visible(qkscopekey,true)
	else
		ui.set_visible(quickswitch,false)
		ui.set_visible(qkscopekey,false)
	end
	
	if contains(selection, select[1]) and ui.get(qkscope, true) then
		ui.set_visible(quickswitchdelayawp,true)
	else
		ui.set_visible(quickswitchdelayawp,false)
	end
	
	if contains(selection, select[2]) and ui.get(qkscope, true) then
		ui.set_visible(quickswitchdelayssg,true)
	else
		ui.set_visible(quickswitchdelayssg,false)
	end
	
	if contains(selection, select[3]) and ui.get(qkscope, true) then
		ui.set_visible(quickswitchdelaydeagle,true)
	else
		ui.set_visible(quickswitchdelaydeagle,false)
	end
end)

client.set_event_callback("paint", function()
	local selection = ui.get(quickswitch)
	local local_player = entity.get_local_player()
	if local_player == nil then return end

	local weapon_ent = entity.get_player_weapon(local_player)
	if weapon_ent == nil then return end

	local weapon_idx = entity.get_prop(weapon_ent, "m_iItemDefinitionIndex")
	if weapon_idx == nil then return end
	weapon_idx = bit.band(weapon_idx, 0xFFFF)
	
	local weapon = csgo_weapons[weapon_idx]
	if weapon == nil then return end
	
	if ui.get(qkscopekey, true) and ui.get(qkscope) and weapon.name == "AWP" then
		if contains(selection, select[1]) then
			renderer.indicator(255, 0, 0, 255, "Switch AWP")
		end
	elseif ui.get(qkscopekey, true) and ui.get(qkscope) and  weapon.name == "SSG 08" then
		if contains(selection, select[2]) then
			renderer.indicator(255, 0, 0, 255, "Switch SSG 08")
		end
	elseif ui.get(qkscopekey, true) and ui.get(qkscope) and weapon.name == "Desert Eagle" then
		if contains(selection, select[3]) then
			renderer.indicator(255, 0, 0, 255, "Switch Deagle")
		end
	end
end)

client.set_event_callback("weapon_fire", function(e)
    local local_player = entity.get_local_player()
	local local_userid = e.userid
	local local_entindex = client.userid_to_entindex(local_userid)
	
	if local_userid == nil then
        return
    end
	
    if local_player == nil then return end

    local weapon_ent = entity.get_player_weapon(local_player)
    if weapon_ent == nil then return end

    local weapon_idx = entity.get_prop(weapon_ent, "m_iItemDefinitionIndex")
    if weapon_idx == nil then return end
    weapon_idx = bit.band(weapon_idx, 0xFFFF)

    local weapon = csgo_weapons[weapon_idx]
    if weapon == nil then return end
	
	local selection = ui.get(quickswitch)
	local delayawp = ui.get(quickswitchdelayawp)
	local delayssg = ui.get(quickswitchdelayssg)
	local delaydeagle = ui.get(quickswitchdelaydeagle)
	
	
	if weapon.name == "AWP" and  local_entindex == local_player and ui.get(qkscope, true) and ui.get(qkscopekey) then
		if contains(selection, select[1]) then
			client.delay_call( delayawp / 1000, client.exec, "use weapon_knife")
			client.delay_call( delayawp / 1000 * 2, client.exec, "use weapon_awp")
		end
	end
	
	if weapon.name == "SSG 08" and local_entindex == local_player and ui.get(qkscope, true) and ui.get(qkscopekey) then
		if contains(selection, select[2]) then
			client.delay_call( delayssg / 1000, client.exec, "use weapon_knife")
			client.delay_call( delayssg / 1000 * 2, client.exec, "use weapon_SSG08")
		end
	end
	
	if weapon.name == "Desert Eagle" and local_entindex == local_player and ui.get(qkscope, true) and ui.get(qkscopekey) then
		if contains(selection, select[3]) then
			client.delay_call( delaydeagle / 1000, client.exec, "use weapon_knife")
			client.delay_call( delaydeagle / 1000 * 2, client.exec, "use weapon_deagle")
		end
	end
end
)
