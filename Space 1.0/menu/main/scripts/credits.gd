extends Control

@onready var video_credits = $VideoStreamPlayer
@onready var sound_credits = $sound_credits

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	video_credits.play()
	sound_credits.play()
	



func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/main/index.tscn")
