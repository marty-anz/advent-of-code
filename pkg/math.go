package pkg

type P struct {
	X, Y int
}

func (p P) XY() []int {
	return []int{p.X, p.Y}
}

func gcd(a, b int64) int64 {
	for b != 0 {
		a, b = b, a%b
	}

	return a
}

func GCD(x ...int64) int64 {
	a := x[0]

	for i := 1; i < len(x); i++ {
		a = gcd(a, x[i])
	}

	return a
}

func lcm(a, b int64) int64 {
	return (a * b) / gcd(a, b)
}

func LCM(x ...int64) int64 {
	a := x[0]

	for i := 1; i < len(x); i++ {
		a = lcm(a, x[i])
	}

	return a
}

func Abs[T int](i T) T {
	if i < 0 {
		i = -i
	}

	return i
}

func Manhatton(xy, xy1 []int) int {
	return Abs(xy[0]-xy1[0]) + Abs(xy[1]-xy1[1])
}

func ScanCoordinates[T comparable](plane [][]T, mat T) []P {
	ps := []P{}

	for x, row := range plane {
		for y, e := range row {
			if e == mat {
				ps = append(ps, P{x, y})
			}
		}
	}

	return ps
}
