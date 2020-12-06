//
//  GameScene.swift
//  chessRPG
//
//  Created by Ethan Nerney on 11/17/20.
//  Copyright © 2020 enerney. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var origin: CGPoint!
    var currentPoint: CGPoint!
    var tileSize: CGFloat!
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    let factionSprites: [Faction: String] = [.WHITE: "white", .BLACK: "black"]
    let pieceSprites: [PieceType: String] = [.PAWN: "_pawn", .BISHOP: "_bishop", .KNIGHT: "_knight",
                                             .ROOK: "_rook", .QUEEN: "_queen", .KING: "_king"]

    var currentBoard: Board!
    
    override func didMove(to view: SKView) {
        buildBasicBoard()
        
        // create objects
        var objects: [ChessPiece] = []
        
        // create board
        currentBoard = Board(at: origin, objects: objects)


    }
    
    func buildBasicBoard() {
        var white = true

        tileSize = screenSize.width / 4
        origin = CGPoint(x:-screenSize.width * 0.875, y:-screenSize.height * 0.5)
        currentPoint = origin
        
        
        for rank in 1...8 {
            for file in "abcdefgh" {
                var filename = ""
                if white {
                    filename = "white_tile"
                } else {
                    filename = "black_tile"
                }
                
                let sprite = SKSpriteNode(imageNamed: filename)
                sprite.position = currentPoint
                sprite.size = CGSize(width: tileSize, height: tileSize)
                sprite.zRotation = CGFloat(Double.pi)/2.0 * CGFloat(Double(Int.random(in: 0...3)))
                currentPoint = CGPoint(x: currentPoint.x + tileSize, y: currentPoint.y)
                white = !white
                sprite.name = "\(file)\(rank)"
                self.addChild(sprite)
            }
            
            currentPoint = CGPoint(x: origin.x, y: currentPoint.y + tileSize)
            white = !white
            
            
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        let node = self.atPoint(pos)
        if let name = node.name {
            print("clicked \(name)")
        }
        
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
