@icon("res://assets/dialogue_item_icon.svg")
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

@onready var action_buttons: VBoxContainer = $VBoxContainer/ActionButtons
@onready var rich_text_label: RichTextLabel = $VBoxContainer/RichTextLabel
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var body: TextureRect = %Body
@onready var expression: TextureRect = %Expression


const INDEX_QUIT := -1

@export var dialogue_items: Array[DialogueItem] = []:
  set = set_dialogue_items

	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	show_text(0)
	
	
func create_buttons(buttons_data: Array[DialogueChoice]):
	for button in action_buttons.get_children():
		button.queue_free()
	for choice in buttons_data:
		var button := Button.new()
		action_buttons.add_child(button)
		button.text = choice.text
		if choice.is_quit == true:
			button.pressed.connect(get_tree().quit)
		else:
			var target_line_id := choice.target_line_idx
			button.pressed.connect(show_text.bind(target_line_id))
			
			
		
		
	
func show_text(current_item_index: int) -> void:
	var current_item := dialogue_items[current_item_index]
	rich_text_label.text = current_item.text
	expression.texture = current_item.expression
	body.texture = current_item.character
	create_buttons(current_item.choices)
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
	
	
func set_dialogue_items(new_dialogue_items: Array[DialogueItem]) -> void:
	for index in new_dialogue_items.size():
		if new_dialogue_items[index] == null:
			new_dialogue_items[index] = DialogueItem.new()
	dialogue_items = new_dialogue_items
