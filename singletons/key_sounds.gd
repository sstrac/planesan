extends AudioStreamPlayer

const KEY_DOWN_AUDIO = preload("res://audio/key_press_down.wav")
const KEY_UP_AUDIO = preload("res://audio/key_press_up.wav")

func key_down():
	stream = KEY_DOWN_AUDIO
	play()
	
	
func key_up():
	stream = KEY_UP_AUDIO
	play()
