extends Node

@onready var mailboxes = $"../Mailboxes"
@onready var num_mailboxes = mailboxes.get_child_count()
@onready var inactive_mailboxes = range(num_mailboxes)
@onready var active_mailboxes = Array([])

@onready var newColectionTimer = $newCollectionTimer

func _ready():
		activate_mailbox()
		
func activate_mailbox():
	if len(inactive_mailboxes)>0:
		var idx = inactive_mailboxes.pick_random()
		inactive_mailboxes.erase(idx)
		active_mailboxes.append(idx)
		
		mailboxes.get_child(idx).activate(idx)
		
func deactivate_mailbox(idx):
	active_mailboxes.erase(idx)
	inactive_mailboxes.append(idx)

func _on_new_collection_timer_timeout() -> void:
	activate_mailbox()
