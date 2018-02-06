//
//  WrittingResultsController.swift
//  Memory
//
//  Created by Ganna Melnyk on 1/30/18.
//  Copyright © 2018 Ganna Melnyk. All rights reserved.
//

import UIKit
import CoreData

class WrittingResultsVC: UIViewController {
    
    let heightForRowInTable: CGFloat = 25
    let cornerRadius: CGFloat = 10
    let masksToBounds = true
    
    var score = 0
    var cellsAmount = 0
    var userName = ""
    var date: Date?
    var timerInSeconds = 0
    var userResult: Scores?
    var fetchedResultsController = CoreManager.instance.fetchedResultsController(entityName: "Scores", keyForSort: "gameDate", ascending: false)
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .clear
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "launchScreen"))
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = #imageLiteral(resourceName: "launchScreen")
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        
        self.navigationItem.hidesBackButton = true
        let newButton = UIBarButtonItem(title: "return to levels", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.returnToLevels))
        self.navigationItem.leftBarButtonItem = newButton
        saveObj(userName)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        
        let writeLevelController = CoreManager.instance.fetchedResultsController(entityName: "Users", keyForSort: "user", ascending: true)

        do {
            try writeLevelController.performFetch()
        } catch {
            print(error)
        }
        let usersFromDB = writeLevelController.fetchedObjects as! [Users]
        for userFromDB in usersFromDB {
            let actualName = userFromDB.user
            if actualName == userName {
                var levelUpdater = userFromDB.level
                if levelUpdater == cellsAmount/4 {
                    levelUpdater = userFromDB.level + 1
                    userFromDB.setValue(levelUpdater, forKey: "level")
                }
            }
        }
        CoreManager.instance.saveContext()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    @objc func returnToLevels() {
        let controllerIndex = self.navigationController?.viewControllers.index(where: { (viewController) -> Bool in
            return viewController is LevelVC
        })
        let destination = self.navigationController?.viewControllers[controllerIndex!]
        self.navigationController?.popToViewController(destination!, animated: false)
    }
    
    @IBAction func shareResults(_ sender: Any) {
        let screenForSharing = captureScreen()
        let activityVC = UIActivityViewController(activityItems: [screenForSharing!], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func captureScreen() -> UIImage? {
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        return screenshot
    }
    
    func saveObj(_ userName: String) {
        if userResult == nil {
            userResult = Scores()
        }
        if let userResult = userResult {
            userResult.name = userName
            userResult.score = Int16(score)
            userResult.level = Int16(cellsAmount / 4)
            userResult.gameDate = date
            userResult.time = Int16(timerInSeconds)
        }
        CoreManager.instance.saveContext()
    }
}

extension WrittingResultsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! WrittingResultsTVCell
        cell.backgroundColor = .clear
        let user = fetchedResultsController.object(at: indexPath) as! Scores
        if userResult?.objectID == user.objectID {
            cell.nameLabel.backgroundColor = #colorLiteral(red: 0.3696166589, green: 0.895984537, blue: 0.9493972081, alpha: 0.5)
            cell.scoreLabel.backgroundColor = #colorLiteral(red: 0.3696166589, green: 0.895984537, blue: 0.9493972081, alpha: 0.5)
            cell.cardAmountLabel.backgroundColor = #colorLiteral(red: 0.3696166589, green: 0.895984537, blue: 0.9493972081, alpha: 0.5)
            cell.timeLabel.backgroundColor = #colorLiteral(red: 0.3696166589, green: 0.895984537, blue: 0.9493972081, alpha: 0.5)
        }
        cell.nameLabel.text = user.name
        cell.scoreLabel.text = "\(user.score)"
        cell.cardAmountLabel.text = "\(user.level)"
        cell.timeLabel.text = "\(user.time)"
        
        cell.nameLabel.layer.masksToBounds = masksToBounds
        cell.scoreLabel.layer.masksToBounds = masksToBounds
        cell.cardAmountLabel.layer.masksToBounds = masksToBounds
        cell.timeLabel.layer.masksToBounds = masksToBounds
        
        cell.nameLabel.layer.cornerRadius = cornerRadius
        cell.scoreLabel.layer.cornerRadius = cornerRadius
        cell.cardAmountLabel.layer.cornerRadius = cornerRadius
        cell.timeLabel.layer.cornerRadius = cornerRadius
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
}

extension WrittingResultsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! WrittingResultsTVCell
        
        headerCell.nameLabel.backgroundColor = #colorLiteral(red: 0.3099915116, green: 0.7514477346, blue: 0.7962440776, alpha: 0.5)
        headerCell.scoreLabel.backgroundColor = #colorLiteral(red: 0.3099915116, green: 0.7514477346, blue: 0.7962440776, alpha: 0.5)
        headerCell.cardAmountLabel.backgroundColor = #colorLiteral(red: 0.3099915116, green: 0.7514477346, blue: 0.7962440776, alpha: 0.5)
        headerCell.timeLabel.backgroundColor = #colorLiteral(red: 0.3099915116, green: 0.7514477346, blue: 0.7962440776, alpha: 0.5)
        
        headerCell.nameLabel.text = "name"
        headerCell.scoreLabel.text = "score"
        headerCell.cardAmountLabel.text = "level"
        headerCell.timeLabel.text = "time"
        
        headerCell.nameLabel.layer.masksToBounds = masksToBounds
        headerCell.scoreLabel.layer.masksToBounds = masksToBounds
        headerCell.cardAmountLabel.layer.masksToBounds = masksToBounds
        headerCell.timeLabel.layer.masksToBounds = masksToBounds
        
        headerCell.nameLabel.layer.cornerRadius = cornerRadius
        headerCell.scoreLabel.layer.cornerRadius = cornerRadius
        headerCell.cardAmountLabel.layer.cornerRadius = cornerRadius
        headerCell.timeLabel.layer.cornerRadius = cornerRadius
        
        headerView.addSubview(headerCell)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRowInTable
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForRowInTable
    }
}
