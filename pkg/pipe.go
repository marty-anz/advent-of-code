package pkg

func Pipe[T any](x T, procs ...func(a T) T) T {
	for _, p := range procs {
		x = p(x)
	}

	return x
}
