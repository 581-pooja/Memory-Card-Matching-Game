//
//  MemoryGameViewModel.swift
//  MemoryCardMatchGame
//
//  Created by Pooja4 Bhagat on 31/05/25.
//
import SwiftUI

// MARK: - MemoryCard Model
struct MemoryCard: Identifiable {
    let id = UUID()                     //  each card a unique identifier
    let imageName: String
    var isFaceUP: Bool = false          // Controls whether the card is showing its image (face-up) or hidden (face-down)
    var isMatched: Bool = false         // Marks whether this card has been successfully matched with its pair
}

// MARK: - ViewModel
class MemoryGameViewModel: ObservableObject {
    @Published var cards: [MemoryCard] = []
    
    private var indexOfFirstFlippedCard: Int?
    
    init() {
        resetGame()
    }
    
    func resetGame() {
        let emojis = ["🍎", "🍌", "🍒", "🍇", "🍋", "🍊", "🍑", "🍐"]
        let pairedEmojis = emojis + emojis
        let shuffled = pairedEmojis.shuffled()
        
        cards = shuffled.map { emoji in
            MemoryCard(imageName: emoji)
        }
        indexOfFirstFlippedCard = nil
    }
    
    func flipCard(at index: Int) {
        guard cards.indices.contains(index),
              !cards[index].isMatched,
              !cards[index].isFaceUP else {
            return
        }
        
        cards[index].isFaceUP = true
        
        if let firstIndex = indexOfFirstFlippedCard {
            if cards[firstIndex].imageName == cards[index].imageName {
                cards[firstIndex].isMatched = true
                cards[index].isMatched = true
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.cards[firstIndex].isFaceUP = false
                    self.cards[index].isFaceUP = false
                }
            }
            indexOfFirstFlippedCard = nil
        } else {
            indexOfFirstFlippedCard = index
        }
    }
}
