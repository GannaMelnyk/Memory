//
//  LeaderboardVCViewController.swift
//  Memory
//
//  Created by Ganna Melnyk on 1/31/18.
//  Copyright © 2018 Ganna Melnyk. All rights reserved.
//

import UIKit

class LeaderboardVC: UIViewController {
    var score = 0
    var cellAmount = 0
    var userName = ""
    var date: Date?
    
    var userResult: Scores?
    
    var fetchedResultsController = CoreManager.instance.fetchedResultsController(entityName: "Scores", keyForSort: "score")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    func dateConversion(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MMM/yy HH:mm"
        return formatter.string(from: date)
        
    }
}

extension LeaderboardVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCellId", for: indexPath) as! LeaderboardTVCell
        let user = fetchedResultsController.object(at: indexPath) as! Scores
        let date = user.gameDate
        let formatedDate = dateConversion(date: date!)
        cell.nameLabel.text = "\(user.name ?? "name")"
        cell.scoreLabel.text = "\(user.score)"
        cell.dateLabel.text = "\(formatedDate)"
        return cell
    }
}

extension LeaderboardVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCellId") as! LeaderboardTVCell
        headerCell.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        headerCell.nameLabel.backgroundColor = #colorLiteral(red: 0.3713936225, green: 0.7476998731, blue: 0.6512246604, alpha: 1)
        headerCell.scoreLabel.backgroundColor = #colorLiteral(red: 0.3713936225, green: 0.7476998731, blue: 0.6512246604, alpha: 1)
        headerCell.dateLabel.backgroundColor = #colorLiteral(red: 0.3713936225, green: 0.7476998731, blue: 0.6512246604, alpha: 1)
        headerCell.nameLabel.text = "name"
        headerCell.scoreLabel.text = "score"
        headerCell.dateLabel.text = "date"
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
