//
//  ViewController.swift
//  Movie App
//
//  Created by user on 25.09.2022.
//

import UIKit

class ViewController: UIViewController {

    var sessionId = ""
    var userId = 0
    
    @IBOutlet weak var loginTextField: UITextField!

    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetForm()
        

    }

    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        guard let login = loginTextField.text else { return }
        guard let password = passTextField.text else { return }

        NetworkManager.shared.requestAuthentication(username: login, password: password) { [weak self] id, responseRequest, responseValidate, responseSession in
            print(responseRequest, responseValidate, responseSession)
            self?.sessionId = id
            print("Session id: \(self?.sessionId ?? "0")")
            
            NetworkManager.shared.getDetails(sessionId: self?.sessionId ?? "0") { [weak self] userId in
                self?.userId = userId
                print("User id: \(self?.userId ?? 0)")
                
                if responseRequest == 200 {
                    print(responseRequest)
                    if responseValidate == 200 {
                        print(responseValidate)
                        if responseSession == 200 {
                            print(responseSession)
                            self?.performSegue(withIdentifier: "authenticationPassedSegue", sender: nil)
                        }
                    }
                }
            }
            
        }
        
        
            
        
//            if self.userId != 0  {
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let viewController = storyboard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
//                viewController.modalPresentationStyle = .fullScreen
//
//                self.present(viewController, animated: true)
//            } else {
//                print("not performed segue")
//            }
        }
        
        
    
    func resetForm() {
        submitButton.isEnabled = true

//        loginError.isHidden = false
//        phoneError.isHidden = false
//        passwordError.isHidden = false

//        loginError.text = "Required"
//        phoneError.text = "Required"
//        passwordError.text = "Required"

        loginTextField.text = ""
        passTextField.text = ""
    }
    
    
}

