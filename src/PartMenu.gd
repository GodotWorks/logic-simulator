extends VBoxContainer

signal part_selected(idx, group, button)

var selected_item = 0

func _ready():
	var vspacer = Control.new()
	vspacer.size_flags_vertical = SIZE_EXPAND_FILL
	for parts in Parts.get_children():
		var toolbar = HBoxContainer.new()
		toolbar.set("custom_constants/separation", 0)
		for p in parts.get_children():
			var b = ToolButton.new()
			b.focus_mode = Control.FOCUS_NONE
			b.hint_tooltip = p.title
			for child in p.get_children():
				if child is Sprite or child is TextureRect:
					b.icon = child.texture
					if p.locked and not User.data.unlocked.has(p.type):
						b.modulate = Color.red
					break
			b.connect("button_down", self, "emit_signal", ["part_selected", p.name, b])
			toolbar.add_child(b)
		var vb = VBoxContainer.new()
		vb.add_child(vspacer.duplicate())
		vb.add_child(toolbar)
		vb.add_child(vspacer.duplicate())
		vb.size_flags_vertical = SIZE_EXPAND_FILL
		vb.size_flags_horizontal = SIZE_EXPAND_FILL
		add_child(vb)
	set_visibility()
	emit_signal("part_selected") # To avoid a warning message about not being emitted


func select_menu(n):
	selected_item = wrapi(selected_item + n, 0, get_child_count() - 1)
	set_visibility()


func set_visibility():
	for i in get_child_count():
		get_child(i).visible = i == selected_item
