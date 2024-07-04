package main

import (
	_ "embed"
	"fmt"
	"strconv"
	"strings"
)

//go:embed input_test.txt
var inputTest string

//go:embed input.txt
var input string

func main() {
	fmt.Println(q1(inputTest, extrapolate))
	fmt.Println(q1(input, extrapolate))

	fmt.Println(q1(inputTest, backwardExtrapolate))
	fmt.Println(q1(input, backwardExtrapolate))
}

func q1(input string, f func([]int) int) int {
	count := 0

	lines := strings.Split(input, "\n")

	for _, l := range lines {
		if l == "" {
			continue
		}

		parts := strings.Split(l, " ")

		n := make([]int, len(parts))

		for i, p := range parts {
			n[i], _ = strconv.Atoi(p)
		}

		// fmt.Printf("%v\n", n)

		count += f(n)
		// break
	}

	return count
}

func stop(n []int) bool {
	for _, i := range n {
		if i != 0 {
			return false
		}
	}
	return true
}

func extrapolate(n []int) int {
	diffs := map[int][]int{}
	iter := 0

	diffs[0] = n
	for {
		if stop(diffs[iter]) {
			break
		}

		diff := []int{}

		for i := 1; i < len(diffs[iter]); i++ {
			diff = append(diff, diffs[iter][i]-diffs[iter][i-1])
		}

		iter++
		diffs[iter] = diff
	}

	previous := 0

	for i := iter; i >= 0; i-- {
		previous += diffs[i][len(diffs[i])-1]
	}

	return previous
}

func backwardExtrapolate(n []int) int {
	diffs := map[int][]int{}
	iter := 0

	diffs[0] = n
	for {
		if stop(diffs[iter]) {
			break
		}

		diff := []int{}

		for i := 1; i < len(diffs[iter]); i++ {
			diff = append(diff, diffs[iter][i]-diffs[iter][i-1])
		}

		iter++
		diffs[iter] = diff
	}

	previous := 0

	for i := iter; i >= 0; i-- {
		previous = diffs[i][0] - previous
	}

	return previous
}
