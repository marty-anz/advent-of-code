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

type springCondition struct {
	record []string
	counts []int
}

func main() {
	// fmt.Println(q1(inputTest))
	// fmt.Println(q1(input))
	// fmt.Println(q2(inputTest))

	//fmt.Println(q1("?###????????? 3,2,1"))

	//	fmt.Println(q2("??..## 1,2"))
	// fmt.Println(q2(".??..##. 1,2"))
	// fmt.Println(q2(input))

	// fmt.Println(q2("???.### 1,1,3"))
	// fmt.Println(q2(".??..??...?##. 1,1,3"))
	// fmt.Println(q2("????.######..#####. 1,6,5"))
	//
	rec := parse("?.###???????? 3,2,1", 5)[0]
	total := 0
	gen(rec.record, rec.counts, 0, 0, false, &total)

	fmt.Println(total)

	fmt.Println(q2("?.###???????? 3,2,1"))

	// fmt.Println(q2(inputTest))
	// fmt.Println(q2(input))
}

func q1(i string) int {
	total := 0
	for _, rec := range parse(i, 1) {
		gen(rec.record, rec.counts, 0, 0, false, &total)
	}

	return total
}

func q2(i string) int {
	total := 0
	for _, rec := range parse(i, 1) {
		// fmt.Printf("%d %v\n", i, rec)

		t := 0
		gen(rec.record, rec.counts, 0, 0, false, &t)

		if rec.record[len(rec.record)-1] == "#" {
			total += t * t * t * t * t
			continue
		}

		if rec.record[len(rec.record)-1] == "." {
			t1 := 0

			r := []string{"?"}
			r = append(r, rec.record...)
			gen(r, rec.counts, 0, 0, false, &t1)

			total += t * t1 * t1 * t1 * t1

			continue
		}

		t1 := 0

		r := []string{}
		r = append(r, rec.record...)
		// r = append(r, "?")

		for p := 0; p < len(rec.record); p++ {
			if rec.record[p] != "#" {
				r = append(r, rec.record[p])
			} else {
				break
			}
		}

		// fmt.Println(strings.Join(r, ""))
		gen(r, rec.counts, 0, 0, false, &t1)

		total += t * t1 * t1 * t1 * t1
	}

	return total
}

// .??..##.
// .??..##.?.??..##.?.??..##.?.??..##.?.??..##.

func _q2(i string) int {
	total := 0
	for i, rec := range parse(i, 1) {
		fmt.Println(i)
		st := 1
		t := 0

		newRecord := []string{}
		newRecord = append(newRecord, rec.record...)
		newRecord = append(newRecord, "?")

		gen(newRecord, rec.counts, 0, 0, false, &t)

		if t != 0 {
			st *= t
		}

		for x := 0; x < 4; x++ {
			t = 0
			newRecord := []string{}
			newRecord = append(newRecord, "?")
			newRecord = append(newRecord, rec.record...)
			gen(newRecord, rec.counts, 0, 0, false, &t)

			if t != 0 {
				st *= t
			}
		}

		total += st
	}

	return total
}

func parse(i string, unfold int) (sc []springCondition) {
	for _, l := range pkg.Lines(i) {
		parts := strings.Split(l, " ")

		record := strings.Split(parts[0], "")
		counts := pkg.Atois(strings.Split(parts[1], ","))

		cond := springCondition{record, counts}

		unfolded := springCondition{}

		for i := 0; i < unfold; i++ {
			unfolded.record = append(unfolded.record, cond.record...)
			unfolded.record = append(unfolded.record, "?")
			unfolded.counts = append(unfolded.counts, cond.counts...)
		}

		unfolded.record = unfolded.record[0 : len(unfolded.record)-1]

		sc = append(sc, unfolded)
	}

	return
}

func gen(a []string, counts []int, count, i int, counting bool, total *int) {
	// fmt.Printf("%d %d %d %s\n", count, i, *total, strings.Join(a, ""))

	if len(a) == 0 {
		if counting {
			if i != len(counts)-1 {
				return
			}

			if count == counts[i] {
				// fmt.Println(prefix)
				*total += 1
			}

			return
		}

		if i != len(counts) {
			return
		}
		// fmt.Println(prefix)
		*total += 1

		return
	}

	switch a[0] {
	case "#":
		gen(a[1:], counts, count+1, i, true, total)
	case ".":
		if counting { // stop
			if i >= len(counts) {
				return
			}

			if counting && count != counts[i] {
				return
			}

			gen(a[1:], counts, 0, i+1, false, total)
		} else { // skip
			gen(a[1:], counts, 0, i, false, total)
		}
	default:
		// as #
		gen(a[1:], counts, count+1, i, true, total)

		// as .
		if counting { // stop
			if i >= len(counts) {
				return
			}

			if counting && count != counts[i] {
				return
			}

			gen(a[1:], counts, 0, i+1, false, total)
		} else { // skip
			gen(a[1:], counts, 0, i, false, total)
		}
	}
}
