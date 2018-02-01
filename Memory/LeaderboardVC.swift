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
    var levels:[String]=[]
    var levelCounter = 14
    var level = 1
    var rotationAngle: CGFloat!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var userResult: Scores?
    
    var fetchedResultsController = CoreManager.instance.fetchedResultsController(entityName: "Scores", keyForSort: "score", ascending: true, predicateVar: 1)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        
        for i in 1...levelCounter {
            levels.append("Level: \(i)")
        }
        rotationAngle =  270 * (.pi / 180)
        let y = pickerView.frame.origin.y
        pickerView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        pickerView.frame = CGRect(x: -100, y: y, width: view.frame.width + 200, height: 100)
    }
    
    func dateConversion(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MMM/yy HH:mm"
        return formatter.string(from: date)
    }
    
    func updateTableView(){
        fetchedResultsController = CoreManager.instance.fetchedResultsController(entityName: "Scores", keyForSort: "score", ascending: true, predicateVar: level)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
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
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCellId") as! LeaderboardTVCell
        headerCell.nameLabel.backgroundColor = #colorLiteral(red: 0.3713936225, green: 0.7476998731, blue: 0.6512246604, alpha: 1)
        headerCell.scoreLabel.backgroundColor = #colorLiteral(red: 0.3713936225, green: 0.7476998731, blue: 0.6512246604, alpha: 1)
        headerCell.dateLabel.backgroundColor = #colorLiteral(red: 0.3713936225, green: 0.7476998731, blue: 0.6512246604, alpha: 1)
        headerCell.nameLabel.text = "name"
        headerCell.scoreLabel.text = "score"
        headerCell.dateLabel.text = "date"
        return headerCell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
}

extension LeaderboardVC: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return levels.count
    }
    
}

extension LeaderboardVC: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return levels[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(levels[row])
        level = row + 1
        updateTableView()
        self.tableView.reloadData()
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.transform = CGAffineTransform(rotationAngle: (90 * (.pi / 180)))
        let titleData = levels[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 22.0) as Any,NSAttributedStringKey.foregroundColor:UIColor.white])
        pickerLabel.attributedText = myTitle
        pickerLabel.backgroundColor = colorForBackground(viewForRow: row)
        pickerLabel.textAlignment = .center
        return pickerLabel
    }
    
    private func colorForBackground(viewForRow row: Int) -> UIColor {
        let blueColor = 1 - (CGFloat(row)/CGFloat(levels.count - 1) * 0.5)
        return UIColor(displayP3Red: 0.0, green: 0.0, blue: blueColor, alpha: 1.0)
    }
}


