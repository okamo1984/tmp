package main

import (
	"bufio"
	"fmt"
	"strings"
)

func main() {
	for line := range lineIter {
		fmt.Println(line)
	}
}

const lines string = `This is an iterator that returns lines from string.
This line is second.
This line is third.
This line is fourth.
`

func lineIter(yield func(string) bool) bool {
	buf := bufio.NewScanner(strings.NewReader(lines))
	for buf.Scan() {
		if !yield(buf.Text()) {
			return false
		}
	}
	return true
}
