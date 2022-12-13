//
//  GetStartedViewController.swift
//  Movie App
//
//  Created by user on 30.11.2022.
//

import UIKit

class GetStartedViewController: UIViewController {
    
    deinit {
        print("!!! Deinit: \(self)")
      }

    @IBOutlet weak var bottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bottomView.layer.cornerRadius = 10
        bottomView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let destinationViewController = storyboard.instantiateViewController(withIdentifier: "AuthenticationViewController") as? AuthenticationViewController else { return }

        self.present(destinationViewController, animated: true)

    }
    
    @IBAction func guestSessionButtonPressed(_ sender: UIButton) {
        print("waiting for guest session...")
        
        NetworkManager.shared.createGuestSession { success in
            guard success else { return }
            
            Globals.isGuestSession = true
            
            self.performSegue(withIdentifier: "guestSessionSegue", sender: nil)

        }
    }
}
