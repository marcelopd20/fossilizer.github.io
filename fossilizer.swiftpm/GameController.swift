//
//  GameController.swift
//  fossilizer
//
//  Created by Marcelo Pastana Duarte on 10/04/23.
//

import Foundation
import Combine
import SpriteKit
import SwiftUI



let stdX = 553
let stdY = 1200

extension FloatingPoint {
    var degreesToRadians: Self { self * .pi / 180 }
    var radiansToDegrees: Self { self * 180 / .pi }
}


extension Notification.Name {
    static let myNotification = Notification.Name("notificationEcdysis")
}

class Trilobite {
    var pos: CGPoint
    var dest: CGPoint
    var rot: Float
    
    init() {
        let newPosition = Self.newPosition(Int.random(in: 1...4))
        self.pos = newPosition.pos
        self.dest = newPosition.dest
        self.rot = newPosition.rot
    }
    
    
    static func newPosition(_ value: Int) -> (pos: CGPoint,dest: CGPoint, rot: Float) {
        
        let pos: CGPoint
        let dest: CGPoint
        let rot: Float
        
        switch value {
            case 1:
                pos = CGPoint(x: -80, y: Int.random(in: 1...stdY))
                dest = CGPoint(x: stdX + 80, y: Int.random(in: 1...stdY))
                rot = Float(270).degreesToRadians
            case 2:
                pos = CGPoint(x: Int.random(in: 1...stdX), y: -60)
                dest = CGPoint(x: Int.random(in: 1...stdX),y: stdY + 60)
                rot = 0
            case 3:
                pos = CGPoint(x: stdX + 60, y: Int.random(in: 1...stdY))
                dest = CGPoint(x: -60, y: Int.random(in: 1...stdY))
                rot = Float(90).degreesToRadians
            default:
                pos = CGPoint(x: Int.random(in: 1...stdX), y: stdY + 80)
                dest = CGPoint(x: Int.random(in: 1...stdX), y: -80)
                rot = Float(180).degreesToRadians
        }
        
        
        return (pos: pos, dest: dest, rot: rot)
        
    }
    
    func createNode(_ name: String, _ position: CGPoint? = nil, _ rotation: Float? = nil) -> SKSpriteNode {
        let p = position ?? pos
        let r = rotation ?? rot
        let newTrilobite = SKSpriteNode(imageNamed: name)
        newTrilobite.size = .init(width: 80, height: 120)
        newTrilobite.zRotation = .init(r)
        newTrilobite.position = p
        return newTrilobite
    }
}


func createLabel(_ name: String,_ position: CGPoint = CGPoint(x: 60, y: 1050)) -> SKLabelNode {
    let label = SKLabelNode(text: "\(name): 0")
    
    label.fontSize = 30
    label.fontName = "AvenirNext-Bold"
    label.fontColor = .black
    label.position = position
    label.name = "\(name)_\(Date())"
    return label
}

struct Ecdsys:Identifiable {
    var id: UUID = UUID()
    var x:CGFloat
    var y:CGFloat
    var rot: CGFloat
    var clicks: Int
}

class GameController: SKScene, ObservableObject {
    var ecdysis: [Ecdsys] {
        var positions:[Ecdsys] = []
        for ecdysis in burriedEcdysis.values {
            positions.append(Ecdsys(x: ecdysis.node.position.x, y: ecdysis.node.position.y, rot: ecdysis.node.zRotation, clicks: ecdysis.clicks))
        }
        return positions
    }
    
    var startTime: Double?
    var selectedNodes:[UITouch:SKSpriteNode] = [:]
    var burriedEcdysis: [String: (clicks: Int, node: SKSpriteNode, time: Date)] = [:]
    var lastSpawnTime: Date?
    var score = createLabel("Score")
    var timer = createLabel("Timer", CGPoint(x: 70, y: 1010))
    var timerCounting = 60
    @Published var changeView: Bool = false
    
    var burriedCounter: Int = 0 {
        didSet {
            self.score.text = "Score: \(burriedCounter)"
        }
    }
    var timerCounter: Int = 40 {
        didSet {
            self.timer.text = "Timer: \(Int(timerCounter))"
            
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if startTime == nil {
            startTime = currentTime
        }
        let timerCounting = Int(40 - (currentTime - (startTime ?? 0)))
        timerCounter = timerCounting > 0 ? timerCounting : 0
        
        if timerCounter == 0 {
            OperationQueue.main.addOperation {
                self.changeView = true
            }
        }
    }
    
    override func didMove(to view: SKView) {
        
        addChild(self.score)
        addChild(self.timer)
        
        let wait = SKAction.wait(forDuration: 0.5,withRange: 2)
        
        let spawnNode = SKAction.run {[unowned self] in
            let now = Date()
            self.lastSpawnTime = now
            let trilobite: Trilobite = Trilobite()
            let trilobiteNode: SKSpriteNode = trilobite.createNode("trilobite")
            trilobiteNode.name = "trilobite\(now.ISO8601Format())"
            self.addChild(trilobiteNode)
            trilobiteNode.run(.move(to: trilobite.dest, duration: 2))
        }
        let sequence = SKAction.sequence([spawnNode, wait])
        let loop = SKAction.repeat(sequence, count: 100)
        
        run(loop)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in:self)
            if let node = self.atPoint(location) as? SKSpriteNode {
                if node.name?.starts(with: "trilobite") == true {
                    
                    var isNewTrilobite = true
                    
                    for trilobiteNode in selectedNodes.values {
                        if trilobiteNode.name == node.name {
                            isNewTrilobite = false
                        }
                    }
                    
                    if isNewTrilobite {
                        let ecdysis = Trilobite().createNode("trilobite_ecdysis",node.position, Float(node.zRotation))
                        ecdysis.name = "ecdysis_" + (node.name ?? "")
                        addChild(ecdysis)
                        selectedNodes[touch] = node
                        burriedEcdysis[String(ecdysis.name ?? "")] = (clicks:0, node: ecdysis, time: Date())
                    }
                }
                if node.name?.starts(with: "ecdysis_") == true && timerCounter > 0 {
                    for ecdysisNode in burriedEcdysis {
                        if node.name == ecdysisNode.key {
                            if ecdysisNode.value.clicks < 4 {
                                let value = burriedEcdysis[ecdysisNode.key]?.clicks ?? 0
                                if burriedEcdysis[ecdysisNode.key]!.time.timeIntervalSince(Date()) <= -3 {
                                    node.texture = SKTexture(imageNamed: "trilobite_rotten")
                                } else {
                                    burriedEcdysis[ecdysisNode.key]?.clicks = value + 1
                                    burriedEcdysis[ecdysisNode.key]?.node.alpha -= 0.25
                                    if burriedEcdysis[ecdysisNode.key]?.clicks == 4 {
                                        burriedCounter += 1
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
        }
    }
}
