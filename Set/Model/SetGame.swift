//
//  SetGame.swift
//  Set
//
//  Created by Tan Nguyen on 9/23/20.
//  Copyright © 2020 Tan Nguyen. All rights reserved.
//

import Foundation
struct SetGame {
    
    private(set) var flipCount = 0
    private(set) var score = 0
    private(set) var numberSets = 0
    
    private(set) var cardsInPlay = [Card]()
    private(set) var cardsSelected = [Card]()
    private(set) var cardsMatched = [Card]()
    private(set) var cardsRemoved = [Card]()
    
    private var deck = Deck()
    var deckCount: Int {return deck.cards.count}
    
    var isSet: Bool? {
        get {
            guard cardsMatched.count == 3 else {return nil}
            return Card.isSet(cards: cardsMatched)
        }
        set {
            if newValue != nil {
                if newValue! {          //cards matchs
                    score += Points.matchBonus
                    numberSets += 1
                } else {               //cards didn't match - Penalize
                    score -= Points.missMatchPenalty
                }
                cardsMatched = cardsSelected
                cardsSelected.removeAll()
            } else {
                cardsMatched.removeAll()
            }
        }
    }
    
   mutating func selectCard(at index: Int) {
        assert(cardsInPlay.indices.contains(index),
               "SetGame.chooseCard(at: \(index)) : Choosen index out of range")
    
        let cardChoosen = cardsInPlay[index]
        if !cardsRemoved.contains(cardChoosen) && !cardsMatched.contains(cardChoosen){
            if  isSet != nil{
                if isSet! { replaceOrRemove3Cards()}
                 isSet = nil
            }
            if cardsSelected.count == 2, !cardsSelected.contains(cardChoosen){
                cardsSelected += [cardChoosen]
                isSet = Card.isSet(cards: cardsSelected)
            } else {
                cardsSelected.inOut(element: cardChoosen)
            }
             flipCount += 1
             score -= Points.deselectionPenalty
        }
    }
    
    private mutating func replaceOrRemove3Cards(){
    //    if let take3Cards =  take3FromDeck() { // less complicated game
        if cardsInPlay.count == Constants.startNumberCards, let take3Cards =  take3FromDeck() {
            cardsInPlay.replace(elements: cardsMatched, with: take3Cards)
        } else {
             cardsInPlay.remove(elements: cardsMatched)
        }
         cardsRemoved += cardsMatched
         cardsMatched.removeAll()
    }
    
    private mutating func take3FromDeck() -> [Card]?{
        var threeCards = [Card]()
        for _ in 0...2 {
            if let card = deck.draw() {
                threeCards += [card]
            } else {
                return nil
            }
        }
        return threeCards
    }
    
    mutating func dealThree() {
        if let deal3Cards =  take3FromDeck() {
            cardsInPlay += deal3Cards
        }
    }
    
    init() {
        for _ in 1...Constants.startNumberCards {
         if let card = deck.draw() {
            cardsInPlay += [card]
            }
        }
    }
 
    private struct Points {
        static let matchBonus = 3
        static let missMatchPenalty = 4
        static var deselectionPenalty = 1
    }
    
    private struct Constants {
        static let startNumberCards = 12
    }
}

extension Array where Element : Equatable {
   mutating func inOut(element: Element){
        if let from = self.index(of:element)  {
            self.remove(at: from)
        } else {
            self.append(element)
        }
    }
    
    mutating func remove(elements: [Element]){
        self = self.filter { !elements.contains($0) }
    }
    
    mutating func replace(elements: [Element], with new: [Element] ){
        guard elements.count == new.count else {return}
        for idx in 0..<new.count {
            if let indexMatched = self.index(of: elements[idx]){
                self [indexMatched ] = new[idx]
            }
        }
    }
    
    func indices(of elements: [Element]) ->[Int]{
        guard self.count >= elements.count, elements.count > 0 else {return []}
        return elements.map{self.index(of: $0)}.compactMap{$0}
    }
}


