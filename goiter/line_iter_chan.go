package main

import (
	"bufio"
	"fmt"
	"strings"
)

func main() {
	c := make(chan string, 1)
	go lineIterChan(c)
	for line := range c {
		fmt.Println(line)
	}
}

const lines string = `This is an iterator that returns lines from string.
This line is second.
This line is third.
This line is fourth.
`

func lineIterChan(c chan<- string) {
	buf := bufio.NewScanner(strings.NewReader(lines))
	for buf.Scan() {
		c <- buf.Text()
	}
	close(c)
}
