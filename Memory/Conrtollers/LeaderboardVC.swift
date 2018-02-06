//
//  LeaderboardVCViewController.swift
//  Memory
//
//  Created by Ganna Melnyk on 1/31/18.
//  Copyright © 2018 Ganna Melnyk. All rights reserved.
//

import UIKit

class LeaderboardVC: UIViewController {
    
    let levelCounter = 12
    let pickerRotationAngle: CGFloat = 270 * (.pi / 180)
    let pickerComponentRotationAngle: CGFloat = (90 * (.pi / 180))
    let heightForRowInTable: CGFloat = 25
    let pickerComponentHight: CGFloat = 100
    let cornerRadius: CGFloat = 10
    let masksToBounds = true
    
    var score = 0
    var cellAmount = 0
    var userName = ""
    var date: Date?
    var levels:[String]=[]
    var level = 1
    var userResult: Scores?
    var fetchedResultsController = CoreManager.instance.fetchedResultsController(entityName: "Scores", keyForSort: "score", ascending: true, predicateVar: "1")
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .clear
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "launchScreen"))
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = #imageLiteral(resourceName: "launchScreen")
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        
        for i in 1...levelCounter {
            levels.append("Level: \(i)")
        }
        
        let y = pickerView.frame.origin.y - 20
        pickerView.transform = CGAffineTransform(rotationAngle: pickerRotationAngle)
        pickerView.frame = CGRect(x: -100, y: y, width: view.frame.width + 200, height: 100)
    }
    
    func updateTableView(){
        fetchedResultsController = CoreManager.instance.fetchedResultsController(entityName: "Scores", keyForSort: "score", ascending: true, predicateVar: "\(level)")
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCellId", for: indexPath) as? LeaderboardTVCell else {
            fatalError("cannot cast cell to LeaderboardTVCell")
        }
        guard let user = fetchedResultsController.object(at: indexPath) as? Scores else {
            fatalError("wrong user from DB")
        }
        
        cell.backgroundColor = .clear
        cell.nameLabel.text = "\(user.name ?? "name")"
        cell.scoreLabel.text = "\(user.score)"
        cell.timeLabel.text = "\(user.time)"
        
        cell.nameLabel.layer.masksToBounds = masksToBounds
        cell.scoreLabel.layer.masksToBounds = masksToBounds
        cell.timeLabel.layer.masksToBounds = masksToBounds
        
        cell.nameLabel.layer.cornerRadius = cornerRadius
        cell.scoreLabel.layer.cornerRadius = cornerRadius
        cell.timeLabel.layer.cornerRadius = cornerRadius
        
        return cell
    }
}

extension LeaderboardVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCellId") as? LeaderboardTVCell else {
            fatalError("cannot cast header to LeaderboardTVCell")
        }
        
        headerCell.nameLabel.backgroundColor = #colorLiteral(red: 0.3099915116, green: 0.7514477346, blue: 0.7962440776, alpha: 0.8)
        headerCell.scoreLabel.backgroundColor = #colorLiteral(red: 0.3099915116, green: 0.7514477346, blue: 0.7962440776, alpha: 0.8)
        headerCell.timeLabel.backgroundColor = #colorLiteral(red: 0.3099915116, green: 0.7514477346, blue: 0.7962440776, alpha: 0.8)
        
        headerCell.nameLabel.text = "name"
        headerCell.scoreLabel.text = "score"
        headerCell.timeLabel.text = "time"
        
        headerCell.nameLabel.layer.masksToBounds = masksToBounds
        headerCell.scoreLabel.layer.masksToBounds = masksToBounds
        headerCell.timeLabel.layer.masksToBounds = masksToBounds
        
        headerCell.nameLabel.layer.cornerRadius = cornerRadius
        headerCell.scoreLabel.layer.cornerRadius = cornerRadius
        headerCell.timeLabel.layer.cornerRadius = cornerRadius
        
        return headerCell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRowInTable
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForRowInTable
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
        return pickerComponentHight
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        level = row + 1
        updateTableView()
        self.tableView.reloadData()
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.transform = CGAffineTransform(rotationAngle: pickerComponentRotationAngle)
        let titleData = levels[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 22.0) as Any,NSAttributedStringKey.foregroundColor:UIColor.black])
        pickerLabel.attributedText = myTitle
      //  pickerView.backgroundColor = UIColor(#colorLiteral(red: 0.907289631, green: 1, blue: 0.9774866882, alpha: 1))
        pickerLabel.backgroundColor = colorForBackground(viewForRow: row)
        pickerLabel.textAlignment = .center
        return pickerLabel
    }
    
    private func colorForBackground(viewForRow row: Int) -> UIColor {
        let blueColor = 1 - (CGFloat(row)/CGFloat(levels.count - 1) * 0.5)
        return UIColor(displayP3Red: 0.1, green: 0.5, blue: blueColor, alpha: 1.0)
    }
}


