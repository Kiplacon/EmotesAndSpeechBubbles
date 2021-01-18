-- Setup tables and stuff for new/existing saves ----
script.on_init(
function(event)

if (global.AllPlayers == nil) then
	global.AllPlayers = {}
end

for PlayerID, PlayerLuaData in pairs(game.players) do
	if (global.AllPlayers[PlayerID] == nil) then
		global.AllPlayers[PlayerID] = {}
		global.AllPlayers[PlayerID].ChosenEmotes = {"emote2sprite", "emote4sprite", "emote5sprite", "emote8sprite", "emote11sprite", "emote12sprite", "emote16sprite", "emote19sprite", "emote20sprite"}
	end
end
end)

script.on_configuration_changed(
function(event)
if (global.AllPlayers == nil) then
	global.AllPlayers = {}
end

for PlayerID, PlayerLuaData in pairs(game.players) do
	if (global.AllPlayers[PlayerID] == nil) then
		global.AllPlayers[PlayerID] = {}
		global.AllPlayers[PlayerID].ChosenEmotes = {"emote2sprite", "emote4sprite", "emote5sprite", "emote8sprite", "emote11sprite", "emote12sprite", "emote16sprite", "emote19sprite", "emote20sprite"}
	end
end
end)

script.on_event(defines.events.on_player_created,
function(event)
if (global.AllPlayers[event.player_index] == nil) then
	global.AllPlayers[event.player_index] = {}
	global.AllPlayers[event.player_index].ChosenEmotes = {"emote2sprite", "emote4sprite", "emote5sprite", "emote8sprite", "emote11sprite", "emote12sprite", "emote16sprite", "emote19sprite", "emote20sprite"}
end
end)

local EmoteDuration = 180

script.on_event("Emote",
function(event) -- has .player_index, .input_name, and .cursor_position
local player = game.players[event.player_index]

if (player.opened_gui_type == defines.gui_type.none and not (player.gui.center["layout"] or player.gui.center["ChooseYourCharacter"])) then
player.gui.center.add{type="table", name="layout", column_count=2}
	player.gui.center.layout.add{type="table", name="words", column_count=1}
		player.gui.center.layout.words.add{type="label", caption = {"EmoteControls.LeftClick"}}
		player.gui.center.layout.words.add{type="label", caption = {"EmoteControls.RightClick"}}
	player.gui.center.layout.add{type="table", name="buttons", column_count=3}
		for index, emote in pairs(global.AllPlayers[event.player_index].ChosenEmotes) do
		player.gui.center.layout.buttons.add{type="sprite-button", sprite=emote, tags={spot = index}, tooltip = {"EmoteNames."..emote}}
		end
end

end)

script.on_event(defines.events.on_gui_click,  
--[[
element :: LuaGuiElement: The clicked element.
player_index :: uint: The player who did the clicking.
button :: defines.mouse_button_type: The mouse button used if any.
alt :: boolean: If alt was pressed.
control :: boolean: If control was pressed.
shift :: boolean: If shift was pressed.
]]
function(event)

local player = game.players[event.player_index]

if (player.character and event.element.parent.name == "buttons" and event.element.parent.parent.name == "layout") then
	if (event.button == defines.mouse_button_type.left) then
		if (global.AllPlayers[event.player_index].emote and rendering.is_valid(global.AllPlayers[event.player_index].emote)) then
			rendering.destroy(global.AllPlayers[event.player_index].emote)
		end
		global.AllPlayers[event.player_index].emote = rendering.draw_animation{
			animation = string.gsub(event.element.sprite, "sprite", ""),
			target = player.character,
			target_offset = {0, -3},
			surface = player.surface,
			animation_offset = 5,
			time_to_live = EmoteDuration}
		global.AllPlayers[event.player_index].EmoteStartTick = game.tick
		player.gui.center.layout.destroy()
	elseif (event.button == defines.mouse_button_type.right) then	
		global.AllPlayers[event.player_index].changing = event.element.tags.spot
		player.gui.center.layout.destroy()
		player.gui.center.add{type="table", name="ChooseYourCharacter", column_count=5}
			for i = 2, 21 do
			player.gui.center.ChooseYourCharacter.add{type="sprite-button", sprite="emote"..i.."sprite", tooltip = {"EmoteNames.".."emote"..i.."sprite"}}
			end
	end
	
elseif (player.character and event.element.parent.name == "ChooseYourCharacter" and event.button == defines.mouse_button_type.left) then
	-- for index, emote in pairs(global.AllPlayers[event.player_index].ChosenEmotes) do
		-- if (emote == global.AllPlayers[event.player_index].changing) then
			-- global.AllPlayers[event.player_index].ChosenEmotes[index] = event.element.sprite
		-- end
	-- end
	global.AllPlayers[event.player_index].ChosenEmotes[global.AllPlayers[event.player_index].changing] = event.element.sprite
	player.gui.center.ChooseYourCharacter.destroy()
	player.gui.center.add{type="table", name="layout", column_count=2}
	player.gui.center.layout.add{type="table", name="words", column_count=1}
		player.gui.center.layout.words.add{type="label", caption = {"EmoteControls.LeftClick"}}
		player.gui.center.layout.words.add{type="label", caption = {"EmoteControls.RightClick"}}
	player.gui.center.layout.add{type="table", name="buttons", column_count=3}
		for index, emote in pairs(global.AllPlayers[event.player_index].ChosenEmotes) do
		player.gui.center.layout.buttons.add{type="sprite-button", sprite=emote, tags={spot = index}, tooltip = {"EmoteNames."..emote}}
		end
end

end)


script.on_event(defines.events.on_tick,
function(event)
for the, properties in pairs(global.AllPlayers) do
	if (properties.emote and rendering.is_valid(properties.emote) and game.tick < properties.EmoteStartTick+10) then
		rendering.set_target(properties.emote, game.players[the].character, {0, -0.3-(game.tick-properties.EmoteStartTick)/3})
		rendering.set_x_scale(properties.emote, (game.tick+1-properties.EmoteStartTick)/10)
		rendering.set_y_scale(properties.emote, (game.tick+1-properties.EmoteStartTick)/10)
	elseif (properties.emote and rendering.is_valid(properties.emote) and game.tick > properties.EmoteStartTick+(EmoteDuration-10)) then
		rendering.set_target(properties.emote, game.players[the].character, {0, -3.6333+((game.tick-(properties.EmoteStartTick+(EmoteDuration-10)))/3)})
		rendering.set_x_scale(properties.emote, 1-(game.tick-(properties.EmoteStartTick+(EmoteDuration-10)))/10)
		rendering.set_y_scale(properties.emote, 1-(game.tick-(properties.EmoteStartTick+(EmoteDuration-10)))/10)		
	end
end
end)

script.on_event(defines.events.on_console_chat,
-- player_index :: uint (optional): The player if any.
-- message :: string: The chat message.
function(event)
if (event.player_index) then
	local player = game.players[event.player_index]
	if (player.character) then
		if (global.AllPlayers[event.player_index].bubble and global.AllPlayers[event.player_index].bubble.valid) then
			global.AllPlayers[event.player_index].bubble.destroy()
		end
		global.AllPlayers[event.player_index].bubble = player.surface.create_entity
			{
				name = "speech-bubble-no-fade",
				position = player.character.position,
				source = player.character,
				text = event.message,
				lifetime = 240			
			}
	end
end
end)