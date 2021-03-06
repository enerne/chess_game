//
//  ChessPiece.swift
//  kings_game
//
//  Created by Nathaniel Youngren on 12/6/20.
//

import SpriteKit
import GameplayKit

class ChessPiece : ChessObject{
    static let factionSprites: [Faction: String] = [.WHITE: "white_", .BLACK: "black_", .NEUTRAL: ""]
    static let pieceSprites: [PieceType: String] = [.PAWN: "pawn", .BISHOP: "bishop", .KNIGHT: "knight", .ROOK: "rook", .QUEEN: "queen", .KING: "king", .JESTER: "jester", .ENT: "ent"]
    
    //type stored by ObjectPiece
    
    //might need to move to ChessObject!
    let pieceName : String //Spritename generated from faction and type
    var direction : Direction
    var captured = false


    init(at pos: Position, faction: Faction, type: PieceType) {
        
        //hardcoded direction setting
        switch faction {
        case .WHITE:
            direction = .NORTH
        case .BLACK:
            direction = .SOUTH
        default:
            direction = .NONE
        }

        //Should add a default value to this
        pieceName = ChessPiece.factionSprites[faction]!+ChessPiece.pieceSprites[type]!
        super.init(at: pos, imageName: pieceName, type: type)
        
        self.faction = faction

        if sprite == nil {
            print(pieceName,"SPRITE FAILED TO INITIALIZE")
        }
    }
    
    func promote(to pieceType: PieceType) {
        self.type = pieceType
        self.sprite.texture = SKTexture(imageNamed: "\(ChessPiece.factionSprites[faction]!+ChessPiece.pieceSprites[type]!)")
    }
    
    
}
