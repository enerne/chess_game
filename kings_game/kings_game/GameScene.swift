//
//  GameScene.swift
//  chessRPG
//
//  Created by Ethan Nerney on 11/17/20.
//  Copyright © 2020 enerney. All rights reserved.
//  all pieces by Gyan Lakhwani from the Noun Project

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
    
    func pieceSelector(piece: ChessPiece) -> Bool{
        if piece.faction == currentFaction{
            selectedPiece = piece
            return true
        }
        print()
        return false
    }
    
    func touchDown(atPoint pos : CGPoint) {
        let node = self.atPoint(pos)
        
        //Get clicked position
        if let selectedPos = currentBoard.getClickedPosition(from: node) {
            if selectedPiece != nil{
                //If currentPiece can move to clicked position
                if currentBoard.getOptions(obj: selectedPiece!).keys.contains(selectedPos) {
                    
                    //If move successful (piece not on same team) TODO: Make this include causing check
                    if currentBoard.movePiece(piece: selectedPiece!, pos: selectedPos) {
                        print("Onwards.")
                        selectedPiece = nil
                        
                    //Else try changing selectedPiece to clickedPiece
                    } else if let piece = currentBoard.boardState()[selectedPos] as? ChessPiece {
                        if pieceSelector(piece: piece) {
                            print("Let \(piece.pieceName) take his place.")
                        }
                        
                    } else {
                        print("Let me take his place.")
                        selectedPiece = nil
                    }
                } else if let piece = currentBoard.boardState()[selectedPos] as? ChessPiece {
                    selectedPiece = piece
                    print("\(piece.pieceName) chosen.")
                } else {
                    print("Standing down, sire.")
                    selectedPiece = nil
                }
            } else {
                if let piece = currentBoard.boardState()[selectedPos] as? ChessPiece {
                    selectedPiece = piece
                    print("\(piece.pieceName) chosen.")
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
