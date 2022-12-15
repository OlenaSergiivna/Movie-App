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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        navigationController?.navigationBar.isHidden = true
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
        
        NetworkManager.shared.createGuestSession { data in
            guard data.success else { return }
            
            UserDefaultsManager.shared.saveUsersDataInUserDefaults(sesssionID: data.guest_session_id, isGuestSession: true, sessionExpireDate: data.expires_at)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController, animated: true)
            
        }
    }
}
