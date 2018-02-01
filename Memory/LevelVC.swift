//
//  LevelVC.swift
//  Memory
//
//  Created by Ganna Melnyk on 1/29/18.
//  Copyright © 2018 Ganna Melnyk. All rights reserved.
//

import UIKit

class LevelVC: UIViewController {
    var level = 1
    var levelCounter = 14
    var levels:[String]=[]
    var user: String?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TO DO
        for i in 1...levelCounter {
            levels.append("\(i)")
        }
    }
    
    @IBAction func leaderboardButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "leaderboardSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameSegue" {
            let holder = segue.destination as! GameVC
            holder.cellsAmount = level * 4
            holder.userName = user!
        } else if segue.identifier == "leaderboardSegue" {
            _ = segue.destination as! LeaderboardVC
        }
        
    }
    
}

//
//-------------------------- Cards amount and initial view of the cells ---------------------------
//

extension LevelVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "levelCellId", for: indexPath) as? LevelCellCVCell else {
            fatalError("Wrong cell type dequeued")
        }
        cell.levelCellLabel.text = "level \(levels[indexPath.row])"
        cell.levelCellImage.image = #imageLiteral(resourceName: "paper")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levelCounter
    }
}

//
//--------------------------- Logic of cards numerations -------------------------------
//

extension LevelVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        level = Int(levels[indexPath.row])!
        performSegue(withIdentifier: "gameSegue", sender: self)
    }
   
}

//
//--------------------------------------- Cells size --------------------------------------------
//

extension LevelVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.width
        let side = (screenWidth / 2) - 10
        return CGSize(width: side, height: side)
    }
}

