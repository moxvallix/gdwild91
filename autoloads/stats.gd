extends Node

signal money_change(new_amount: int)
signal paw_count_change(count: int)

var money: int
var paw_count: int

func reset() -> void:
	money = 0
	paw_count = 0

func add_money(amount: int):
	print("ADD MONEY")
	money += amount
	money_change.emit(money)

func set_paw_count(count: int):
	paw_count = count
	paw_count_change.emit(paw_count)
