package main

import (
	_ "embed"
	"fmt"
	"strings"

	"github.com/marty-anz/advent-of-code/pkg"
)

//go:embed input_test.txt
var inputTest string

//go:embed input.txt
var input string

func main() {
	fmt.Println(q(inputTest))
	fmt.Println(q(input))
}

func done(pos []string) bool {
	// fmt.Printf("%v\n", pos)
	for _, p := range pos {
		if p[2] != 'Z' {
			return false
		}
	}
	return true
}

func q(input string) int64 {
	ins, pos, program := parseInput(input)

	// fmt.Printf("%v\n", pos)

	// counts := []int{}

	total := int64(1)

	for i, _ := range pos {
		var count, pc int64

		for pos[i][2] != 'Z' {
			d := 0

			if ins[pc] == 'R' {
				d = 1
			}

			pos[i] = program[pos[i]][d]

			pc = (pc + 1) % int64(len(ins))

			count += 1
		}

		total = pkg.LCM(total, count)
	}

	return total
}

func parseInput(input string) (string, []string, map[string][]string) {
	lines := strings.Split(input, "\n")
	instructions := lines[0]

	program := map[string][]string{}
	startPos := []string{}

	for i := 2; i < len(lines); i++ {
		line := strings.TrimSpace(lines[i])
		if line == "" {
			continue
		}

		key, left, right := line[0:3], line[7:10], line[12:15]

		if key[2] == 'A' {
			startPos = append(startPos, key)
		}

		program[key] = []string{left, right}
	}

	return instructions, startPos, program
}
