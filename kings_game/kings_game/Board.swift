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
    
    let tileSize : CGFloat
    
    let center : CGPoint
    var allObjects : [ChessObject] = []
    var tiles : [Position:SKSpriteNode] = [:]
    
    init(at center: CGPoint, objects: [ChessObject], tileSize: CGFloat) {
        self.center = center
        self.tileSize = tileSize
        self.allObjects = objects
    }
    
    //Return dictionary of positions to objects
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
    
    //Fill board with normal pieces at normal coordinates
    func setTraditionally() {
        allObjects = []
        for col in 1...8 {
            allObjects.append(ChessPiece(at: Position(row: 2, col: col, height: 0), faction: .WHITE, type: .PAWN))
            allObjects.append(ChessPiece(at: Position(row: 7, col: col, height: 0), faction: .BLACK, type: .PAWN))
        }
        allObjects.append(ChessPiece(at: Position(row: 1, col: 3, height: 0), faction: .WHITE, type: .BISHOP))
        allObjects.append(ChessPiece(at: Position(row: 1, col: 6, height: 0), faction: .WHITE, type: .BISHOP))
        allObjects.append(ChessPiece(at: Position(row: 1, col: 1, height: 0), faction: .WHITE, type: .ROOK))
        allObjects.append(ChessPiece(at: Position(row: 1, col: 8, height: 0), faction: .WHITE, type: .ROOK))
        allObjects.append(ChessPiece(at: Position(row: 1, col: 2, height: 0), faction: .WHITE, type: .KNIGHT))
        allObjects.append(ChessPiece(at: Position(row: 1, col: 7, height: 0), faction: .WHITE, type: .KNIGHT))
        allObjects.append(ChessPiece(at: Position(row: 1, col: 4, height: 0), faction: .WHITE, type: .QUEEN))
        allObjects.append(ChessPiece(at: Position(row: 1, col: 5, height: 0), faction: .WHITE, type: .KING))
        // ^       ^     |       |
        // | WHITE | - - | BLACK |
        // |       |     v       v
        allObjects.append(ChessPiece(at: Position(row: 8, col: 3, height: 0), faction: .BLACK, type: .BISHOP))
        allObjects.append(ChessPiece(at: Position(row: 8, col: 6, height: 0), faction: .BLACK, type: .BISHOP))
        allObjects.append(ChessPiece(at: Position(row: 8, col: 1, height: 0), faction: .BLACK, type: .ROOK))
        allObjects.append(ChessPiece(at: Position(row: 8, col: 8, height: 0), faction: .BLACK, type: .ROOK))
        allObjects.append(ChessPiece(at: Position(row: 8, col: 2, height: 0), faction: .BLACK, type: .KNIGHT))
        allObjects.append(ChessPiece(at: Position(row: 8, col: 7, height: 0), faction: .BLACK, type: .KNIGHT))
        allObjects.append(ChessPiece(at: Position(row: 8, col: 4, height: 0), faction: .BLACK, type: .QUEEN))
        allObjects.append(ChessPiece(at: Position(row: 8, col: 5, height: 0), faction: .BLACK, type: .KING))
    }
    
    func buildBasicBoard() {
        var white = true

        var currentPoint = center
        
        
        for rank in 1...8 {
            for file in 1...8 {
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
                sprite.name = "\(file):\(rank)"
                tiles[Position(row: rank, col: file, height: 0)] = sprite
                sprite.zPosition = -1
            }
            
            currentPoint = CGPoint(x: center.x, y: currentPoint.y + tileSize)
            white = !white
            
            
        }
    }
    
    func setPieceSizeAndPosition() {
        for obj in allObjects {
            print(obj.coordinates)
            obj.sprite.size = CGSize(width: tileSize, height: tileSize)
            obj.sprite.position = tiles[obj.coordinates]?.position ?? CGPoint(x: 0, y: 0)
        }
    }
}
