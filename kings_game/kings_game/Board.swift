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
    let center : CGPoint

    let columns = 8
    let rows = 8
    
    let tileSize : CGFloat
    var gameTicker = ""
    var moveNumber = 1
    
    var playingFactions : [Faction] = []

    var allObjects : [ChessObject] = []
    var tiles : [Position:Tile] = [:]
    var triggers : [Int:Void]
    
    var capturedObjects = [Faction: [ChessObject]]()
    
    
    init(at center: CGPoint, objects: [ChessObject], tileSize: CGFloat) {
        self.center = center
        self.tileSize = tileSize
        self.allObjects = objects
        self.triggers = [:]
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
    //                                Piece Setup Funcs
    //------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------
    
    //Fill board with normal pieces at normal coordinates
    func setTraditionally(){
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
    //Replace knights with jesters
    func setJesters(){
        allObjects = []
        for col in 1...8 {
            allObjects.append(ChessPiece(at: Position(row: 2, col: col, height: 0), faction: .WHITE, type: .PAWN))
            allObjects.append(ChessPiece(at: Position(row: 7, col: col, height: 0), faction: .BLACK, type: .PAWN))
        }
        allObjects.append(ChessPiece(at: Position(row: 1, col: 3, height: 0), faction: .WHITE, type: .BISHOP))
        allObjects.append(ChessPiece(at: Position(row: 1, col: 6, height: 0), faction: .WHITE, type: .BISHOP))
        allObjects.append(ChessPiece(at: Position(row: 1, col: 1, height: 0), faction: .WHITE, type: .ROOK))
        allObjects.append(ChessPiece(at: Position(row: 1, col: 8, height: 0), faction: .WHITE, type: .ROOK))
        allObjects.append(ChessPiece(at: Position(row: 1, col: 2, height: 0), faction: .WHITE, type: .JESTER))
        allObjects.append(ChessPiece(at: Position(row: 1, col: 7, height: 0), faction: .WHITE, type: .JESTER))
        allObjects.append(ChessPiece(at: Position(row: 1, col: 4, height: 0), faction: .WHITE, type: .QUEEN))
        allObjects.append(ChessPiece(at: Position(row: 1, col: 5, height: 0), faction: .WHITE, type: .KING))
        // ^       ^     |       |
        // | WHITE | - - | BLACK |
        // |       |     v       v
        allObjects.append(ChessPiece(at: Position(row: 8, col: 3, height: 0), faction: .BLACK, type: .BISHOP))
        allObjects.append(ChessPiece(at: Position(row: 8, col: 6, height: 0), faction: .BLACK, type: .BISHOP))
        allObjects.append(ChessPiece(at: Position(row: 8, col: 1, height: 0), faction: .BLACK, type: .ROOK))
        allObjects.append(ChessPiece(at: Position(row: 8, col: 8, height: 0), faction: .BLACK, type: .ROOK))
        allObjects.append(ChessPiece(at: Position(row: 8, col: 2, height: 0), faction: .BLACK, type: .JESTER))
        allObjects.append(ChessPiece(at: Position(row: 8, col: 7, height: 0), faction: .BLACK, type: .JESTER))
        allObjects.append(ChessPiece(at: Position(row: 8, col: 4, height: 0), faction: .BLACK, type: .QUEEN))
        allObjects.append(ChessPiece(at: Position(row: 8, col: 5, height: 0), faction: .BLACK, type: .KING))
    }
    //Board for testing jesters
    func setJesterTester(){
        allObjects.append(ChessPiece(at: Position(row: 5, col: 5, height: 0), faction: .BLACK, type: .JESTER))
        allObjects.append(ChessPiece(at: Position(row: 9, col: 1, height: 0), faction: .WHITE, type: .KNIGHT))
        allObjects.append(ChessPiece(at: Position(row: 9, col: 9, height: 0), faction: .WHITE, type: .KNIGHT))
        allObjects.append(ChessPiece(at: Position(row: 1, col: 9, height: 0), faction: .WHITE, type: .KNIGHT))
        allObjects.append(ChessPiece(at: Position(row: 1, col: 1, height: 0), faction: .WHITE, type: .KNIGHT))
        allObjects.append(ChessPiece(at: Position(row: 9, col: 5, height: 0), faction: .WHITE, type: .KNIGHT))
        allObjects.append(ChessPiece(at: Position(row: 5, col: 9, height: 0), faction: .WHITE, type: .KNIGHT))
        allObjects.append(ChessPiece(at: Position(row: 1, col: 5, height: 0), faction: .WHITE, type: .KNIGHT))
        allObjects.append(ChessPiece(at: Position(row: 5, col: 1, height: 0), faction: .WHITE, type: .KNIGHT))
    }
    //Throws an ent into the mix
    func addEnt(at pos:Position){
        allObjects.append(ChessPiece(at: pos, faction: .NEUTRAL, type: .ENT))
    }
    //------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------
    //                                Board Setup Funcs
    //------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------
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
    func buildJesterTesterBoard() {
        var white = true
        var currentPoint = center
        for rank in 1...9 {
            for file in 1...9 {
                let tile : Tile
                if [[2,3],[2,7],[3,2],[3,4],[3,6],[3,8],[4,3],[4,7],[6,3],[6,7],[7,2],[7,4],[7,6],[7,8],[8,3],[8,7]].contains([rank,file]){
                    tile = Tile(pos: Position(row: rank, col: file, height: 0), color: .NEUTRAL, terrain: .HOLE)

                } else {
                    if white {
                        tile = Tile(pos: Position(row: rank, col: file, height: 0), color: .WHITE, terrain: .TILE)
                    } else {
                        tile = Tile(pos: Position(row: rank, col: file, height: 0), color: .BLACK, terrain: .TILE)
                    }
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
        }
    }
    //Adds random water tiles
    func buildWetBoard() {
        var white = true
        var currentPoint = center
        for rank in 1...8 {
            for file in 1...8 {
                let tile : Tile
                if Int.random(in: 0...3) == 3 {
                    tile = Tile(pos: Position(row: rank, col: file, height: 0), color: .NEUTRAL, terrain: .WATER)
                } else {
                    if white {
                        tile = Tile(pos: Position(row: rank, col: file, height: 0), color: .WHITE, terrain: .TILE)
                    } else {
                        tile = Tile(pos: Position(row: rank, col: file, height: 0), color: .BLACK, terrain: .TILE)
                    }
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
    
    
    func buildPillarBoard() {
        var white = true
        var currentPoint = center
        for rank in 1...8 {
            for file in 1...8 {
                let tile : Tile
                if rank > 3 && rank < 6 && file > 3 && file < 6 {
                    tile = Tile(pos: Position(row: rank, col: file, height: 0), color: .NEUTRAL, terrain: .WALL)
                } else {
                    if white {
                        tile = Tile(pos: Position(row: rank, col: file, height: 0), color: .WHITE, terrain: .TILE)
                    } else {
                        tile = Tile(pos: Position(row: rank, col: file, height: 0), color: .BLACK, terrain: .TILE)
                    }
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
    
    func buildHolesBoard() {
        var white = true
        var currentPoint = center
        for rank in 1...8 {
            for file in 1...8 {
                let tile : Tile
                if [3,6].contains(rank) && [3,6].contains(file) {
                    tile = Tile(pos: Position(row: rank, col: file, height: 0), color: .NEUTRAL, terrain: .HOLE)
                } else {
                    if white {
                        tile = Tile(pos: Position(row: rank, col: file, height: 0), color: .WHITE, terrain: .TILE)
                    } else {
                        tile = Tile(pos: Position(row: rank, col: file, height: 0), color: .BLACK, terrain: .TILE)
                    }
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
    
    func clearTiles() {
        tiles = [:]
    }
    //------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------
    //                                      Piece/Position Funcs
    //------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------
    
    //Returns a dictionary of all positions that the piece can 'move to' (including friendly/enemy squares that can be defended/attacked). Piece logic is in funcs below.
    func getOptions(obj: ChessObject) -> [Position:ChessObject?]{
        var options: [Position:ChessObject?] = [:]
        let pos = obj.coordinates
        var positionOptions : [Position] = []
        switch obj.type {
        case .OBJECT:
            print("Object has no options.")
        case .PAWN:
            if let piece = obj as? ChessPiece { positionOptions += testPawn(piece: piece) }
        case .BISHOP:
            positionOptions += testBishop(pos: pos)
        case .KNIGHT:
            if let piece = obj as? ChessPiece { positionOptions += testKnight(piece: piece) }
        case .ROOK:
            positionOptions += testRook(pos: pos)
        case .JESTER:
            if let piece = obj as? ChessPiece { positionOptions += testJester(piece: piece) }
        case .QUEEN:
            positionOptions += testQueen(pos: pos)
        case .KING:
            if let piece = obj as? ChessPiece { positionOptions += testKing(piece: piece) }
        case .ENT:
            if let piece = obj as? ChessPiece { positionOptions += testKing(piece: piece) }
//        default:
//            print("PieceType not recognized by getOptions.")
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
        var currentPos = translatePosition(position, direction, 1)
        let currentBoard = boardState()
        
        while (validPositions.count < range ?? maxTestingRange){
            if (solidTile(at: currentPos)) || tiles[currentPos] == nil{ //If a piece is reached or the tile is impassable, stop there
                return validPositions
            }
            
            validPositions.append(currentPos)
            
            if currentBoard[currentPos] != nil{ //If a piece is reached or the tile is impassable, stop there
                return validPositions
            }
            currentPos = translatePosition(currentPos, direction, 1)
        }
        return validPositions
    }
    //Rook range
    func testRook(pos: Position) -> [Position] {
        var positionOptions = testDirection(direction: .NORTH, position: pos, range: nil)
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
    func testKing(piece: ChessPiece) -> [Position] {
        let currentPos = piece.coordinates
        let currentBoard = boardState()
        
        var positionOptions = testDirection(direction: .NORTHEAST, position: currentPos, range: 1)
        positionOptions += testDirection(direction: .SOUTHEAST, position: currentPos, range: 1)
        positionOptions += testDirection(direction: .SOUTHWEST, position: currentPos, range: 1)
        positionOptions += testDirection(direction: .NORTHWEST, position: currentPos, range: 1)
        positionOptions += testDirection(direction: .NORTH, position: currentPos, range: 1)
        positionOptions += testDirection(direction: .EAST, position: currentPos, range: 1)
        positionOptions += testDirection(direction: .SOUTH, position: currentPos, range: 1)
        positionOptions += testDirection(direction: .WEST, position: currentPos, range: 1)
        
        if piece.numMoves == 0{
            for dir in [Direction.NORTH, .EAST, .SOUTH, .WEST]{
                let castles = testDirection(direction: dir, position: currentPos, range: nil)
                for opt in castles {
                    if let piece = currentBoard[opt] as? ChessPiece{
                        if piece.type == .ROOK && piece.numMoves == 0{
                            positionOptions += [translatePosition(currentPos, dir, 2)]
                            //NEED TO ATTACH ROOK MOVEMENT TO THIS
                        }
                    }
                }
            }
        }
        return positionOptions
    }
    //Pawn range -- Takes piece rather than position because pawn is complicated
    func testPawn(piece: ChessPiece) -> [Position] {
        var positionOptions : [Position] = []
        var currentPos = piece.coordinates
        let currentBoard = boardState()
        
        //Check for diagonal attacks
        for dir in getPawnPeripheral(direction: piece.direction){
            let tempPos = translatePosition(currentPos, dir, 1)
            if (currentBoard[tempPos] as? ChessPiece) != nil && !solidTile(at: tempPos){
                positionOptions.append(tempPos)
            }
        }
        
//        //Check for en passant
//        for dir in getPawnHorizontals(direction: piece.direction){
//            let tempPos = translatePosition(currentPos, dir, 1)
//            if (currentBoard[tempPos] as! ChessPiece) && !solidTile(at: tempPos){
//                positionOptions.append(tempPos)
//            }
//        }

        var range = 1
        if piece.numMoves == 0 {
            range = 2
        }
        
        //Check for open forward spaces
        for _ in 1...range{
            let tempPos = translatePosition(currentPos, piece.direction, 1)
            if currentBoard[tempPos] == nil && !solidTile(at: tempPos) {
                positionOptions.append(tempPos)
                currentPos = tempPos
            } else {
                return positionOptions
            }
        }
        return positionOptions
    }
    //Knight range
    func testKnight(piece: ChessPiece) -> [Position] {
        var positionOptions : [Position] = []
        let currentPos = piece.coordinates
        
        for disp in [[1,2],[1,-2],[-1,2],[-1,-2],[2,1],[2,-1],[-2,1],[-2,-1]]{
            let tempPos = displacePosition(currentPos, row: disp[0], col: disp[1], height: 0)
            if !solidTile(at: tempPos) {
                positionOptions.append(tempPos)
            }
        }
        
        return positionOptions
    }
    //Jester
    func testJester(piece: ChessPiece) -> [Position] {
        var positionOptions : [Position] = []
        let currentPos = piece.coordinates
        
        if piece.numMoves % 2 == 0 {
            positionOptions += testBishop(pos: currentPos)
        } else {
            positionOptions += testRook(pos: currentPos)
        }
        return positionOptions
    }
    
    func getPawnPeripheral(direction: Direction) -> [Direction]{
        switch direction {
        case .NORTH:
            return [.NORTHEAST, .NORTHWEST]
        case .EAST:
            return [.NORTHEAST, .SOUTHEAST]
        case .SOUTH:
            return [.SOUTHEAST, .SOUTHWEST]
        case .WEST:
            return [.NORTHWEST, .SOUTHWEST]
        default:
            return []
        }
    }
    
    func getPawnLateral(direction: Direction) -> [Direction]{
        switch direction {
        case .NORTH:
            return [.EAST, .WEST]
        case .EAST:
            return [.NORTH, .SOUTH]
        case .SOUTH:
            return [.EAST, .WEST]
        case .WEST:
            return [.NORTH, .SOUTH]
        default:
            return []
        }
    }
    
    func movePiece(piece: ChessPiece, pos: Position) -> Bool{
        tiles[piece.coordinates]?.showHighlight(false)

        if let takenPiece = boardState()[pos] as? ChessPiece{
            if takenPiece.faction != piece.faction{
                gameTicker.append("\(moveNumber). \(piece.pieceName) X [\(pos.col):\(pos.row):\(pos.height)]\n")
                moveNumber += 1
                capturePiece(takenPiece, by: piece.faction)
                piece.moveObject(to: pos, point: (tiles[pos]?.sprite.position)!)
                if piece.type == .PAWN && tiles[translatePosition(piece.coordinates, piece.direction, 1)] == nil{
                    piece.promote(to: .QUEEN)
                }

                return true
            } else {
                return false
            }
        }
        gameTicker.append("\(moveNumber). \(piece.pieceName) [\(pos.col):\(pos.row):\(pos.height)]\n")
        moveNumber += 1
        piece.moveObject(to: pos, point: (tiles[pos]?.sprite.position)!)
        
        if piece.type == .PAWN && tiles[translatePosition(piece.coordinates, piece.direction, 1)] == nil{
            piece.promote(to: .QUEEN)
        }
        
        return true
    }
    
    func capturePiece(_ piece: ChessPiece, by faction: Faction){
        print("Captured",piece.info())
        if piece.type == .KING{
            print(gameTicker)
        }
        piece.captured = true
        
        // add to capturedObjects
        if let _ = capturedObjects[faction] {
            capturedObjects[faction]!.append(piece)
        } else {
            capturedObjects[faction] = [piece]
        }
        
        // get piece's index in allObjects
        var i = 0
        for p in allObjects {
            if p === piece {
                break
            }
            i+=1
        }
        // remove from all objects
        allObjects.remove(at: i)
        // remove sprite from parent
        piece.sprite.removeFromParent()
        
//        print(capturedObjects)
        
    }
    
    //True if false should allow pieces to move through it, true if solid
    func solidTile(at pos: Position) -> Bool {
        if tiles[pos]?.blocked ?? true {
            return true
        }
        return false
    }
    
    //Returns given (position) but moved (distance) tiles towards (direction)
    //TODO: Doesn't account for Z yet
    func translatePosition(_ position: Position, _ direction: Direction, _ distance: Int) -> Position {
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
    
    func displacePosition(_ position: Position, row: Int, col: Int, height: Int) -> Position {
        var pos = position
        pos.row += row
        pos.col += col
        pos.height += height
        return pos
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
    
    //return all pieces of current faction
    func getFactionPieces(for faction: Faction) -> [ChessPiece]{
        var pieces : [ChessPiece] = []
        for obj in allObjects{
            if let piece = obj as? ChessPiece {
                if piece.faction == faction {
                    pieces.append(piece)
                }
            }
        }
        return pieces
    }
    
    // returning [ChessPiece:[Position]] makes more sense but it isnt hashable yet
    func getAllOptions(for pieces: [ChessPiece]) -> [Position:[Position:ChessObject?]]{
        var allOptions : [Position:[Position:ChessObject?]] = [:] //position of piece -> positions it could move to (and optionally the piece there)
        for piece in pieces {
            let options = getOptions(obj: piece)
            if !options.isEmpty {
                allOptions[piece.coordinates] = options
            }
        }
        return allOptions
    }
    
    func getFactionOptions(for faction: Faction) -> [Position:[Position:ChessObject?]] {
        return getAllOptions(for: getFactionPieces(for: faction))
    }
    
    //TODO: Currently can fuck up and softlock if the only viable move is to move into an ally square!!!!
    func updatePlayingFactions(){
        var factions : [Faction] = []
        for obj in allObjects {
            if let piece = obj as? ChessPiece {
                if !factions.contains(piece.faction) && !getFactionOptions(for: piece.faction).isEmpty {
                    factions.append(piece.faction)
                }
            }
        }
        playingFactions = factions
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
    
    func clearHighlights() {
        for tile in tiles.values {
            tile.showHighlight(false)
        }
    }
}
