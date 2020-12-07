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
    var tiles : [Position:Tile] = [:]
    
    init(at center: CGPoint, objects: [ChessObject], tileSize: CGFloat) {
        self.center = center
        self.tileSize = tileSize
        self.allObjects = objects
    }
    
    //Return dictionary of positions to lists of objects
    func boardState() -> [Position:[ChessObject]] {
        let objects = allObjects
        var objDict : [Position:[ChessObject]] = [:]
        for object in objects{
            if objDict[object.coordinates] != nil {
                objDict[object.coordinates]?.append(object)
            } else {
                objDict[object.coordinates] = [object]
            }
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
                let tile : Tile
                if white {
                    tile = Tile(pos: Position(row: rank, col: file, height: 0), color: .WHITE, terrain: .TILE)
                } else {
                    tile = Tile(pos: Position(row: rank, col: file, height: 0), color: .BLACK, terrain: .TILE)
                }
                
                tile.sprite.position = currentPoint
                tile.sprite.size = CGSize(width: tileSize, height: tileSize)
                tile.sprite.zRotation = CGFloat(Double.pi)/2.0 * CGFloat(Double(Int.random(in: 0...3)))
                tile.sprite.zPosition = -1

                currentPoint = CGPoint(x: currentPoint.x + tileSize, y: currentPoint.y)
                white = !white
                tiles[Position(row: rank, col: file, height: 0)] = tile
            }
            currentPoint = CGPoint(x: center.x, y: currentPoint.y + tileSize)
            white = !white
        }
    }
    
    //Returns all viable tiles in the given direction including first piece
    //TODO: Should this have x-ray and return all pieces so we can adapt it to weird abilities and stuff
    func testDirection(direction: Direction, object: ChessPiece, range: Int?) -> [Position:[ChessObject]?] {
        let maxTestingRange = 100
        var validPositions : [Position:[ChessObject]?] = [:]
        var currentPos = getNewPosition(object.coordinates, direction, 1)
        
        while (validPositions.count < range ?? maxTestingRange) && (tiles[currentPos] != nil) {
            validPositions[currentPos] = boardState()[currentPos]
            currentPos = getNewPosition(currentPos, direction, 1)
        }
        return validPositions
    }
    
    
    //Returns given (position) but moved (distance) tiles towards (direction)
    //TODO: Doesn't account for Z yet
    func getNewPosition(_ position: Position, _ direction: Direction, _ distance: Int) -> Position {
        var currentPos = position
        switch direction {
        case .NORTH:
            currentPos.col += distance
        case .NORTHEAST:
            currentPos.col += distance
            currentPos.row += distance
        case .EAST:
            currentPos.row += distance
        case .SOUTHEAST:
            currentPos.col -= distance
            currentPos.row += distance
        case .SOUTH:
            currentPos.col -= distance
        case .SOUTHWEST:
            currentPos.col -= distance
            currentPos.row -= distance
        case .WEST:
            currentPos.row -= distance
        case .NORTHWEST:
            currentPos.col += distance
            currentPos.row -= distance
        default:
            break
        }
        return currentPos
    }
    
    
    //func getThreats() -> [ChessObject] {//Maybe change to chessPiece?
    //}
    
    
    func clickedNode(from node: SKNode) -> ChessObject? {
        for tile in tiles.values {
            if tile.sprite === node {
                print("\(tile.info())")
            }
        }
        for piece in allObjects{
            if piece.sprite === node {
                print("\(piece.info())")
                return piece
            }
        }
        return nil
    }
    
    func getOptions(obj: ChessObject) -> [Tile]{
        var options: [Tile] = []
        switch obj.type {
        case .OBJECT:
            print("Object has no options.")
        case .PAWN:
            break
        default:
            print("PieceType not recognized by getOptions.")
        }
        return options
    }
    
    func setPieceSizeAndPosition() {
        for obj in allObjects {
            obj.sprite.size = CGSize(width: tileSize, height: tileSize)
            obj.sprite.position = tiles[obj.coordinates]?.sprite.position ?? CGPoint(x: 0, y: 0)
        }
    }
}
