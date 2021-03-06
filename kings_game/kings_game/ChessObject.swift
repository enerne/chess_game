//
//  ChessObject.swift
//  kings_game
//
//  Created by Nathaniel Youngren on 12/6/20.
//

import SpriteKit
import GameplayKit

struct Position : Hashable{
    var col = 0
    var row = 0
    var height = 0
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(col)
        hasher.combine(height)
    }
}

enum Direction {
    case NORTH,
         NORTHEAST,
         EAST,
         SOUTHEAST,
         SOUTH,
         SOUTHWEST,
         WEST,
         NORTHWEST,
         NONE
}

enum PieceType {
    case PAWN,
         BISHOP,
         KNIGHT,
         ROOK,
         JESTER,
         QUEEN,
         KING,
         
         ENT,
         
         OBJECT
         
}

enum Faction {
    case NEUTRAL,
         WHITE,
         BLACK
}

class ChessObject {
    var coordinates = Position()
    var sprite: SKSpriteNode!
    var type : PieceType = PieceType.OBJECT
    var faction : Faction = Faction.NEUTRAL
    var numMoves = 0
    

    //var obstructing = true // Could be used to make objects solid or not (dropped torch vs wall)
    
    init(at pos: Position, imageName: String) {
        self.coordinates = pos
        self.sprite = SKSpriteNode(imageNamed: imageName)
        self.sprite.name = imageName
    }
    
    init(at pos: Position, imageName: String, type: PieceType) {
        self.coordinates = pos
        self.type = type
        self.sprite = SKSpriteNode(imageNamed: imageName)
        self.sprite.name = imageName
    }
    
    func moveObject(to coord: Position, point: CGPoint) {
        self.coordinates = coord
        self.sprite.run(SKAction.move(to: point, duration: 0.5))
        self.numMoves += 1 //TODO: Make sure if moves aren't completed (i.e. would cause check) that this does not trigger regardless
    }
    
    func info() -> String{
        //Forcing unwrap of name, not needed if becomes problem
        return "\(String(describing: sprite.name!)), [\(coordinates.col):\(coordinates.row):\(coordinates.height)]"
    }
}
