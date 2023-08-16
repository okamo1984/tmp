package main

import "fmt"

func main() {
	for i := range earlyStop {
		fmt.Println(i)
	}
}

func earlyStop(yield func(int) bool) bool {
	for i := range 10 {
		if !yield(i) {
			return false
		}
		// early stop
		if i == 5 {
			return false
		}
	}
	return true
}
