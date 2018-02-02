//
//  GameCellCVCell.swift
//  Memory
//
//  Created by Ganna Melnyk on 1/29/18.
//  Copyright © 2018 Ganna Melnyk. All rights reserved.
//

import UIKit

class GameCellCVCell: UICollectionViewCell {
    
    @IBOutlet weak var gameCellImage: UIImageView!
    @IBOutlet weak var topCellImage: UIImageView!
    
    func flipUp(picture: UIImage) {
        UIView.transition(with: self, duration: 0.25, options: .transitionFlipFromRight,
                          animations: {
                            self.topCellImage?.image = picture
                            self.gameCellImage.image = #imageLiteral(resourceName: "whitePaper")
        }, completion: nil)
    }
    
    func flipDown() {
        UIView.transition(with: self,
                          duration: 0.25,
                          options: .transitionFlipFromRight,
                          animations: {
                            self.topCellImage.image = nil
                            self.gameCellImage?.image = #imageLiteral(resourceName: "otherPaper")
        },
                          completion: nil)
    }
    
    func remove() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }) { _ in
            self.isAccessibilityElement = false
        }
    }
}
