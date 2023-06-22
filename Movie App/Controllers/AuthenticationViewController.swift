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
        
        mainNotificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        mainNotificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
      }
    
    @IBOutlet weak var loginTextField: UITextField!
    
    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var requiredLabel: UILabel!
    
    @IBOutlet weak var requiredPassword: UILabel!
    
    private var couldShowKeyboard = false
    
    @Injected private var keychainManager: KeychainManagerProtocol
    
    private let mainNotificationCenter = NotificationCenter.default
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)
        
        loginTextField.text =  nil
        passTextField.text = nil
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loginTextField.textColor = .black
        passTextField.textColor = .black
        
        loginTextField.textContentType = .username
        passTextField.textContentType = .password
        loginTextField.autocorrectionType = .no
        passTextField.autocorrectionType = .no
        
        loginTextField.isSecureTextEntry = false
        passTextField.isSecureTextEntry = true
        
        loginTextField.tintColor = .systemPink
        passTextField.tintColor = .systemPink
        
        resetForm()
        setUpNotifications()
        
        passTextField.delegate = self
        
        //AnimationService.shared.addAnimation(view: view)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard) )
        view.addGestureRecognizer(tapGesture)
        
        keychainManager.savePasswordFor(login: loginTextField.text!, password: "olena2023", completion: nil)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    
    func setUpNotifications() {
        mainNotificationCenter.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        
        mainNotificationCenter.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
       
        let buttonsBottomConstraint = view.constraints.first(where: { $0.identifier == "buttonBotttom" })
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let constraintHeight = safeAreaHeight - (safeAreaHeight * (buttonsBottomConstraint?.multiplier ?? 0))
        
        
        UIView.animate(withDuration: 0.5) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + constraintHeight - 15)
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        
        UIView.animate(withDuration: 0.5) {
            self.view.transform = .identity
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        guard let login = loginTextField.text else { return }
        guard let password = passTextField.text else { return }
        
        NetworkManager.shared.requestAuthentication(username: login, password: password) { result in
            
            switch result {
                
            case .success(let sessionID):
                
//                self.keychainManager.savePasswordFor(login: login, password: password, completion: nil)

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
                self.requiredPassword.text = "Wrong password..."
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    @IBAction func passTextfieldPressed(_ sender: UITextField) {
        
        keychainManager.getPasswordFor(login: loginTextField.text ?? "") { result in
           
            DispatchQueue.main.async {
                
                switch result {
                    
                case .success(let password):
                    self.passTextField.text = password
                    let greenTint = UIColor(red: 220/255, green: 255/255, blue: 220/255, alpha: 1.0)
                    self.passTextField.backgroundColor = greenTint
                    self.couldShowKeyboard = true
                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                        self.passTextField.becomeFirstResponder()
//                    }
                    
                case .failure(let error):
                    
                    print("Error when getting password for login \(String(describing: self.loginTextField.text)): \(error)")
                    self.couldShowKeyboard = true
                }
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
        
        passTextField.backgroundColor = .white
    }
}


extension AuthenticationViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard textField == passTextField else { return true }
        return couldShowKeyboard
    } 
}
