//
//  ViewController.swift
//  Movie App
//
//  Created by user on 25.09.2022.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    deinit {
        print("!!! Deinit: \(self)")
      }
    
    @IBOutlet weak var loginTextField: UITextField!
    
    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTextField.textColor = .systemGray
        passTextField.textColor = .systemGray
        
        loginTextField.textContentType = .username
        passTextField.textContentType = .password
        loginTextField.autocorrectionType = .no
        passTextField.autocorrectionType = .no
        
        loginTextField.isSecureTextEntry = false
        passTextField.isSecureTextEntry = true
        
        loginTextField.tintColor = .systemPink
        passTextField.tintColor = .systemPink
        
        resetForm()
        //AnimationService.shared.addAnimation(view: view)
        
    }
    
    // add language choice + implementation in all VC
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        guard let login = loginTextField.text else { return }
        guard let password = passTextField.text else { return }
        
        NetworkManager.shared.requestAuthentication(username: login, password: password) { result in
            
            switch result {
                
            case .success(let sessionID):
                
                UserDefaults.standard.set(sessionID, forKey: UserDefaultsManager.shared.getKeyFor(.sessionID))
                
                guard let sessionID = UserDefaults.standard.string(forKey: UserDefaultsManager.shared.getKeyFor(.sessionID)) else { return }
                
                NetworkManager.shared.getUserDetails(sessionId: sessionID) { result in
                    
                    switch result {
                        
                    case .success(let details):

                        UserDefaultsManager.shared.saveUsersDataInUserDefaults(sesssionID: sessionID, isGuestSession: false, userID: details.id, username: details.username, userAvatar: details.avatar.tmdb.avatar_path ?? "")
                        
                        guard UserDefaults.standard.bool(forKey: UserDefaultsManager.shared.getKeyFor(.isGuestSession)) == false else { return }
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                        
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController, animated: true)
                        
                    case .failure(let error):
                        print("Error while getting user's details: \(error.localizedDescription)")
                    }
                }
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    @IBAction func loginTextfieldPressed(_ sender: UITextField) {
        self.becomeFirstResponder()
        
    }
    
    @IBAction func passTextfieldPressed(_ sender: UITextField) {
        self.becomeFirstResponder()
        print("tapped")
        keychainManager.getPasswordFor(login: loginTextField.text ?? "") { result in
            switch result {
            case .success(let password):
                self.passTextField.text = password
            case .failure(let error):
                print("Error when getting password for login \(self.loginTextField.text): \(error)")
            }
        }
        
    }
    
    
    
    func resetForm() {
        submitButton.isEnabled = true
        
//        loginError.isHidden = false
//        phoneError.isHidden = false
//        passwordError.isHidden = false
//
//        loginError.text = "Required"
//        phoneError.text = "Required"
//        passwordError.text = "Required"
        
        loginTextField.text = "Olena.Olena"
        passTextField.text = "olena1611"
    }
}
