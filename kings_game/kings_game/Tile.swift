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
    static let colorSprites: [Faction: String] = [.WHITE: "white", .BLACK: "black"]
    static let tileSprites: [TileTerrain: String] = [.TILE: "_tile", .FOREST: "_forest", .WATER: "_knight", .SAND: "_sand", .FIRE: "_fire", .WALL: "_wall"]
    
    var sprite : SKSpriteNode!
    var coordinates : Position
    var color : Faction // Maybe remove
    var terrain : TileTerrain
    var tileName : String
    
    
    init(pos: Position, color: Faction, terrain: TileTerrain){
        self.coordinates = pos
        self.color = color
        self.terrain = terrain
        self.tileName = Tile.colorSprites[color]!+Tile.tileSprites[terrain]!
        
        sprite = SKSpriteNode.init(imageNamed: tileName)
        sprite.name = "\(coordinates.row):\(coordinates.col):\(coordinates.height)"
    }
    
    func info() -> String{
        //Forcing unwrap of name, not needed if becomes problem
        return "\(String(describing: sprite.name!)), row:\(coordinates.row), col:\(coordinates.col), height:\(coordinates.height)"
    }
}
