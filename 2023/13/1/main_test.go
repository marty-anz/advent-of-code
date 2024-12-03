package main

import (
	_ "embed"
	"fmt"
	"strings"
	"testing"

	"github.com/marty-anz/advent-of-code/pkg"
	"github.com/stretchr/testify/assert"
)

//go:embed input_test.txt
var inputTest string

//go:embed input.txt
var input string

func TestMain(t *testing.T) {
	// fmt.Printf("%v\n", images[0].rows)
	// fmt.Printf("%v\n", images[0].cols)
	//
	//
	//
	//
	yes, i := reflected([]string{
		".#..###.#",
		".###.##.#",
		"....###.#",
		".######..",
		"...#.#.#.",
		"...#.#.#.",
		".######..",
		"....###.#",
		".###.##.#",
		".#..###.#",
		"####...##",
		"..##.#..#",
		"..##....#",
		"####...##",
		".#..###.#",
	})

	assert.True(t, yes)
	assert.Equal(t, 5, i)

	// yes, i := reflected([]string{
	// 	"##.#.##...####.",
	// 	"#####..#...##..",
	// 	"##.##.#.#####.#",
	// 	".##.#..##..##..",
	// 	"###..#.#####.#.",
	// 	"###..#.#####.#.",
	// 	".##.#..##..##..",
	// 	"##.##.#.#####.#",
	// 	"#####..#...##..",
	// 	"##.#.##..#####.",
	// 	"...#...#....###",
	// 	"##.#.###.###..#",
	// 	"..#.###.#.#....",
	// 	"####...#.#.#...",
	// 	".#..#....##.#.#",
	// 	"....####.###.##",
	// 	"....####.###.##",
	// })
	// assert.True(t, yes
	// assert.Equal(t, 5, i)

	assert.Equal(t, 405, q1(inputTest))
	assert.Equal(t, 405, q1(input))
}

func q1(input string) int {
	s := 0
	images := parse(input)
	for _, image := range images {
		n := imageReflectNumber(image)
		fmt.Println(n)
		s += n
	}

	return s
}

type image struct {
	rows []string
	cols []string
}

func parse(input string) []image {
	images := []image{}
	for _, block := range strings.Split(input, "\n\n") {
		rows := pkg.Lines(block)
		cols := rToC(rows)

		images = append(images, image{rows, cols})
	}

	return images
}

func rToC(rows []string) []string {
	cols := make([]string, len(rows[0]))

	for _, row := range rows {
		for c, v := range strings.Split(row, "") {
			cols[c] += v
		}
	}
	return cols
}

func imageReflectNumber(image image) int {
	//fmt.Println("rows...")
	yes, row := reflected(image.rows)

	if yes {
		return row * 100
	}

	//fmt.Println("cols...")
	yes, col := reflected(image.cols)

	if yes {
		return col
	}

	fmt.Println("no reflection found")

	p(image.cols)

	fmt.Println()

	p(image.rows)

	fmt.Println("------------")

	return 0
}

func reflected(image []string) (bool, int) {
	l := len(image)

	reversed := make([]string, l)

	for i, s := range image {
		reversed[l-i-1] = s
	}

	// from left
	for i := 0; i < l-1; i++ {
		if eq(reversed[i:], image[0:l-i]) {
			//	fmt.Printf("left: i = %d l = %d n = %d \n", i, l, (l-i)/2)
			return true, (l - i) / 2
		}
	}

	// from right
	for i := 0; i < l-1; i++ {
		if eq(reversed[0:l-i], image[i:]) {
			// fmt.Printf("right: i = %d l = %d n = %d\n", i, l, i+(l-i)/2)
			return true, i + (l-i)/2
		}
	}

	return false, 0
}

func p(s []string) {
	fmt.Println(strings.Join(s, "\n"))
}

func eq(s1, s2 []string) bool {
	if len(s1) < 1 || len(s2) < 1 {
		return false
	}

	for i, s := range s1 {
		if s != s2[i] {
			return false
		}
	}

	return true
}
