extends Part

class_name DffComb

func update_output(_level: bool, _port: int, _r: bool):
	# Init output
	if output_pins[0].count == 0:
		set_output(false, 0)
		output_pins[0].count = 1
	if input_pins[0].level: # Set
		set_output(true, 0)
	else:
		if input_pins[3].level: # Reset
			set_output(false, 0)
		else:
			# Detect rising edge of CK
			if input_pins[2].level and not input_pins[2].last_level:
				set_output(input_pins[1].level, 0)
				print("set")
			input_pins[2].last_level = input_pins[2].level
