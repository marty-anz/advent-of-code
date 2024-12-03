package main

import (
	_ "embed"
	"fmt"
	"slices"

	"github.com/marty-anz/advent-of-code/pkg"
)

//go:embed input_test.txt
var inputTest string

//go:embed input.txt
var input string

func main() {
	fmt.Println(q1(inputTest))
	fmt.Println(q1(input))

	fmt.Println(q2(inputTest))
	fmt.Println(q2(input))
}

func q1(input string) int {
	gs1 := locateGs(pkg.SplitLines(pkg.Lines(input), ""), 1)
	return countDis(gs1)
}

func q2(input string) int {
	gs1 := locateGs(pkg.SplitLines(pkg.Lines(input), ""), 1_000_000-1)
	return countDis(gs1)
}

func countDis(gs []pkg.P) int {
	if len(gs) == 0 {
		return 0
	}

	c := 0

	for i := 1; i < len(gs); i++ {
		c += pkg.Manhatton(gs[0].XY(), gs[i].XY())
	}

	return c + countDis(gs[1:])
}

func locateGs(u [][]string, s int) []pkg.P {
	expandRows, expandCols := findEmptyRowsCols(u)
	gs := pkg.ScanCoordinates(u, "#")

	ng := []pkg.P{}

	for _, g := range gs {
		x := g
		for _, r := range expandRows {
			if g.X > r {
				x.X += s
			}
		}

		for _, c := range expandCols {
			if g.Y > c {
				x.Y += s
			}
		}

		ng = append(ng, x)
	}

	return ng
}

func findEmptyRowsCols(u [][]string) ([]int, []int) {
	var rows, cols []int

	for r, row := range u {
		if !slices.Contains(row, "#") {
			rows = append(rows, r)
		}
	}

	totalCol := len(u[0])

	for c := 0; c < totalCol; c++ {
		expand := true

		for r := 0; r < len(u); r++ {
			if u[r][c] == "#" {
				expand = false
				break
			}
		}

		if expand {
			cols = append(cols, c)
		}
	}

	return rows, cols
}
