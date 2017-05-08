extends Node

onready var factory = load("res://scenes/FoodFactory.tscn").instance()
onready var h_timer = get_node("HideTimer")
onready var v_timer = get_node("VictoryTimer")
onready var cards_a = get_node("Cards")
onready var req_lbl = get_node("FoodRequest")
onready var score_lbl = get_node("Score")
onready var Animator = get_node("Animator")

var food_sprite = "res://assets/%s.png"

const card_back = preload("res://assets/card_back.png")
onready var needs = [
	"Gimme a donut!!",
	"I'd love an hamburger!",
	"I would like some cheesecake please..",
	"Time for an hotdog!",
	"What about some pizza?",
]
onready var needs_sol = {
	0 : "donut",
	1 : "hamburger",
	2 : "cheesecake",
	3 : "hotdog",
	4 : "pizza"
}

var solution
var solution_ind
onready var score = 0

func _ready():
	get_node("SamplePlayer2D").play("1hgj_splash")
	randomize()

func create_card_combo():

	for i in range(5):
		var index = randi() % 5
		var f = factory.gen_food(i)
		cards_a.add_child(f)
		f.set_pos(Vector2( 16 * i, 16 * i))
		f.set_name(needs_sol[i])

func start_game():
	score_lbl.set_text("Score: " + str(score))
	solution_ind = randi() % 5
	solution = needs_sol[solution_ind]
	h_timer.set_active(true)
	h_timer.set_wait_time(2)
	h_timer.start()
	get_need()

func get_need():
	req_lbl.set_text(needs[solution_ind])

func _on_HideTimer_timeout():
	hide_cards()

func hide_cards():
	h_timer.set_active(false)
	for food in cards_a.get_children():
		food.set_normal_texture(card_back)

func show_cards():
	for food in cards_a.get_children():
		food.set_normal_texture(load(food_sprite % [food.get_name()]))

func check_victory(food_passed):
	if(needs_sol[solution_ind] == food_passed):
		var sol_node = get_node("Cards/" + food_passed)
		Animator.interpolate_property(sol_node, "rect/pos", sol_node.get_pos(), sol_node.get_pos() - Vector2(0, 60), 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		Animator.interpolate_property(sol_node, "rect/pos", sol_node.get_pos() - Vector2(0, 60), sol_node.get_pos(), 0.8, Tween.TRANS_BOUNCE, Tween.EASE_OUT, .5)
		Animator.start()

		req_lbl.set_text("Thanks!")
		score += 1
	else:
		req_lbl.set_text("That's wrong!")
		score -= 1
	show_cards()
	v_timer.start()

func _button_pressed(food):
	if (!h_timer.is_active()):
		check_victory(food)

func _on_Timer_timeout():
	get_node("Splash").queue_free()
	create_card_combo()
	start_game()

func _on_VictoryTimer_timeout():
	start_game()