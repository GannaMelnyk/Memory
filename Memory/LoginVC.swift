//
//  ViewController.swift
//  Memory
//
//  Created by Ganna Melnyk on 1/28/18.
//  Copyright © 2018 Ganna Melnyk. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    var user: Login?
    var nameForGame = ""
    var users:[Login]=[]
    var logins:[String]=[]
    var passes:[String]=[]
    
    var fetchedResultsController = CoreManager.instance.fetchedResultsController(entityName: "Login", keyForSort: "login")
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        users = fetchedResultsController.fetchedObjects as! [Login]
                for user in users {
                    logins.append(user.login!)
        }
    }
    
    @IBAction func createUserButton(_ sender: UIButton) {
        isFieldEmpty()
        let name = nameTextField.text
        if logins.contains(name!) {
            let alertController = UIAlertController(title: "Oops!", message: "Login \(name ?? "") already exists", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: false, completion: nil)
        }
        if user == nil {
            user = Login()
        }
        if let user = user {
            user.login = nameTextField.text
            user.password = passTextField.text
            nameForGame = user.login!
            let alertController = UIAlertController(title: "Ta-ta-ta-dam!", message: "You succesfully created user", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Let's play!", style: .default) { action in
                self.goToTheNextScreen()
            }
            alertController.addAction(okAction)
            present(alertController, animated: false, completion: nil)
        }
        CoreManager.instance.saveContext()
//        do {
//            try self.fetchedResultsController.performFetch()
//        } catch {
//            print(error)
//        }
    }
    
    @IBAction func loginUserButton(_ sender: UIButton) {
        isFieldEmpty()
        users = fetchedResultsController.fetchedObjects as! [Login]
        let userLogin = nameTextField.text ?? ""
        if !logins.contains(userLogin) {
            let alertController = UIAlertController(title: "Oops", message: "User unexists", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: false, completion: nil)
        } else {
            for user in users {
                if (user.login == userLogin) {
                    if user.password == passTextField.text {
                        nameForGame = user.login!
                        goToTheNextScreen()
                        break
                    } else {
                        let alertController = UIAlertController(title: "Oops", message: "Wrong credentials", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        present(alertController, animated: false, completion: nil)
                    }
                }
            }
        }
    }
    
    func isFieldEmpty() {
        if ((nameTextField.text?.isEmpty)! && (passTextField.text?.isEmpty)!) {
            let alertController = UIAlertController(title: "Oops!", message: "Fill the fields", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: false, completion: nil)
        }
    }
    
    func goToTheNextScreen(){
        performSegue(withIdentifier: "levelSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let holder = segue.destination as! LevelVC
        holder.user = nameForGame
    }
    
}

