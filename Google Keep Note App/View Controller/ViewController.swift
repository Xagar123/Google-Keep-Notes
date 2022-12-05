//
//  ViewController.swift
//  Social Login
//
//  Created by Admin on 17/11/22.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    var videoPlayer: AVPlayer?
    
    var videoPlayerLayer: AVPlayerLayer?
    
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElement()
        view.backgroundColor = .systemPink
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // setUpVideo()
    }
    
    func setUpVideo(){
        //get the path resource to the bundle
        let bundlePath = Bundle.main.path(forResource: "backgroundVideo", ofType: "mp4")
        
        guard bundlePath != nil else { return }
        
        //create a url for it
        let url = URL(fileURLWithPath: bundlePath!)
        
        
        //create the video player item
        let item = AVPlayerItem(url: url)
        
        //creating the player
        videoPlayer = AVPlayer(playerItem: item)
        
        //creating the layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        //adjusting the size and frame
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        
        //adding it to the view and playing it
        videoPlayer?.playImmediately(atRate: 0.3)
        
        //
    }
    
    func setUpElement(){
        
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButtonHome(loginButton)
    }

    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
    
        tranferToLogin()
    }
    
    
    func tranferToLogin(){
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//        let container = ContainerController()
        let nav = UINavigationController(rootViewController: loginVC)
        nav.modalPresentationStyle = .fullScreen
       present(nav,animated: true)
        //self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func tranferToSignUp(){
        let signUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! LoginViewController
//        let container = ContainerController()
        let nav = UINavigationController(rootViewController: signUpVC)
        nav.modalPresentationStyle = .fullScreen
       present(nav,animated: true)
        //self.navigationController?.pushViewController(loginVC, animated: true)
    }

}

