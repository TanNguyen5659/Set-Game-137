//
//  SetCardButton.swift
//  Set
//
//  Created by Tan Nguyen on 9/23/20.
//  Copyright © 2020 Tan Nguyen. All rights reserved.
//

import UIKit

@IBDesignable class SetCardButton: BorderButton {
   
    var colors = [#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)]
    var alphas:[CGFloat] = [1.0, 0.40, 0.15]
    var strokeWidths:[CGFloat] = [ -8, 8, -8]
    var symbols = ["●", "▲", "■"]
    
    var setCard: Card? = Card(number: Card.Variant.v3,
                                    color: Card.Variant.v3,
                                    shape: Card.Variant.v3,
                                    fill: Card.Variant.v3)
        { didSet{updateButton()}}
    
    private func setAttributedString(card: Card) -> NSAttributedString{
        let symbol = symbols [card.shape.idx]
        let separator = verticalSizeClass == .regular ? "\n" : " "
        let symbolsString = symbol.join(n: card.number.rawValue, with: separator)
       
        let attributes:[NSAttributedString.Key : Any] = [
            .strokeColor: colors[card.color.idx],
            .strokeWidth: strokeWidths[card.fill.idx],
            .foregroundColor: colors[card.color.idx].withAlphaComponent(alphas[card.fill.idx])
        ]
        return NSAttributedString(string: symbolsString, attributes: attributes)
    }
    
    //Update button 
    private func updateButton () {
        if let card = setCard {
            let attributedString  = setAttributedString(card: card)
            setAttributedTitle(attributedString, for: .normal)
            backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            isEnabled = true
        } else {
            setAttributedTitle(nil, for: .normal)
            setTitle(nil, for: .normal)
            backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
            borderColor =   #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            isEnabled = false
        }
    }
    
    private var verticalSizeClass: UIUserInterfaceSizeClass {return
        UIScreen.main.traitCollection.verticalSizeClass}
    
    func setBorderColor (color: UIColor) {
        borderColor =  color
        borderWidth = Constants.borderWidth
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateButton()
    }
    
    private func configure () {
        cornerRadius = Constants.cornerRadius
        titleLabel?.numberOfLines = 0
        borderColor =   Constants.borderColor
        borderWidth = -Constants.borderWidth
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 8.0
        static let borderWidth: CGFloat = 3.0
        static let borderColor: UIColor   = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
}

extension String {
    func join(n: Int, with separator:String )-> String{
        guard n > 1 else {return self}
        var symbols = [String] ()
        for _ in 0..<n {
            symbols += [self]
        }
        return symbols.joined(separator: separator)
    }
}

