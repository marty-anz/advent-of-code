package main

import (
	_ "embed"
	"fmt"
	"strings"
)

//go:embed input_test.txt
var inputTest string

//go:embed input.txt
var input string

func main() {
	fmt.Println(q1(inputTest))
	fmt.Println(q1(input))
}

func q1(input string) int {
	ins, program := parseInput(input)

	pos := "AAA"
	count := 0

	pc := 0

	for {
		if pos == "ZZZ" {
			return count
		}

		if ins[pc] == 'L' {
			pos = program[pos][0]
		} else if ins[pc] == 'R' {
			pos = program[pos][1]
		} else {
			panic("wrong instruction")
		}

		pc = (pc + 1) % len(ins)

		count += 1
	}
}

func parseInput(input string) (string, map[string][]string) {
	lines := strings.Split(input, "\n")
	instructions := lines[0]

	program := map[string][]string{}

	for i := 2; i < len(lines); i++ {
		line := strings.TrimSpace(lines[i])
		if line == "" {
			continue
		}

		key, left, right := line[0:3], line[7:10], line[12:15]

		program[key] = []string{left, right}
	}

	return instructions, program
}
