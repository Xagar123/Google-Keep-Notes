//
//  SettingViewController.swift
//  Side Menu Bar prog
//
//  Created by Admin on 01/12/22.
//

import UIKit

class SettingViewController: UIViewController {
    
    //MARK: - Properties
    
    var userName: String?
    
    //MARK: - Init
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userName = userName {
            print("user name is \(userName)")
        }else{
            print("user not found")
        }

        configureUI()
        
    }
    
    //MARK: - Helper Function
    
    func configureUI(){
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Setting"
        navigationController?.navigationBar.barStyle = .default
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image:UIImage(imageLiteralResourceName: "cross3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    @objc func handleDismiss(){
        dismiss(animated: true,completion: nil)
    }
    

}
