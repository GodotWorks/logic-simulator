tool
# Manually add enums to match the part name
# Reload this file and ensure that the enum indexes match with the part type property value
extends Control

func _ready():
	tool_stuff()
	enums_to_keys()
	pass


func tool_stuff():
	# Stop autoloaded scene showing up in Tool script mode
	if Engine.is_editor_hint():
		print("Running parts tool script")
		hide()
		print(get_parent().name)
		get_enums()


# part type equates to the enum value
enum TYPES { INPUT = 1, INPUTPIN, INPUTSW, INPUTPUSH, INPUT4, INPUT8, INPUTCLK, NOT, AND, NAND, OR, NOR, XOR, OUTPUT, OUTPUTPIN, OUTPUT1, OUTPUT4, OUTPUT8, INBUS, BUS1, OUTBUS,  MULT, SRFLIPFLOP, DLATCH, DFLIPFLOP, JKFLIPFLOP, ADDER, DECODER, SEG7, REG, COUNTER, LOOPBACK, SHIFTREG, ALU, ROM, BUSMUX, RAM }

var types = {}

func enums_to_keys():
	for key in TYPES.keys():
		types[TYPES[key]] = key


func get_type_name(_enum: int) -> String:
	return types[_enum]


func get_part(part_name: String):
	var part = find_node(part_name).duplicate()
	part.type = TYPES[part.name] # Convert from named type to enum for use in graph
	part.setup()
	return part


func get_enums():
	var e = "enum { "
	var n = 1
	for a in get_children():
		if a is Part:
			e += a.name + ", "
			n += 1
		for b in a.get_children():
			if b is Part:
				print(b.name)
				e += b.name + ", "
				n += 1
			for c in b.get_children():
				if c is Part:
					e += c.name + ", "
					n += 1
	print(e.to_upper())
	print(n)


func int2bin(x: int, nbits: int, prefix = "0b"):
	var b = ""
	for n in nbits:
		if n > 0 and n % 4 == 0:
			b = " " + b
		b = String(x % 2) + b
		x /= 2
	return prefix + b
