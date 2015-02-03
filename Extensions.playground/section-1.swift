// Playground - noun: a place where people can play

import Cocoa
import XCPlayground

extension Int {
    func times(task: () -> ()) {
        for i in 0..<self {
            task()
        }
    }
}


// trailing closure syntax
3.times {
    println("isn't this nice")
}

extension Int {
    subscript(var index: Int) -> Int {
        var base = 1
        while index > 0 {
            base *= 10
            index--
        }
        return (self / base) % 10
    }
}

println("The fifth digit of 198309284 is \(198309284[5])")

struct Rect {
    var width = 0, height = 0
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}

struct Size {
    var width, height: Int
}

extension Rect {
    init(dims: Size) {
        self.width = dims.width
        self.height = dims.height
    }
    
    init(dims: (width: Int, height: Int)) {
        self.width = dims.width
        self.height = dims.height
    }
}

extension Double {
    var km: Double { return self * 1000.0 }
    var m: Double { return self }
    var mm: Double { return self / 1000.0 }
    var cm: Double { return self / 100.0 }
    var ft: Double { return self / 3.2 }
}

var x = 3.2.ft
var y = 4.5.km

println(x + y)

