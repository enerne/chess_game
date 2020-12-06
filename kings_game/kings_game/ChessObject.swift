//
//  ChessObject.swift
//  kings_game
//
//  Created by Nathaniel Youngren on 12/6/20.
//

import SpriteKit
import GameplayKit

struct Position {
    var row = 0
    var col = 0
    // In case we do elevation using this
    var height = 0
}

enum PieceType {
    case PAWN,
    BISHOP,
    KNIGHT,
    ROOK,
    QUEEN,
    KING,
    OBJECT
}

class ChessObject {
    var coordinates = Position()
    var sprite: SKSpriteNode!
    var type = PieceType.OBJECT
    
    init(at pos: Position, imageName: String) {
        self.coordinates = pos
        self.sprite = SKSpriteNode(fileNamed: imageName)
    }
    
    func moveObject(to coord: Position, point: CGPoint) {
        self.coordinates = coord
        self.sprite.run(SKAction.move(to: point, duration: 1))
    }
    
}
