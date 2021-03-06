//
//  Tile.swift
//  kings_game
//
//  Created by Nathaniel Youngren on 12/6/20.
//

import SpriteKit
import GameplayKit

enum TileTerrain { // Only TILE currently implemented, others are placeholder
    case TILE,
         FOREST,
         WATER,
         SAND,
         FIRE,
         WALL,
         BRIDGE,
         RAMP,
         HOLE
}

class Tile {
    //Maybe remove colorsprites, kinda wack and illogical
    static let colorSprites: [Faction: String] = [.WHITE: "white_", .BLACK: "black_", .NEUTRAL: ""]
    static let tileSprites: [TileTerrain: String] = [.TILE: "tile", .FOREST: "forest", .WATER: "water", .SAND: "sand", .FIRE: "fire", .WALL: "wall", .HOLE: "hole", .RAMP: "stair_tile"]
    
    var sprite : SKSpriteNode!
    var coordinates : Position
    var color : Faction? // Maybe remove
    var direction: Direction?
    var terrain : TileTerrain
    var tileName : String
    var blocked : Bool
    
    var highlight: SKSpriteNode!
    
    init(pos: Position, color: Faction, terrain: TileTerrain){
        self.coordinates = pos
        self.color = color
        self.terrain = terrain
        switch self.terrain {
        case .WALL:
            blocked = true
        case .HOLE:
            blocked = true
        default:
            blocked = false
        }
        self.tileName = Tile.colorSprites[color]!+Tile.tileSprites[terrain]!
        
        sprite = SKSpriteNode.init(imageNamed: tileName)
        sprite.name = "\(coordinates.row):\(coordinates.col):\(coordinates.height)"
        
//        if color == .WHITE {
            highlight = SKSpriteNode(color: UIColor(cgColor: CGColor(red: 1.0, green: 0.0, blue: 0.00, alpha: 0.50)), size: sprite.size)
//
//        } else {
//            highlight = SKSpriteNode(color: UIColor(cgColor: CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.35)), size: sprite.size)
//        }
        highlight.position = sprite.position
        highlight.zPosition = sprite.zPosition + 1
    }
    
    func info() -> String{
        //Forcing unwrap of name, not needed if becomes problem
        return "\(String(describing: sprite.name!)), [\(coordinates.col):\(coordinates.row):\(coordinates.height)]."
    }
    
    func showHighlight(_ b: Bool) {
        if b {
            if highlight.parent == nil {
                sprite.addChild(highlight)
            }
        } else {
            highlight.removeFromParent()
        }
    }
}
