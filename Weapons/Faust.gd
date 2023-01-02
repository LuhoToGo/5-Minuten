extends Weapon


func _on_AnimationPlayer_animation_started(anim_name):
	$HitSound.play()
