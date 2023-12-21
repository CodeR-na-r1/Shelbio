extends Node2D

var rng = RandomNumberGenerator.new()
var whiskey = preload("res://Collectibles/whiskey.tscn")
var heart = preload("res://Collectibles/heart.tscn")

var maxBonusType = 2 -1
enum bonusType_t {
	WISKEY,
	HEART	
}

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("playerCollectBonus", Callable(self, "_unpackingBonus"))

func _unpackingBonus(coords):
	var bonus = randi_range(0, maxBonusType)
	print(bonus)
	
	match bonus:
		bonusType_t.WISKEY:
			print("wiskey ! bonus")
			for i in range(5):
				var wiskeyTemp = whiskey.instantiate()
				wiskeyTemp.position = Vector2(coords.x + 128 *(i +1), coords.y - 100)
				add_child(wiskeyTemp)
		bonusType_t.HEART:
			print("heart !! bonus")
			var heartTemp = heart.instantiate()
			heartTemp.position = Vector2(coords.x + 250, coords.y - 250)
			add_child(heartTemp)
