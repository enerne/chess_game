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
    func boardState() -> [Position:ChessObject] {
        let objects = allObjects
        var objDict : [Position:ChessObject] = [:]
        for object in objects{
            if objDict[object.coordinates] == nil {
                objDict[object.coordinates] = (object)
            } else {
                print("MULTIPLE OBJECTS OCCUPYING SAME POSITION!!")
                print(object.info(),"not placed into boardState at",object.coordinates)
            }
        }
        return objDict
    }
    
    func setPieceSizeAndPosition() {
        for obj in allObjects {
            obj.sprite.size = CGSize(width: tileSize, height: tileSize)
            obj.sprite.position = tiles[obj.coordinates]?.sprite.position ?? CGPoint(x: 0, y: 0)
        }
    }
    
    
    
    //------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------
    //                                Piece/Board Setup Funcs
    //------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------
    
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
    
    //------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------
    //                                      Piece/Position Funcs
    //------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------
    
    func getOptions(obj: ChessObject) -> [Position:ChessObject?]{
        var options: [Position:ChessObject?] = [:]
        let pos = obj.coordinates
        var positionOptions : [Position] = []
        switch obj.type {
        case .OBJECT:
            print("Object has no options.")
        case .PAWN:
            if let piece = obj as? ChessPiece {
                positionOptions += testPawn(piece: piece)
            }
        case .BISHOP:
            positionOptions += testBishop(pos: pos)
        case .KNIGHT:
            print("Knights have no horses yet.")
        case .ROOK:
            positionOptions += testRook(pos: pos)
        case .QUEEN:
            positionOptions += testQueen(pos: pos)
        case .KING:
            positionOptions += testKing(pos: pos)
        default:
            print("PieceType not recognized by getOptions.")
        }
        for position in positionOptions{
            options[position] = boardState()[position]
        }
        return options
    }
    
    //Returns all viable tiles in the given direction including first piece
    //TODO: Should this have x-ray and return all pieces so we can adapt it to weird abilities and stuff
    func testDirection(direction: Direction, position: Position, range: Int?) -> [Position] {
        let maxTestingRange = 100
        var validPositions : [Position] = []
        var currentPos = getNewPosition(position, direction, 1)
        let currentBoard = boardState()
        
        while (validPositions.count < range ?? maxTestingRange) && (tiles[currentPos] != nil){
            validPositions.append(currentPos)
            if currentBoard[currentPos] != nil { //If a piece is reached, stop there
                return validPositions
            }
            currentPos = getNewPosition(currentPos, direction, 1)
        }
        return validPositions
    }
    //Rook range
    func testRook(pos: Position) -> [Position] {
        var positionOptions = testDirection(direction: .NORTH, position: pos, range: nil)
        print(positionOptions)
        positionOptions += testDirection(direction: .EAST, position: pos, range: nil)
        positionOptions += testDirection(direction: .SOUTH, position: pos, range: nil)
        positionOptions += testDirection(direction: .WEST, position: pos, range: nil)
        return positionOptions
    }
    //Bishop range
    func testBishop(pos: Position) -> [Position] {
        var positionOptions = testDirection(direction: .NORTHEAST, position: pos, range: nil)
        positionOptions += testDirection(direction: .SOUTHEAST, position: pos, range: nil)
        positionOptions += testDirection(direction: .SOUTHWEST, position: pos, range: nil)
        positionOptions += testDirection(direction: .NORTHWEST, position: pos, range: nil)
        return positionOptions
    }
    //Queen range
    func testQueen(pos: Position) -> [Position] {
        var positionOptions = testDirection(direction: .NORTHEAST, position: pos, range: nil)
        positionOptions += testDirection(direction: .SOUTHEAST, position: pos, range: nil)
        positionOptions += testDirection(direction: .SOUTHWEST, position: pos, range: nil)
        positionOptions += testDirection(direction: .NORTHWEST, position: pos, range: nil)
        positionOptions += testDirection(direction: .NORTH, position: pos, range: nil)
        positionOptions += testDirection(direction: .EAST, position: pos, range: nil)
        positionOptions += testDirection(direction: .SOUTH, position: pos, range: nil)
        positionOptions += testDirection(direction: .WEST, position: pos, range: nil)
        return positionOptions
    }
    //King range
    func testKing(pos: Position) -> [Position] {
        var positionOptions = testDirection(direction: .NORTHEAST, position: pos, range: 1)
        positionOptions += testDirection(direction: .SOUTHEAST, position: pos, range: 1)
        positionOptions += testDirection(direction: .SOUTHWEST, position: pos, range: 1)
        positionOptions += testDirection(direction: .NORTHWEST, position: pos, range: 1)
        positionOptions += testDirection(direction: .NORTH, position: pos, range: 1)
        positionOptions += testDirection(direction: .EAST, position: pos, range: 1)
        positionOptions += testDirection(direction: .SOUTH, position: pos, range: 1)
        positionOptions += testDirection(direction: .WEST, position: pos, range: 1)
        return positionOptions
    }
    //Pawn range -- Takes piece rather than position because pawn is complicated
    func testPawn(piece: ChessPiece) -> [Position] {
        var positionOptions : [Position] = []
        let maxTestingRange = 100
        var currentPos = piece.coordinates
        let currentBoard = boardState()
        
        for dir in getPawnDiagonals(direction: piece.direction){
            let tempPos = getNewPosition(currentPos, dir, 1)
            if let piece = currentBoard[tempPos] as? ChessPiece{
                positionOptions.append(tempPos)
            }
        }
        
        var range = 1
        if !piece.moved {
            range = 2
        }
        
        for i in 1...range{
            let tempPos = getNewPosition(currentPos, piece.direction, 1)
            if currentBoard[tempPos] == nil{
                positionOptions.append(tempPos)
                currentPos = tempPos
            } else {
                return positionOptions
            }
        }
        return positionOptions
    }
    
    func getPawnDiagonals(direction: Direction) -> [Direction]{
        switch direction {
        case .NORTH:
            return [.NORTHEAST,.NORTHWEST]
        case .EAST:
            return [.NORTHEAST,.SOUTHEAST]
        case .SOUTH:
            return [.SOUTHEAST,.SOUTHWEST]
        case .WEST:
            return [.NORTHWEST,.SOUTHWEST]
        default:
            return []
        }
    }
    
    func movePiece(piece: ChessPiece, pos: Position) -> Bool{
        if let takenPiece = boardState()[pos] as? ChessPiece{
            if takenPiece.faction != piece.faction{
                capturePiece(takenPiece)
                piece.moveObject(to: pos, point: (tiles[pos]?.sprite.position)!)
                return true
            } else {
                return false
            }
        }
        piece.moveObject(to: pos, point: (tiles[pos]?.sprite.position)!)
        return true
    }
    //This should probably be more of a scene thing but its not bad here, we should define a 'captured pieces' position and 'move' them there upon being captured maybe?
    func capturePiece(_ piece: ChessPiece){
        print("captured",piece.info())
        piece.captured = true
        piece.coordinates.height -= 1 //TODO: THIS WILL BREAK SHIT IF WE DO HEIGHT STUFF
        piece.sprite.zPosition -= 10 //TODO: REMOVEFROMPARENT IS CLEANER BUT HAS TO BE DONE IN SCENE
    }
    
    //Returns given (position) but moved (distance) tiles towards (direction)
    //TODO: Doesn't account for Z yet
    func getNewPosition(_ position: Position, _ direction: Direction, _ distance: Int) -> Position {
        var currentPos = position
        switch direction {
        case .NORTH:
            currentPos.row += distance
        case .NORTHEAST:
            currentPos.row += distance
            currentPos.col += distance
        case .EAST:
            currentPos.col += distance
        case .SOUTHEAST:
            currentPos.row -= distance
            currentPos.col += distance
        case .SOUTH:
            currentPos.row -= distance
        case .SOUTHWEST:
            currentPos.col -= distance
            currentPos.row -= distance
        case .WEST:
            currentPos.col -= distance
        case .NORTHWEST:
            currentPos.row += distance
            currentPos.col -= distance
        default:
            break
        }
        return currentPos
    }
    //func getThreats() -> [ChessObject] {//Maybe change to chessPiece?
    //}
    
    //Prints information about clicked node, returns it if it is a ChessObject
    func getClickedObject(from node: SKNode) -> ChessObject? {
        for tile in tiles.values {
            if tile.sprite === node {
                print("\(tile.info())")
                return nil
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
    
    //Returns position of clicked node
    func getClickedPosition(from node: SKNode) -> Position? {
        for tile in tiles.values {
            if tile.sprite === node {
                return tile.coordinates
            }
        }
        for piece in allObjects{
            if piece.sprite === node {
                return piece.coordinates
            }
        }
        return nil
    }
}
