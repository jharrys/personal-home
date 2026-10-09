package main

import (
	"fmt"
	"os"
)

func read(file *os.File, data []byte) int {
	if _, err := file.Write(data); err != nil {
		return 0
	}
	return 1
}

func main() {
	data := make([]byte, 100)
	message := "Error"
	file, err := os.Open("/Users/jharris/tmp/books.json")
	if err != nil {
		fmt.Println(err)
		panic(message)
	}
	read(file, data)
}