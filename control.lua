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
		global.AllPlayers[PlayerID].WheelSize = 45
		global.AllPlayers[PlayerID].EmoteDuration = 180
		global.AllPlayers[PlayerID].TextColor = {color="Player Color", index=1}
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
		global.AllPlayers[PlayerID].WheelSize = 45
		global.AllPlayers[PlayerID].EmoteDuration = 180
		global.AllPlayers[PlayerID].TextColor = {color="Player Color", index=1}
	end
end
end)

script.on_event(defines.events.on_player_created,
function(event)
if (global.AllPlayers[event.player_index] == nil) then
	global.AllPlayers[event.player_index] = {}
	global.AllPlayers[event.player_index].ChosenEmotes = {"emote2sprite", "emote4sprite", "emote5sprite", "emote8sprite", "emote11sprite", "emote12sprite", "emote16sprite", "emote19sprite", "emote20sprite"}
	global.AllPlayers[event.player_index].WheelSize = 45
	global.AllPlayers[event.player_index].EmoteDuration = 180
	global.AllPlayers[event.player_index].TextColor = {color="Player Color", index=1}
end
end)


script.on_event("Emote",
function(event) -- has .player_index, .input_name, and .cursor_position
local player = game.players[event.player_index]

if (player.opened_gui_type == defines.gui_type.none and not (player.gui.center["layout"] or player.gui.center["ChooseYourCharacter"])) then
player.gui.center.add{type="table", name="layout", column_count=3}
	player.gui.center.layout.add{type="table", name="words", column_count=1}
		player.gui.center.layout.words.add{type="label", name="LMB", caption = {"EmoteControls.LeftClick"}}
		player.gui.center.layout.words.add{type="label", name="RMB", caption = {"EmoteControls.RightClick"}}
		player.gui.center.layout.words.add{type="label", caption = {"EmoteControls.Size"}}
		player.gui.center.layout.words.add{type="button", name="SizeUp", caption="Larger"}
		player.gui.center.layout.words.add{type="button", name="SizeDown", caption="Smaller"}
		player.gui.center.layout.words.add{type="label", caption = {"EmoteControls.Duration"}, tooltip="99999 max"}
		player.gui.center.layout.words.add{type="textfield", name="EmoteDuration", numeric=true, allow_decimal=true, clear_and_focus_on_right_click=true, lose_focus_on_confirm=true, text=global.AllPlayers[event.player_index].EmoteDuration/60}
	player.gui.center.layout.add{type="table", name="buttons", column_count=3}
		for index, emote in pairs(global.AllPlayers[event.player_index].ChosenEmotes) do
		player.gui.center.layout.buttons.add{type="sprite-button", sprite=emote, name="b"..index, tags={spot = index}, tooltip = {"EmoteNames."..emote}}
		player.gui.center.layout.buttons["b"..index].style.size = global.AllPlayers[event.player_index].WheelSize
		end
	player.gui.center.layout.add{type="table", name="SBSettings", column_count=1}
		player.gui.center.layout.SBSettings.add{type="label", name="RMB", caption = "Speech Bubble Text Color"}
		player.gui.center.layout.SBSettings.add{type="drop-down", name="ColorOptions", items={"Player Color", "Default", "Red", "Orange", "Yellow", "Green", "Blue", "Purple", "Pink", "White", "Gray", "Black", "Brown", "Cyan", "Acid"}, selected_index=global.AllPlayers[event.player_index].TextColor.index}
elseif (player.gui.center["layout"]) then
	player.gui.center.layout.destroy()
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
			animation_offset = 1,
			time_to_live = global.AllPlayers[event.player_index].EmoteDuration}
		global.AllPlayers[event.player_index].EmoteStartTick = game.tick
		player.gui.center.layout.destroy()
	elseif (event.button == defines.mouse_button_type.right) then
		global.AllPlayers[event.player_index].changing = event.element.tags.spot
		player.gui.center.layout.destroy()
		player.gui.center.add{type="table", name="ChooseYourCharacter", column_count=5}
			for i = 2, game.recipe_prototypes["ESB_EmoteCount"].energy do
			player.gui.center.ChooseYourCharacter.add{type="sprite-button", name="c"..i, sprite="emote"..i.."sprite", tooltip = {"EmoteNames.".."emote"..i.."sprite"}}
			player.gui.center.ChooseYourCharacter["c"..i].style.size = global.AllPlayers[event.player_index].WheelSize
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
	player.gui.center.add{type="table", name="layout", column_count=3}
	player.gui.center.layout.add{type="table", name="words", column_count=1}
		player.gui.center.layout.words.add{type="label", name="LMB", caption = {"EmoteControls.LeftClick"}}
		player.gui.center.layout.words.add{type="label", name="RMB", caption = {"EmoteControls.RightClick"}}
		player.gui.center.layout.words.add{type="label", caption = {"EmoteControls.Size"}}
		player.gui.center.layout.words.add{type="button", name="SizeUp", caption="Larger"}
		player.gui.center.layout.words.add{type="button", name="SizeDown", caption="Smaller"}
		player.gui.center.layout.words.add{type="label", caption = {"EmoteControls.Duration"}, tooltip="99999 max"}
		player.gui.center.layout.words.add{type="textfield", name="EmoteDuration", numeric=true, allow_decimal=true, clear_and_focus_on_right_click=true, lose_focus_on_confirm=true, text=global.AllPlayers[event.player_index].EmoteDuration/60}
	player.gui.center.layout.add{type="table", name="buttons", column_count=3}
		for index, emote in pairs(global.AllPlayers[event.player_index].ChosenEmotes) do
		player.gui.center.layout.buttons.add{type="sprite-button", sprite=emote, name="b"..index, tags={spot = index}, tooltip = {"EmoteNames."..emote}}
		player.gui.center.layout.buttons["b"..index].style.size = global.AllPlayers[event.player_index].WheelSize
		end
	player.gui.center.layout.add{type="table", name="SBSettings", column_count=1}
		player.gui.center.layout.SBSettings.add{type="label", name="RMB", caption = "Speech Bubble Text Color"}
		player.gui.center.layout.SBSettings.add{type="drop-down", name="ColorOptions", items={"Player Color", "Default", "Red", "Orange", "Yellow", "Green", "Blue", "Purple", "Pink", "White", "Gray", "Black", "Brown", "Cyan", "Acid"}, selected_index=global.AllPlayers[event.player_index].TextColor.index}
elseif (event.element.name == "SizeUp" and event.element.parent.name == "words") then
	global.AllPlayers[event.player_index].WheelSize = global.AllPlayers[event.player_index].WheelSize+10
	for index, emote in pairs(global.AllPlayers[event.player_index].ChosenEmotes) do
		player.gui.center.layout.buttons["b"..index].style.size = global.AllPlayers[event.player_index].WheelSize
	end

elseif (event.element.name == "SizeDown" and event.element.parent.name == "words" and global.AllPlayers[event.player_index].WheelSize > 10) then
	global.AllPlayers[event.player_index].WheelSize = global.AllPlayers[event.player_index].WheelSize-10
	for index, emote in pairs(global.AllPlayers[event.player_index].ChosenEmotes) do
		player.gui.center.layout.buttons["b"..index].style.size = global.AllPlayers[event.player_index].WheelSize
	end

end

end)


script.on_event(defines.events.on_gui_selection_state_changed,
-- element :: LuaGuiElement: The element whose value changed.
-- player_index :: uint: The player who did the change.
function(event)
local player = game.players[event.player_index]
if (event.element.name == "ColorOptions" and event.element.parent.name == "SBSettings") then
	global.AllPlayers[event.player_index].TextColor = {color=event.element.get_item(event.element.selected_index), index=event.element.selected_index}
end
end)

-- script.on_event(defines.events.on_gui_text_changed,
-- -- element :: LuaGuiElement: The edited element.
-- -- player_index :: uint: The player who did the edit.
-- -- text :: string: The new text in the element.
-- -- name :: defines.events: Identifier of the event
-- -- tick :: uint: Tick the event was generated.
-- function(event)
-- if (event.element.name == "EmoteDuration" and event.element.parent.name == "words") then
-- 	global.AllPlayers[event.player_index].EmoteDuration = event.text*60
-- end
-- end)

script.on_event(defines.events.on_gui_confirmed,
function(event)
if (event.element.name == "EmoteDuration" and event.element.parent.name == "words" and event.element.text ~= "" and event.element.text ~= "0" and tonumber(event.element.text) <= 99999) then
	global.AllPlayers[event.player_index].EmoteDuration = event.element.text*60
	if (global.AllPlayers[event.player_index].emote and rendering.is_valid(global.AllPlayers[event.player_index].emote)) then
		rendering.destroy(global.AllPlayers[event.player_index].emote)
	end
	global.AllPlayers[event.player_index].emote = nil
end
end)

script.on_event(defines.events.on_tick,
function(event)
for the, properties in pairs(global.AllPlayers) do
	if (properties.emote and rendering.is_valid(properties.emote) and game.tick < properties.EmoteStartTick+10) then
		rendering.set_target(properties.emote, game.players[the].character, {0, -0.3-(game.tick-properties.EmoteStartTick)/3})
		rendering.set_x_scale(properties.emote, (game.tick+1-properties.EmoteStartTick)/10)
		rendering.set_y_scale(properties.emote, (game.tick+1-properties.EmoteStartTick)/10)
	elseif (properties.emote and rendering.is_valid(properties.emote) and game.tick > properties.EmoteStartTick+(properties.EmoteDuration-10)) then
		rendering.set_target(properties.emote, game.players[the].character, {0, -3.6333+((game.tick-(properties.EmoteStartTick+(properties.EmoteDuration-10)))/3)})
		rendering.set_x_scale(properties.emote, 1-(game.tick-(properties.EmoteStartTick+(properties.EmoteDuration-10)))/10)
		rendering.set_y_scale(properties.emote, 1-(game.tick-(properties.EmoteStartTick+(properties.EmoteDuration-10)))/10)
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
		local ColorBracket = ""
		if (global.AllPlayers[event.player_index].TextColor.color == "Player Color") then
			ColorBracket = "[color="..player.color.r..","..player.color.g..","..player.color.b.."]"
		else
			ColorBracket = "[color="..string.lower(global.AllPlayers[event.player_index].TextColor.color).."]"
		end
		global.AllPlayers[event.player_index].bubble = player.surface.create_entity
			{
				name = "speech-bubble-no-fade",
				position = player.character.position,
				source = player.character,
				text = ColorBracket..event.message.."[/color]",
				lifetime = 240
			}
	end
end
end)
