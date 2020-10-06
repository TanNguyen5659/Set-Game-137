//
//  ViewController.swift
//  Set
//
//  Created by Tan Nguyen on 9/23/20.
//  Copyright © 2020 Tan Nguyen. All rights reserved.
//


import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad ()
        updateViewFromModel()
    }
    
    var game = SetGame()
    var colors = [#colorLiteral(red: 1, green: 0.4163245823, blue: 0, alpha: 1), #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1), #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)]
    var strokeWidths:[CGFloat] = [ -10, 10, -10]
    var alphas:[CGFloat] = [1.0, 0.60, 0.15]
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var deckCountLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet var cardButtons: [SetCardButton]! {
        didSet {
            for button in cardButtons
            {
                button.strokeWidths = strokeWidths
                button.colors = colors
                button.alphas = alphas
            }
        }
    }
    
    @IBOutlet weak var dealButton: BorderButton!
    @IBOutlet weak var newButton: BorderButton!
    
    //newGame function, reload cards and start new game
    @IBAction func touchNewGame() {
        game = SetGame()
        cardButtons.forEach { $0.setCard = nil }
        updateViewFromModel()
    }
    
    //deal3 function, draw 3 more cards
    @IBAction func dealThreeCards() {
        if game.cardsInPlay.count <= 24 {
            game.dealThree()
            updateViewFromModel()
        }
    }
    
    
    @IBAction func touchCard(_ sender: SetCardButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.selectCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Choose card within cardbutton")
        }
    }
    
    private func updateViewFromModel() {
        updateButtonsFromModel()
        deckCountLabel.text = "Deck: \(game.deckCount )"
        scoreLabel.text = "Score: \(game.score) "
        
        dealButton.disable = (game.cardsInPlay.count) >= cardButtons.count
            || game.deckCount == 0
    }
    
    
    private func updateButtonsFromModel() {
        messageLabel.text = ""
        for index in cardButtons.indices {
            let button = cardButtons[index]
            if index < game.cardsInPlay.count {
                let card = game.cardsInPlay[index] 
                button.setCard = card
                button.setBorderColor(color:
                    game.cardsSelected.contains(card) ? Colors.selected : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))
                
                if let itIsSet = game.isSet {
                    if game.cardsMatched.contains(card) {
                        button.setBorderColor(color:
                            itIsSet ? Colors.matched: Colors.misMatched)
                    }
                    messageLabel.text = itIsSet ? "Correct set" :"Not a set"
                }
                
            } else {
                button.setCard = nil
            }
        }
    }
    
}

extension ViewController {
    
    private struct Colors {
        static let selected = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        static let matched = #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)
        static var misMatched = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}


