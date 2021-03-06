//
//  UserVC.swift
//  Memory
//
//  Created by Ganna Melnyk on 2/1/18.
//  Copyright © 2018 Ganna Melnyk. All rights reserved.
//

import UIKit
import CoreData

class UserVC: UIViewController {
    
    let tableRowHeight: CGFloat = 25
    
    var fetchedResultsController = CoreManager.instance.fetchedResultsController(entityName: "Users", keyForSort: "user", ascending: true)
    var userName = "guest"
    var level = 1
    var userData: Users?
    var logins:[Users] = []
    var names:[String]=[]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playButtonOutlet: UIButton!
    
    @IBAction func playButton(_ sender: UIButton) {
        performSegue(withIdentifier: "levelSegue", sender: self)
    }
    
    @IBAction func addNewUser(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Create new user", message: "Enter your nickname", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "save", style: .default) {[weak self] action in
            guard let textField = alertController.textFields?.first, let userName = textField.text else {return}
            if ((self?.names.contains(userName))! || userName == "guest") {
                let hiddenAlertController = UIAlertController(title: "User already exists", message: "Enter another name", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "ok", style: .destructive, handler: nil)
                hiddenAlertController.addAction(cancelAction)
                self?.present(hiddenAlertController, animated: false, completion: nil)
            } else {
                self?.saveObj(userName)
                self?.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .destructive, handler: nil)
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: false, completion: nil)
    }
    
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
        guard let logins = fetchedResultsController.fetchedObjects as? [Users] else {
            fatalError("Error: wrong request to DB")
        }
        for login in logins {
            names.append(login.user!)
        }
        playButtonOutlet.setTitle("play as a \(userName)", for: .normal)
    }
    
    func saveObj(_ userName: String) {
            userData = Users()
        if let userData = userData {
            userData.user = userName
            userData.level = 1
        }
        CoreManager.instance.saveContext()
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let holder = segue.destination as! LevelVC
        holder.user = userName
        holder.resolvedLevel = level
    }
}

extension UserVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCellId", for: indexPath) as? UserTVCell else {
            fatalError("wrong table view Cell in UserVC")
        }
        guard let user = fetchedResultsController.object(at: indexPath) as? Users else {
            fatalError("it's not a user")
        }
        cell.userName.text = "\(user.user ?? "user")"
        cell.layer.backgroundColor = UIColor.clear.cgColor
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

extension UserVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = fetchedResultsController.object(at: indexPath) as? Users else {
            fatalError("it's not a user")
        }
        userName = user.user ?? "user"
        if userName == "guest" {
            level = 1
        } else {
            level = Int(user.level)
        }
        playButtonOutlet.setTitle("play as a \(userName)", for: .normal)
    }
    
}
