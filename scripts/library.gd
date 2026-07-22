
extends Object

enum theme {GROUND,UNDERGROUND,UNDERWATER,CASTLE}

static func play_audio(caller: Node, res: Resource):
  var audio_stream = AudioStreamPlayer.new()
  audio_stream.stream = res				
  caller.get_tree().root.add_child(audio_stream)
  audio_stream.bus = "SFX"
  audio_stream.play()

static func wait(caller: Node, time:float):
   return caller.get_tree().create_timer(time).timeout

static func get_theme(caller: Node):
  return caller.get_node("/root/LevelBase").loaded_level_theme

static func get_game_manager(caller: Node):
  return caller.get_node("/root/LevelBase")

static func get_level_manager(caller: Node):
  return caller.get_node("/root/LevelBase/Level")
