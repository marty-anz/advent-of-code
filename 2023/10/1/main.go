package main

import (
	_ "embed"
)

//go:embed input_test.txt
var inputTest string

//go:embed input.txt
var input string

const (
	up = iota
	right
	down
	left
)

var connect = map[rune]map[int]map[rune]bool{
	'|': {
		up: {
			'|': true,
			'7': true,
			'F': true,
		},
		right: {
			'7': true,
			'J': true,
		},
		down: {
			'|': true,
			'L': true,
			'J': true,
		},
		left: {
			'L': true,
			'F': true,
		},
	},
	'-': {
		up: {
			'7': true,
			'F': true,
		},
		right: {
			'7': true,
			'J': true,
		},
		down: {
			'|': true,
			'L': true,
			'J': true,
		},
		left: {
			'L': true,
			'F': true,
		},
	},
}

func main() {
}

func q1(input string) int {
	count := 0

	return count
}
