package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {
	for line, err := range lineIter {
		if err != nil {
			os.Exit(1)
		}
		fmt.Println(line)
	}
}

const lines string = `This is an iterator that returns lines from string.
This line is second.
This line is third.
This line is fourth.
`

func lineIter(yield func(string, error) bool) bool {
	buf := bufio.NewScanner(strings.NewReader(lines))
	for buf.Scan() {
		text := buf.Text()
		if strings.Contains(text, "third") {
			return yield(text, fmt.Errorf("third line"))
		}
		if !yield(buf.Text(), nil) {
			return false
		}
	}
	return true
}
