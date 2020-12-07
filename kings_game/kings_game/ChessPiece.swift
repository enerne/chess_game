//
//  ChessPiece.swift
//  kings_game
//
//  Created by Nathaniel Youngren on 12/6/20.
//

import SpriteKit
import GameplayKit

class ChessPiece : ChessObject{
    static let factionSprites: [Faction: String] = [.WHITE: "white", .BLACK: "black"]
    static let pieceSprites: [PieceType: String] = [.PAWN: "_pawn", .BISHOP: "_bishop", .KNIGHT: "_knight", .ROOK: "_rook", .QUEEN: "_queen", .KING: "_king"]
    
    let faction : Faction
    //type stored by ObjectPiece
    
    //might need to move to ChessObject!
    let pieceName : String //Spritename generated from faction and type
    var direction : Direction
    
    init(at pos: Position, faction: Faction, type: PieceType) {
        self.faction = faction
        
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
        
        if sprite == nil {
            print(pieceName,"SPRITE FAILED TO INITIALIZE")
        }
    }
    
    
}
