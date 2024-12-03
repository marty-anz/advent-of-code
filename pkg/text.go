package pkg

import (
	"strconv"
	"strings"
)

func Lines(i string) []string {
	lines := []string{}

	for _, l := range strings.Split(i, "\n") {
		l = strings.TrimSpace(l)

		if l != "" {
			lines = append(lines, l)
		}
	}

	return lines
}

func SplitLines(lines []string, pat string) [][]string {
	var x [][]string

	for _, l := range lines {
		x = append(x, strings.Split(l, pat))
	}

	return x
}

func Atois(numbers []string) []int {
	ns := []int{}

	for _, x := range numbers {
		n, _ := strconv.Atoi(x)
		ns = append(ns, n)
	}

	return ns
}
