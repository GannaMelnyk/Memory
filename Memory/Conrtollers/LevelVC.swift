//
//  LevelVC.swift
//  Memory
//
//  Created by Ganna Melnyk on 1/29/18.
//  Copyright © 2018 Ganna Melnyk. All rights reserved.
//

import UIKit
import CoreData

class LevelVC: UIViewController {
    var level = 1
    var resolvedLevel = 1
    var levelCounter = 12
    var levels:[String]=[]
    var user: String?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1...levelCounter {
            levels.append("\(i)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
        let writeLevelController = CoreManager.instance.fetchedResultsController(entityName: "Users", keyForSort: "user", ascending: true)
        do {
            try writeLevelController.performFetch()
        } catch {
            print(error)
        }
        
        let usersFromDB = writeLevelController.fetchedObjects as! [Users]
        for userFromDB in usersFromDB {
            let actualName = userFromDB.user
            if actualName == user {
                resolvedLevel = Int(userFromDB.level)
            }
        }
        collectionView.reloadData()
        
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
        if indexPath.row < resolvedLevel{
            cell.levelCellImage.image = #imageLiteral(resourceName: "paper")
            cell.isUserInteractionEnabled = true
            } else {
            cell.levelCellImage.image = #imageLiteral(resourceName: "back")
            cell.isUserInteractionEnabled = false
            }
        
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
        let side = (screenWidth / 3) - 10
        return CGSize(width: side, height: side)
    }
}

