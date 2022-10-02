//
//  FavouritesViewController.swift
//  Movie App
//
//  Created by user on 27.09.2022.
//

import UIKit

class FavouritesViewController: UIViewController {

    @IBOutlet weak var logOutButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        
        NetworkManager.shared.logOut(sessionId: Globals.sessionId) { [weak self] result in
            if result == true {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "AuthenticationViewController")
                self?.present(viewController, animated: true)
            } else {
                print("false result")
            }
            
        }
    }
}