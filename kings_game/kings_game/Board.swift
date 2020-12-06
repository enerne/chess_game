//
//  Board.swift
//  kings_game
//
//  Created by Nathaniel Youngren on 12/6/20.
//

//needed
//import pog

import SpriteKit
import GameplayKit

class Board {
    let columns = 8
    let rows = 8
    
    let center : CGPoint
    var allObjects : [ChessObject]
    
    init(at center: CGPoint, objects: [ChessObject]) {
        self.center = center
        self.allObjects = objects
    }
    
    func boardState() -> [Position:ChessObject]{
        let objects = allObjects
        var objDict : [Position:ChessObject] = [:]
        for object in objects{
            if objDict[object.coordinates] != nil {
                print(object.type,"not placed, occupying duplicate square.")
            }
            objDict[object.coordinates] = object
        }
        return objDict
    }
    
    func setTraditionally(){
        allObjects = []
        for col in 1...8{
            allObjects.append(ChessPiece(at: Position(row: 2, col: col, height: 0), faction: .WHITE, type: .PAWN))
        }
    }
}
