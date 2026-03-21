extends Node

signal money_change(new_amount: int)

var money: int

func reset() -> void:
	money = 0

func add_money(amount: int):
	print("ADD MONEY")
	money += amount
	money_change.emit(money)
