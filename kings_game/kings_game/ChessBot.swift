//
//  ChessBot.swift
//  kings_game
//
//  Created by Nathaniel Youngren on 12/21/20.
//

import Foundation

class ChessBot {
    var board : Board
    init(for board: Board) {
        self.board = board
    }
    
    //Returns true if move was made, false if stalemate
    func makeRandomMove(for faction: Faction) -> Bool{
        var moved = false
        var allMoves = board.getFactionOptions(for: faction)
        while !moved { // At the moment it can try to move into allies and be forced to move again rather than never try that at all
            let movingFrom = allMoves.keys.randomElement()!
            let movingTo = (allMoves[movingFrom]?.keys.randomElement())!
            print("From (\(movingFrom.col):\(movingFrom.row))")
            print("To (\(movingTo.col):\(movingTo.row))")
            moved = board.movePiece(piece: board.boardState()[movingFrom] as! ChessPiece, pos: movingTo)
            if !moved { // If move was invalid, remove it from the dictionary and try again
                allMoves[movingFrom]?.removeValue(forKey: movingTo)
                if allMoves[movingFrom]?.isEmpty ?? true {
                    allMoves.removeValue(forKey: movingFrom)
                }
                if allMoves.isEmpty {
                    return false //Stalemate!
                }
            }
        }
        return true
    }
}
