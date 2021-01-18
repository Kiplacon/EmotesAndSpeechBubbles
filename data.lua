local emotes = {
{
	type = "animation",
	name = "emote2",
	filename = "__EmotesAndSpeechBubbles__/graphics/smile.png",
	size = 200,
	frame_count = 10,
	line_length = 5,
	animation_speed = 0.5,
	scale = 0.5
},
{
	type = "animation",
	name = "emote3",
	filename = "__EmotesAndSpeechBubbles__/graphics/AAHHH.png",
	size = 200,
	frame_count = 10,
	line_length = 5,
	animation_speed = 0.5,
	scale = 0.5
},
{
	type = "animation",
	name = "emote4",
	filename = "__EmotesAndSpeechBubbles__/graphics/colonP.png",
	size = 200,
	frame_count = 10,
	line_length = 5,
	animation_speed = 0.5,
	scale = 0.5
},
{
	type = "animation",
	name = "emote5",
	filename = "__EmotesAndSpeechBubbles__/graphics/want.png",
	size = 200,
	frame_count = 10,
	line_length = 5,
	animation_speed = 0.5,
	scale = 0.5
},
{
	type = "animation",
	name = "emote6",
	filename = "__EmotesAndSpeechBubbles__/graphics/glare.png",
	size = 200,
	frame_count = 10,
	line_length = 5,
	animation_speed = 0.5,
	scale = 0.5
},
{
	type = "animation",
	name = "emote7",
	filename = "__EmotesAndSpeechBubbles__/graphics/hmm.png",
	size = 64,
	frame_count = 60,
	line_length = 5,
	animation_speed = 0.5
},
{
	type = "animation",
	name = "emote8",
	filename = "__EmotesAndSpeechBubbles__/graphics/hmmspin.png",
	size = 64,
	frame_count = 30,
	line_length = 5,
	animation_speed = 0.75
},
{
	type = "animation",
	name = "emote9",
	filename = "__EmotesAndSpeechBubbles__/graphics/PointRight.png",
	size = 64,
	frame_count = 38,
	line_length = 2,
	animation_speed = 0.5
},
{
	type = "animation",
	name = "emote10",
	filename = "__EmotesAndSpeechBubbles__/graphics/PointLeft.png",
	size = 64,
	frame_count = 38,
	line_length = 2,
	animation_speed = 0.5
},
{
	type = "animation",
	name = "emote11",
	filename = "__EmotesAndSpeechBubbles__/graphics/OkHand.png",
	size = 64,
	frame_count = 60,
	line_length = 5,
	animation_speed = 0.5,
},
{
	type = "animation",
	name = "emote12",
	filename = "__EmotesAndSpeechBubbles__/graphics/clap.png",
	size = 64,
	frame_count = 24,
	line_length = 4,
	animation_speed = 0.5
},
{
	type = "animation",
	name = "emote13",
	filename = "__EmotesAndSpeechBubbles__/graphics/laugh.png",
	size = 64,
	frame_count = 24,
	line_length = 4,
	animation_speed = 0.5
},
{
	type = "animation",
	name = "emote14",
	filename = "__EmotesAndSpeechBubbles__/graphics/angry.png",
	size = 64,
	frame_count = 24,
	line_length = 4,
	animation_speed = 0.5
},
{
	type = "animation",
	name = "emote15",
	filename = "__EmotesAndSpeechBubbles__/graphics/VibeCat.png",
	size = 64,
	frame_count = 159,
	line_length = 3,
	animation_speed = 0.4
},
{
	type = "animation",
	name = "emote16",
	filename = "__EmotesAndSpeechBubbles__/graphics/partyblob.png",
	size = 64,
	frame_count = 10,
	line_length = 5,
	animation_speed = 0.5
},
{
	type = "animation",
	name = "emote17",
	filename = "__EmotesAndSpeechBubbles__/graphics/partyparrot.png",
	size = {64,46},
	frame_count = 10,
	line_length = 5,
	animation_speed = 0.5
},
{
	type = "animation",
	name = "emote18",
	filename = "__EmotesAndSpeechBubbles__/graphics/hug.png",
	size = 64,
	frame_count = 76,
	line_length = 4,
	animation_speed = 0.5
},
{
	type = "animation",
	name = "emote19",
	filename = "__EmotesAndSpeechBubbles__/graphics/bigbrain.png",
	size = 58,
	frame_count = 19,
	line_length = 1,
	scale = 1.25,
	animation_speed = 0.5
},
{
	type = "animation",
	name = "emote20",
	filename = "__EmotesAndSpeechBubbles__/graphics/F.png",
	size = 112,
	frame_count = 8,
	line_length = 4,
	scale = 0.5,
	animation_speed = 0.5
},
{
	type = "animation",
	name = "emote21",
	filename = "__EmotesAndSpeechBubbles__/graphics/smokeweedeveryday/rekt/rekt.png",
	size = 64,
	frame_count = 50,
	line_length = 5,
	animation_speed = 0.5,
	scale = 1.5
}}

for each, emote in pairs(emotes) do
data:extend({
	emote,
	{
		type = "sprite",
		name = emote.name.."sprite",
		filename = emote.filename,
		priority = "extra-high",
		size = emote.size
	}
})
end

data:extend({
  {
    type = "custom-input",
    name = "Emote",
    key_sequence = "mouse-button-3"
  },
  {
    type = "speech-bubble",
    name = "speech-bubble-no-fade",
    style = "compilatron_speech_bubble",
    wrapper_flow_style = "compilatron_speech_bubble_wrapper",
    fade_in_out_ticks = 5,
    flags = {"not-on-map", "placeable-off-grid"}
  }
})