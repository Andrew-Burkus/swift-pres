// Playground - noun: a place where people can play

import UIKit
import XCPlayground

/*Standard Function Stuff*/

func identity(x: Int) -> Int {
    return x
}

//external parameter name
func identity(withInteger x: Int) -> Int {
	return x
}

println(identity(withInteger: 9))

//void return types
func printAnInt(x: Int) { //no return type need be specified
	println(x)
}
//Actually returns type (), an empty tuple is = Void



//multiple return types
func tupelizeIntegers(one: Int, two: Int, three: Int)
    -> (Int, Int, Int) {
	return (one, two, three)
}

// # characters can be used to create identical
// internal and external parameter names
func join(#s1: String, #s2: String, #joiner: String)
    -> String {
    return s1 + joiner + s2;
}

println(join(s1: "hi", s2: "fred", joiner: ", "))

// default function values
func add(x: Int, y: Int = 0) -> Int {
    return x + y
}

println(add(1))

let data: [Int] = [1, 2, 3, 4, 5]

for int in data {
    XCPCaptureValue("graph", int)
}

//Variadic Parameters example
func graphNumbers(numbers: Int...) {
    for int in numbers {
        XCPCaptureValue("graph", int)
    }
}

graphNumbers(1, 2, 5, 6, 10, 12)

/* Functional Programming Stuff */

func modInteger(x: Int, withFunction f: Int -> Int)
    -> Int {
    return f(x)
}

func double(x: Int) -> Int {
    return x * 2
}

println(modInteger(3, withFunction: double))

// Higher-order functions

func stepForward(x: Int) -> Int {
    return x + 1
}

func stepBackward(x: Int) -> Int {
    return x - 1
}

func chooseStepFunction(forward: Bool) -> (Int) -> Int {
    return forward ? stepForward : stepBackward
}


