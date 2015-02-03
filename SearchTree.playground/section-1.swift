// Playground - noun: a place where people can play

import Cocoa
import XCPlayground

class Node <Value> {
    var left: Node?
    var right: Node?
    let key: String
    var value: Value
    
    init(key: String, andValue: Value) {
        self.key = key
        self.value = andValue
    }
    
    subscript(index: Int) -> Node? {
        get {
            if index == 0 {
                return self.left
            }
            return self.right
        }
        
        set(value) {
            if index == 0 {
                self.left = value
            } else {
                self.right = value
            }
        }
    }
}

func < <T>(left: Node<T>, right: Node<T>) -> Bool {
    return left.key < right.key
}

class SearchTree <Value> {
    private var root: Node<Value>?
    
    private func insert(var root: Node<Value>?, key: String, value: Value)
        -> Node<Value> {
            if let parent = root {
                if key < parent.key {
                    parent[0] = insert(parent[0], key: key, value: value)
                } else if key > root!.key {
                    parent[1] = insert(parent[1], key: key, value: value)
                }
                return parent
            }
            return Node(key: key, andValue: value)
    }
    
    private func getNodeWith(#key: String, fromRoot root: Node<Value>?)
        -> Node<Value>? {
            if let parent = root {
                if key < parent.key {
                    return getNodeWith(key: key, fromRoot: parent[0])
                } else if key > parent.key {
                    return getNodeWith(key: key, fromRoot: parent[1])
                } else {
                    return parent
                }
            }
            return nil
    }
    
    private func flatten(root: Node<Value>?, inout intoArray array: [Node<Value>]) {
        if let parent = root {
            array.append(parent)
            
            if let left: Node<Value> = parent[0] {
                array.append(left)
                flatten(left, intoArray: &array)
            }
            
            if let right: Node<Value> = parent[1] {
                array.append(right)
                flatten(right, intoArray: &array)
            }
        }
    }
    
    func linearize() -> [Node<Value>] {
        var array: [Node<Value>] = []
        self.flatten(self.root, intoArray: &array)
        
        return array
    }
    
    subscript(key: String) -> Value? {
        get {
            return self.getNodeWith(key: key, fromRoot: self.root)?.value
        }
        
        set(value) {
           self.root = self.insert(self.root, key: key, value: value!)
        }
    }
}

var tree = SearchTree<Int>()

tree["john"] = 24
tree["hi"] = 5
println(tree["hi"])
println(tree["john"])


func + <T>(left: SearchTree<T>, right: SearchTree<T>) -> SearchTree<T> {
    var array = left.linearize() + right.linearize()
    var newTree = SearchTree<T>()
    for node in array {
        newTree[node.key] = node.value
    }
    return newTree
}

var tree2 = SearchTree<Int>()

tree2["quote"] = 42
println(tree2["quote"])

var tree3 = tree + tree2

println(tree3["quote"])
println(tree3["hi"])



