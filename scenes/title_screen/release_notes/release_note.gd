extends Resource
class_name ReleaseNote

const LABEL_SETTINGS_TITLE := preload("res://scenes/title_screen/release_notes/releases_title_settings.tres")
const LABEL_SETTINGS_ENTRY := preload("res://scenes/title_screen/release_notes/releases_entry_settings.tres")

@export var release_version: String
@export_multiline var notes: String

func make_label_for_note(note: String) -> RichTextLabel:
	var new_label := RichTextLabel.new()
	new_label.bbcode_enabled = true
	new_label.scroll_active = false
	if note.contains("[TITLE]"):
		note = note.replace("[TITLE]", "")
		new_label.add_theme_font_override('normal_font', LABEL_SETTINGS_TITLE.font)
		new_label.add_theme_font_size_override('normal_font_size', LABEL_SETTINGS_TITLE.font_size)
		new_label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
		new_label.custom_minimum_size.y = 48
		note = "  " + note
	else:
		new_label.add_theme_font_override('normal_font', LABEL_SETTINGS_ENTRY.font)
		new_label.add_theme_font_size_override('normal_font_size', LABEL_SETTINGS_ENTRY.font_size)
		note = "[ul bullet=- ]" + note
		new_label.fit_content = true
	new_label.add_theme_color_override('default_color', Color.BLACK)
	new_label.text = note
	#new_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return new_label
