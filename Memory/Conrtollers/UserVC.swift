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
    
    @IBOutlet weak var tableView: UITableView!
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
    
    var fetchedResultsController = CoreManager.instance.fetchedResultsController(entityName: "Users", keyForSort: "user", ascending: true)
    
    var userName = "guest"
    var level = 1
    var userData: Users?
    
    var logins:[Users] = []
    var names:[String]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // saveObj(userName)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        logins = fetchedResultsController.fetchedObjects as! [Users]
        for login in logins {
            names.append(login.user!)
        }
        playButtonOutlet.setTitle("play as a \(userName)", for: .normal)
    }
    
    
    @IBOutlet weak var playButtonOutlet: UIButton!
    
    @IBAction func playButton(_ sender: UIButton) {
        performSegue(withIdentifier: "levelSegue", sender: self)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCellId", for: indexPath) as! UserTVCell
        let user = fetchedResultsController.object(at: indexPath) as! Users
        cell.userName.text = "\(user.user ?? "user")"
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
        return 25
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = fetchedResultsController.object(at: indexPath) as! Users
        userName = user.user ?? "user"
        if userName == "guest" {
            level = 1
        } else {
            level = Int(user.level)
        }
        playButtonOutlet.setTitle("play as a \(userName)", for: .normal)
    }
    
}
