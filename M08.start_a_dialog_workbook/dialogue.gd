extends Control

var bodies := {
	"sophia": preload("res://assets/sophia.png"),
	"pink": preload("res://assets/pink.png")
}

var expressions := {
"happy" : preload("res://assets/emotion_happy.png"),
"regular" : preload("res://assets/emotion_regular.png"),
"sad" : preload("res://assets/emotion_sad.png"),
}

@onready var action_buttons: VBoxContainer = %ActionButtons
@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var body: TextureRect = %Body
@onready var texture_rect: TextureRect = %TextureRect

const INDEX_QUIT := -1


var dialogue_items: Array[Dictionary] = [
	{
		"Expression": expressions["regular"],
		"text": "[wave]Hi[/wave]",
		"character": bodies["sophia"],
		"choices": {
			"Who Are You?": 1,
			"What's going on?": 2,
			"quit": -1,
		}
	},
	
	{
		"Expression": expressions["regular"],
		"text": "Its me, your conciousness, and I just woke you up",
		"character": bodies["pink"],
		"choices": {
			"What, Why?": 3,
			"Cool, Im going back to sleep": 2,
			}
	},
		
	{
		"Expression": expressions["sad"],
		"text": "No you're not",
		"character": bodies["sophia"],
		"choices": {
			"Yes I am": 0,
			"Fine, what do you want": 1
			
		}
	},
	
	{
		"Expression": expressions["regular"],
		"text": "Nothing lol I'm just messing with you",
		"character": bodies["pink"],
		"choices": {
			"Are you serious.....": 1,
			"Whatever im going back to sleep": -1,
		}
	},
	
	{
		"Expression": expressions["happy"],
		"text": "OK Goodnight hehe",
		"character": bodies["sophia"],
		"choices": {"...": -1}
	}
		
	
	
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_text(0)
	
	
	
func create_buttons(choices_data: Dictionary):
	for button in action_buttons.get_children():
		button.queue_free()
	for choice_text in choices_data:
		var button := Button.new()
		action_buttons.add_child(button)
		button.text = choice_text
		var target_line_idx: int = choices_data[choice_text]
		if target_line_idx == -1:
			button.pressed.connect(get_tree().quit)
		else: 
			button.pressed.connect(show_text.bind(target_line_idx))
		
	
func show_text(current_item_index: int) -> void:
	var current_item := dialogue_items[current_item_index]
	rich_text_label.text = current_item["text"]
	texture_rect.texture = current_item["Expression"]
	body.texture = current_item["character"]
	create_buttons(current_item["choices"])
	rich_text_label.visible_ratio = 0.0
	var tween := create_tween()
	var text_appearing_duration: float = current_item["text"].length() / 30.0
	tween.tween_property(rich_text_label, "visible_ratio", 1.0, text_appearing_duration)
	var sound_max_length := audio_stream_player.stream.get_length() - text_appearing_duration
	var sound_start_position := randf() * sound_max_length
	audio_stream_player.play(sound_start_position)
	tween.finished.connect(audio_stream_player.stop)
	slide_in()
	for button: Button in action_buttons.get_children():
		button.disabled = true
	tween.finished.connect(func() -> void:
		for button: Button in action_buttons.get_children():
			button.disabled = false)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func slide_in() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	
	body.position.x = 200.0
	tween.tween_property(body, "position:x", 0.0, 0.3)
	
	body.modulate.a = 0.0
	tween.parallel().tween_property(body, "modulate:a", 1.0, 0.2)
	
	
