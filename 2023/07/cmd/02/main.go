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
	five  = "0"
	four  = "1"
	full  = "2"
	three = "3"
	two   = "4"
	one   = "5"
	high  = "6"
)

var ranklabels = map[string]string{
	five:  "Five of a kind",
	four:  "Four of a kind",
	full:  "Fullhouse",
	three: "Three of a kind",
	two:   "Two pairs",
	one:   "One pair",
	high:  "High hand",
}

var cardOrders = map[rune]string{
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

	jokers, hasJokers := v['J']

	switch r.handType {
	case four:
		if hasJokers {
			r.handType = five
		}
	case full:
		// AAAJJ
		// JJJAA
		if hasJokers {
			r.handType = five
		}
	case three:
		switch jokers {
		case 1:
			r.handType = four
		case 2:
			r.handType = five
		case 3:
			r.handType = four
		}
	case two:
		switch jokers {
		case 1:
			// XX AA J
			r.handType = full
		case 2:
			// XX JJ A
			r.handType = four
		}
	case one:
		// XX A B J
		if hasJokers {
			r.handType = three
		}
	case high:
		// A B C D J
		if hasJokers {
			r.handType = one
		}
	}

	r.order = r.handType + cardWeight

	return r
}

func sortRanks(ranks []rank) {
	sort.Slice(ranks, func(i, j int) bool {
		return ranks[i].order > ranks[j].order
	})
}

func q2(input string) int {
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

	// for _, r := range ranks {
	// 	displayRank(r)
	// }

	// fmt.Printf("%v\n", ranks)

	s := 0

	for i, r := range ranks {
		s += (i + 1) * r.stake
	}

	return s
}

func displayRank(r rank) {
	s := r.hand

	s += " " + ranklabels[r.handType]

	s += " " + r.order

	fmt.Println(s)
}

func main() {
	fmt.Println(q2(inputTest))
	fmt.Println(q2(input1))
}
