extends CharacterBody2D
enum State {WAIT_AT_BOTTOM, MOVING_UP, WAIT_AT_TOP, MOVING_DOWN}

var current_state = State.WAIT_AT_BOTTOM
var initial_position
var progress = 0.0

@export var movement_speed = 50.0
@export var movement_range = 50

@export var wait_time_at_top = 3.0
@export var wait_time_at_bottom = 3.0

@export var timer: Timer

func _ready():
	initial_position = position.y
	switch_state(State.MOVING_UP)
	
func _on_timer_timeout():
	if current_state == State.WAIT_AT_TOP:
		switch_state(State.MOVING_DOWN)
		
	if current_state == State.WAIT_AT_BOTTOM:
		switch_state(State.MOVING_UP)

func switch_state(new_state):
	current_state = new_state
	match  new_state:
		State.MOVING_UP:
			progress = 0.0
		
		State.WAIT_AT_TOP:
			timer.wait_time = wait_time_at_top
			timer.start()	
			
		State.WAIT_AT_BOTTOM:
			timer.wait_time = wait_time_at_bottom
			timer.start()
			
		State.MOVING_DOWN:
			progress = movement_range / movement_speed
			
func _physics_process(delta):
	match  current_state:
		State.MOVING_UP:
			progress +=delta
			position.y = lerp(initial_position, initial_position - movement_range, progress / (movement_range / movement_range))
			if progress >= (movement_range / movement_speed):
				switch_state((State.WAIT_AT_TOP))
				
		State.MOVING_DOWN:
			progress -= delta
			position.y = lerp(initial_position, initial_position - movement_range, progress / (movement_range / movement_speed))
			if progress <= 0:
				switch_state(State.WAIT_AT_BOTTOM)
