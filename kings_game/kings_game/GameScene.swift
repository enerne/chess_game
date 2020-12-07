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
    var playingFactions : [Faction] = [.WHITE,.BLACK]
    var currentFaction : Faction = .WHITE
    let screenSize: CGRect = UIScreen.main.bounds
    
    let factionSprites: [Faction: String] = [.WHITE: "white", .BLACK: "black"]
    let pieceSprites: [PieceType: String] = [.PAWN: "_pawn", .BISHOP: "_bishop", .KNIGHT: "_knight", .ROOK: "_rook", .QUEEN: "_queen", .KING: "_king"]

    var currentBoard: Board!
    
    var selectedPiece : ChessPiece?
    
    override func didMove(to view: SKView) {
        
        // create board
        origin = CGPoint(x: -screenSize.width, y: -screenSize.height/2)
        currentBoard = Board(at: origin, objects: [], tileSize: screenSize.width / 4)
        //currentBoard.buildBasicBoard()
        currentBoard.buildPitBoard()
        currentBoard.setTraditionally()
        currentBoard.setPieceSizeAndPosition()
        
        for tile in currentBoard.tiles.values {
            addChild(tile.sprite)
        }
        for obj in currentBoard.allObjects{
            addChild(obj.sprite)
        }
    }
    
    func pieceSelector(piece: ChessPiece?) -> Bool{

        if piece == nil {
            selectedPiece = nil
            return false
        } else if piece!.faction == currentFaction {
            
            selectedPiece = piece
            currentBoard.tiles[selectedPiece!.coordinates]!.showHighlight(true)
            return true
        }
        
        print("Time for \(factionSprites[currentFaction]!) to act.")
        return false
    }
    
    //Changing currentFaction code
    func incrementTurn(){
        currentFaction = playingFactions[(playingFactions.firstIndex(of: currentFaction)!+1)%playingFactions.count]
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
                    } else if let piece = currentBoard.boardState()[selectedPos] as? ChessPiece {
                        if pieceSelector(piece: piece) {
                            print("Let \(piece.pieceName) take his place.")
                        }
                        
                    } else {
                        print("Let me take his place.")
                        _ = pieceSelector(piece: nil)
                    }
                } else {
                    print("Standing down, sire.")
                    _ = pieceSelector(piece: currentBoard.boardState()[selectedPos] as? ChessPiece)
                }
            } else {
                if let piece = currentBoard.boardState()[selectedPos] as? ChessPiece {
                    if pieceSelector(piece: piece) {
                        print("\(piece.pieceName) chosen.")
                    }
                }
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
