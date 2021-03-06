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
    
    let levelCounter = 12
    let cellMargins: CGFloat = 10
    let cellsCoefficient = 4
    let levelsInRow: CGFloat =  3
    
    var level = 1
    var resolvedLevel = 1
    var levels: [String]=[]
    var user: String?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func leaderboardButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "leaderboardSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "launchScreen"))
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = #imageLiteral(resourceName: "launchScreen")
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
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
        guard let usersFromDB = writeLevelController.fetchedObjects as? [Users] else {
            fatalError("wrong fetch request to DB")
        }
        for userFromDB in usersFromDB {
            let actualName = userFromDB.user
            if actualName == user {
                resolvedLevel = Int(userFromDB.level)
            }
        }
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameSegue" {
            guard let holder = segue.destination as? GameVC else {
                fatalError("cannot cast value to GameVC")
            }
            holder.cellsAmount = level * cellsCoefficient
            holder.userName = user ?? "wrong user"
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
        level = Int(levels[indexPath.row]) ?? 0
        performSegue(withIdentifier: "gameSegue", sender: self)
    }
}

//
//--------------------------------------- Cells size --------------------------------------------
//

extension LevelVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.width
        let side = (screenWidth / levelsInRow) - cellMargins
        return CGSize(width: side, height: side)
    }
}
