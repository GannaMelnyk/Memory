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
    var score = 0
    var cellsAmount = 0
    var userName = ""
    var date: Date?
    
    var userResult: Scores?
    
    var fetchedResultsController = CoreManager.instance.fetchedResultsController(entityName: "Scores", keyForSort: "gameDate")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let newButton = UIBarButtonItem(title: "return to levels", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.returnToLevels))
        self.navigationItem.leftBarButtonItem = newButton
//        let rightButton = UIBarButtonItem(image: #imageLiteral(resourceName: "share"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.shareResults))
//        self.navigationItem.rightBarButtonItem = rightButton
        saveObj(userName)
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
    
    @objc func shareResults(){
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
        }
        CoreManager.instance.saveContext()
    }
}

extension WrittingResultsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! WrittingResultsTVCell
        let user = fetchedResultsController.object(at: indexPath) as! Scores
        if userResult?.objectID == user.objectID {
            cell.nameLabel.backgroundColor = #colorLiteral(red: 0.3851541522, green: 0.9626077852, blue: 0.8537584253, alpha: 1)
            cell.scoreLabel.backgroundColor = #colorLiteral(red: 0.3851541522, green: 0.9626077852, blue: 0.8537584253, alpha: 1)
            cell.cardAmountLabel.backgroundColor = #colorLiteral(red: 0.3851541522, green: 0.9626077852, blue: 0.8537584253, alpha: 1)
        }
        cell.nameLabel.text = user.name
        cell.scoreLabel.text = "\(user.score)"
        cell.cardAmountLabel.text = "\(user.level)"
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
        headerCell.nameLabel.backgroundColor = #colorLiteral(red: 0.3713936225, green: 0.7476998731, blue: 0.6512246604, alpha: 1)
        headerCell.scoreLabel.backgroundColor = #colorLiteral(red: 0.3713936225, green: 0.7476998731, blue: 0.6512246604, alpha: 1)
        headerCell.cardAmountLabel.backgroundColor = #colorLiteral(red: 0.3713936225, green: 0.7476998731, blue: 0.6512246604, alpha: 1)
        headerCell.nameLabel.text = "name"
        headerCell.scoreLabel.text = "score"
        headerCell.cardAmountLabel.text = "level"
        headerView.addSubview(headerCell)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
}
