package main

import (
	"fmt"
)

/**
Go is pass by value; it may pass references, but below shows how it's pass by value even when working directly with pointers.

https://dave.cheney.net/2017/04/29/there-is-no-pass-by-reference-in-go
 */

/**
#include <stdio.h>

int main() {
		// a, b and c in C/C++ are aliases or reference variables; they share the same storage location
        int a = 10;
        int &b = a;
        int &c = b;

        printf("%p %p %p\n", &a, &b, &c); // 0x7ffe114f0b14 0x7ffe114f0b14 0x7ffe114f0b14
        return 0;
}
 */

func swap(px, py *int) {
	fmt.Println("---in swap before")
	fmt.Println("px:", &px, px, *px)
	fmt.Println("py:", &py, py, *py)
	tmp := px
	px = py
	py = tmp

	fmt.Println("---in swap after")
	fmt.Println("px:", &px, px, *px)
	fmt.Println("py:", &py, py, *py)
}

func main() {
	var pa = new(int)
	var pb = new(int)

	*pa=100
	*pb=200

	fmt.Println("---startup")
	fmt.Println("pa:", &pa, pa, *pa)
	fmt.Println("pb:", &pb, pb, *pb)

	swap(pa, pb)

	fmt.Println("---returned from swap")
	fmt.Println("pa:", &pa, pa, *pa)
	fmt.Println("pb:", &pb, pb, *pb)

	//shows a real swap - proving that function calls are pass-by-value
	tmp := pa
	pa = pb
	pb = tmp

	fmt.Println("---inline swap without function call")
	fmt.Println("pa:", &pa, pa, *pa)
	fmt.Println("pb:", &pb, pb, *pb)

	// in go you can have variables POINT to the same address location, but not share the same address
	fmt.Println("showing how variables do not share same address like c/c++")
	var a int
	var b, c = &a, &a
	fmt.Println(b, c)   // 0xc00001a190 0xc00001a190
	fmt.Println(&b, &c) // 0xc00000e050 0xc00000e058
}
