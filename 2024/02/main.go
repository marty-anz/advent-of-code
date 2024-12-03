package main

import "fmt"

func main() {
	a := []int{1, 2, 3, 4}

	for i := range a {
		c := make([]int, len(a))
		copy(c, a)

		b := append(c[0:i], c[i+1:]...)

		fmt.Printf("%d %v %v\n", i, b, a)
	}
}
