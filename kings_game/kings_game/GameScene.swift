//
//  GameScene.swift
//  chessRPG
//
//  Created by Ethan Nerney on 11/17/20.
//  Copyright © 2020 enerney. All rights reserved.
//  all pieces by Gyan Lakhwani from the Noun Project
//  jester by Anton Gajdosik from the Noun Project

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var origin: CGPoint!
    var currentPoint: CGPoint!
    var tileSize: CGFloat!
    
    //Could do [(Faction:Bool)] or store playerFaction(s) to determine if they are player controlled
    var playingFactions : [Faction] = [.WHITE, .BLACK]
    var currentFaction : Faction = .WHITE
    let screenSize: CGRect = UIScreen.main.bounds

    var currentBoard: Board!
    
    var selectedPiece : ChessPiece?
    
    override func didMove(to view: SKView) {
        // create board
        origin = CGPoint(x: -screenSize.width, y: -screenSize.height/2)
        currentBoard = Board(at: origin, objects: [], tileSize: screenSize.width / 4)
        currentBoard.buildBasicBoard()
        //currentBoard.buildWetBoard()
        //currentBoard.buildJesterTesterBoard()
        //currentBoard.buildPillarBoard()
        //currentBoard.buildHolesBoard()
        playingFactions = currentBoard.setTraditionally()
        //playingFactions = currentBoard.setJesters()
        //playingFactions = currentBoard.setJesterTester()
        
        //Add .NEUTRAL to playingFactions to control ent, taking ent will softlock because there is no way for ne
        //currentBoard.addEnt(at: Position(row: 4, col: 4, height: 0))
        
        currentBoard.setPieceSizeAndPosition()
        
        for tile in currentBoard.tiles.values {
            addChild(tile.sprite)
        }
        for obj in currentBoard.allObjects{
            addChild(obj.sprite)
        }
        currentFaction = playingFactions[0]
    }
    
    func pieceSelector(piece: ChessPiece?) -> Bool{
        if piece == nil {
            selectedPiece = nil
            return false
            
        } else if piece!.faction == currentFaction {
            selectedPiece = piece
            currentBoard.tiles[selectedPiece!.coordinates]!.showHighlight(true)
            print("\(piece!.pieceName) chosen.")
            return true
        } else {
            print("Time for \(ChessPiece.factionSprites[currentFaction]!) to act.")
            return false
        }
    }
    
    //Changing currentFaction code
    func incrementTurn(){
        currentFaction = playingFactions[(playingFactions.firstIndex(of: currentFaction)!+1)%playingFactions.count]
        if currentFaction != .WHITE { //TODO: Check some player faction variable instead of white only
            makeRandomMove()
        }
    }
    
    func makeRandomMove() {
        var moved = false
        while !moved { //at the moment it can try to move into allies and be forced to move again rather than never try that at all
            let allMoves = currentBoard.getAllMoves(for: currentBoard.getFactionPieces(for: currentFaction))
            let movingFrom = allMoves.keys.randomElement()!
            let movingTo = (allMoves[movingFrom]?.keys.randomElement())!
            print(movingFrom.col, movingFrom.row)
            print(movingTo.col, movingTo.row)
            moved = currentBoard.movePiece(piece: currentBoard.boardState()[movingFrom] as! ChessPiece, pos: movingTo)
        }
        incrementTurn()
    }
    
    func touchDown(atPoint pos : CGPoint) {
        let node = self.atPoint(pos)
        
        //Get clicked position
        if let selectedPos = currentBoard.getClickedPosition(from: node) {
            if selectedPiece != nil{
                currentBoard.tiles[selectedPiece!.coordinates]!.showHighlight(false)
                //If currentPiece can move to clicked position
                if currentBoard.getOptions(obj: selectedPiece!).keys.contains(selectedPos) {
                    
                    //If move successful (piece not on same team) TODO: Make this include causing check
                    if currentBoard.movePiece(piece: selectedPiece!, pos: selectedPos) {
                        print("Onwards.")
                        incrementTurn()
                        _ = pieceSelector(piece: nil)
                        
                    //Else try changing selectedPiece to clickedPiece
                    } else {
                        print("I have your back.")
                        _ = pieceSelector(piece: currentBoard.boardState()[selectedPos] as? ChessPiece)
                    }
                } else {
                    print("Standing down, sire.")
                    _ = pieceSelector(piece: currentBoard.boardState()[selectedPos] as? ChessPiece)
                }
            } else {
                _ = pieceSelector(piece: currentBoard.boardState()[selectedPos] as? ChessPiece)
            }
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
