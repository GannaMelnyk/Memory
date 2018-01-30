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
                            //self.backgroundColor = #colorLiteral(red: 0.4097257559, green: 0.8868979159, blue: 1, alpha: 1)
        }, completion: nil)
    }
    
    func flipDown() {
        UIView.transition(with: self,
                          duration: 0.25,
                          options: .transitionFlipFromRight,
                          animations: {
                            self.topCellImage.image = nil
                            self.gameCellImage?.image = #imageLiteral(resourceName: "otherPaper")
                           // self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        },
                          completion: nil)
    }
    
    func remove() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }) { _ in
            // self.removeFromSuperview()
            self.isAccessibilityElement = false
        }
    }
}
