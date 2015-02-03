// Playground - noun: a place where people can play

import Cocoa
import SpriteKit
import XCPlayground

let sceneWidth: Int = 500
let sceneHeight: Int = 200

let loadEmitterWithName: (String) -> SKEmitterNode = { name in
    let resource = NSBundle.mainBundle().pathForResource(name, ofType: "sks")
    
    return NSKeyedUnarchiver.unarchiveObjectWithFile(resource!) as SKEmitterNode
}

var fire = loadEmitterWithName("Fire")
fire.position = CGPoint(x: sceneWidth / 2, y: sceneHeight / 2)

let view = SKView(frame: NSRect(x: 0, y: 0, width: sceneWidth, height: sceneHeight))
let scene = SKScene(size: CGSize(width: sceneWidth, height: sceneHeight))

scene.addChild(fire)

let presentScene: () -> () = {
    view.presentScene(scene)
    XCPShowView("Particle Playground", view)
}

presentScene()