package main

import (
	_ "embed"
	"fmt"
	"sort"
	"strconv"
	"strings"
)

//go:embed input_test.txt
var inputTest string

//go:embed input1.txt
var input1 string

const (
	five       = "0"
	four       = "1"
	full       = "2"
	n    three = "3"
	two        = "4"
	one        = "5"
	high       = "6"
)

var cardOrders = map[rune]string{
	'A': "0",
	'K': "1",
	'Q': "2",
	'J': "3",
	'T': "4",
	'9': "5",
	'8': "6",
	'7': "7",
	'6': "8",
	'5': "9",
	'4': "A",
	'3': "B",
	'2': "C",
}

var cardOrdersWithJoker = map[rune]string{
	'A': "0",
	'K': "1",
	'Q': "2",
	'T': "4",
	'9': "5",
	'8': "6",
	'7': "7",
	'6': "8",
	'5': "9",
	'4': "A",
	'3': "B",
	'2': "C",
	'J': "D",
}

type rank struct {
	hand     string
	stake    int
	handType string
	order    string
}

func parseHand(line string) rank {
	parts := strings.Split(strings.TrimSpace(line), " ")

	hand := parts[0]
	stake, _ := strconv.Atoi(parts[1])

	r := rank{
		hand:  hand,
		stake: stake,
	}

	v := map[rune]int{}

	cardWeight := ""
	for _, c := range hand {
		if _, ok := v[c]; !ok {
			v[c] = 1
		} else {
			v[c] += 1
		}
		cardWeight += cardOrders[c]
	}

	switch len(v) {
	case 1:
		r.handType = five
	case 2:
		r.handType = full

		for _, count := range v {
			if count == 4 {
				r.handType = four
				break
			}
		}
	case 3:
		r.handType = two

		for _, count := range v {
			if count == 3 {
				r.handType = three
				break
			}
		}
	case 4:
		r.handType = one
	default:
		r.handType = high
	}

	r.order = r.handType + cardWeight

	return r
}

func sortRanks(ranks []rank) {
	sort.Slice(ranks, func(i, j int) bool {
		return ranks[i].order > ranks[j].order
	})
}

func q1(input string) int {
	lines := strings.Split(input, "\n")
	// fmt.Printf("%v\n", lines[0])
	var ranks []rank
	for _, l := range lines {
		if len(l) != 0 {
			ranks = append(ranks, parseHand(l))
		}
	}

	// fmt.Printf("%v\n", ranks)

	sortRanks(ranks)

	// fmt.Printf("%v\n", ranks)

	s := 0

	for i, r := range ranks {
		s += (i + 1) * r.stake
	}

	return s
}

func main() {
	fmt.Println(q1(inputTest))
	fmt.Println(q1(input1))
}
