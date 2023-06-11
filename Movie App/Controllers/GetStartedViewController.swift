//
//  GetStartedViewController.swift
//  Movie App
//
//  Created by user on 30.11.2022.
//

import UIKit
import AVKit

class GetStartedViewController: UIViewController {
    
    var playerLayer: AVPlayerLayer!
    
    var player: AVPlayer!
    
    @IBOutlet weak var backView: UIView!
    
    deinit {
        print("!!! Deinit: \(self)")
    }
    
    @IBOutlet weak var bottomView: UIView!
    
    let mainNotificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.isHidden = false
        setUpNotifications()
        configureAnimation()
    }
    
    func setUpNotifications() {
        
        mainNotificationCenter.addObserver(self, selector: #selector(appWillBeHiddenOnBackground), name: UIApplication.willResignActiveNotification, object: nil)
        mainNotificationCenter.addObserver(self, selector: #selector(appWasReturnedOnForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    
    @objc func appWillBeHiddenOnBackground() {
        self.player.pause()
    }
    
    
    @objc func appWasReturnedOnForeground() {
        DispatchQueue.main.async {
            self.player.play()
        }
    }
    
    
    func configureAnimation() {
        guard let videoURL = Bundle.main.url(forResource: "kachka", withExtension: "mp4") else { return }
        
        player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        view.layer.addSublayer(playerLayer)
        player.play()
    }
    
    
    @objc func playerDidFinishPlaying() {
        playerLayer.removeFromSuperlayer()
        mainNotificationCenter.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        mainNotificationCenter.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        mainNotificationCenter.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        backView.isHidden = true
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        playerLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
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
            
            guard UserDefaults.standard.bool(forKey: UserDefaultsManager.shared.getKeyFor(.isGuestSession)) == true else { return }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController, animated: true)
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait}
}
