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
         WALL
}

class Tile {
    //Maybe remove colorsprites, kinda wack and illogical
    static let colorSprites: [Faction: String] = [.WHITE: "white_", .BLACK: "black_", .NEUTRAL: ""]
    static let tileSprites: [TileTerrain: String] = [.TILE: "tile", .FOREST: "forest", .WATER: "knight", .SAND: "sand", .FIRE: "fire", .WALL: "wall"]
    
    var sprite : SKSpriteNode!
    var coordinates : Position
    var color : Faction? // Maybe remove
    var terrain : TileTerrain
    var tileName : String
    var blocked : Bool
    
    
    init(pos: Position, color: Faction, terrain: TileTerrain){
        self.coordinates = pos
        self.color = color
        self.terrain = terrain
        switch self.terrain {
        case .WALL:
            blocked = true
        default:
            blocked = false
        }
        self.tileName = Tile.colorSprites[color]!+Tile.tileSprites[terrain]!
        
        sprite = SKSpriteNode.init(imageNamed: tileName)
        sprite.name = "\(coordinates.row):\(coordinates.col):\(coordinates.height)"
    }
    
    func info() -> String{
        //Forcing unwrap of name, not needed if becomes problem
        return "\(String(describing: sprite.name!)), row:\(coordinates.row), col:\(coordinates.col), height:\(coordinates.height)"
    }
}
