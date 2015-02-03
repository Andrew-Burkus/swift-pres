// Playground - noun: a place where people can play

import Cocoa

extension Int {
    func times(task: () -> ()) {
        for _ in 0..<self {
            task()
        }
    }
    
    func times(task: @autoclosure () -> ()) {
        for _ in 0..<self {
            task()
        }
    }
}

3.times {
    println("hi")
}

3.times(println("yep"))

class $ {
    func after(f: () -> (), block: () -> ())
    -> () -> () {
        return {
            f()
            block()
        }
    }
}

