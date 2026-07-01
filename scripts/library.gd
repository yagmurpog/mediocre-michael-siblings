
extends Object

static func play_audio(caller: Node, res: Resource):
  var audio_stream = AudioStreamPlayer.new()
  audio_stream.stream = res				
  caller.get_tree().root.add_child(audio_stream)
  audio_stream.bus = "SFX"
  audio_stream.play()

static func wait(caller: Node, time:float):
   return caller.get_tree().create_timer(time).timeout