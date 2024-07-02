package pkg

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
