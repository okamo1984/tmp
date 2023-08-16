package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {
	c := make(chan string, 1)
	errC := make(chan error, 1)
	go lineIterChan(c, errC)
	for {
		select {
		case line := <-c:
			fmt.Println(line)
		case <-errC:
			os.Exit(1)
		}
	}
}

const lines string = `This is an iterator that returns lines from string.
This line is second.
This line is third.
This line is fourth.
`

func lineIterChan(c chan<- string, errC chan <-error) {
	buf := bufio.NewScanner(strings.NewReader(lines))
	defer func() {
		close(c)
		close(errC)
	}()
	for buf.Scan() {
		text := buf.Text()
		if strings.Contains(text, "third") {
			errC <- fmt.Errorf("third line")
			break
		}
		c <- text
	}
}
