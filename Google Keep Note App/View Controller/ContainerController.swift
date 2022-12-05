//
//  ContainerController.swift
//  Side Menu Bar prog
//
//  Created by Admin on 25/11/22.
//

import UIKit

class ContainerController: UIViewController {
    
    // MARK: - properties

    var menuController: MenuController!
    var centerController: UIViewController!
    var isExpended = false
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeController()
    
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool{
        return isExpended
    }
    
    //MARK: - handler
    

    func configureHomeController(){
        let homeController = HomeController()
        homeController.delegate = self
        centerController = UINavigationController(rootViewController: homeController)
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
    }
    
    func configureMenuController(){
        if menuController == nil {
            //add our menu controller here
            menuController = MenuController()
            menuController.delegate = self
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
           // navigationItem.title = "notes"
            print("did add menu controller")
        }
    }
    
    func animatePanelController(shouldExpand: Bool, menuOption: MenuOption?){
        if shouldExpand{
            //show menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0,options: .curveEaseOut) {
                
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 80
            }
        }else{
            //hide menu
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0,options: .curveEaseOut) {
//
//
//            }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0,options: .curveEaseOut) {
                self.centerController.view.frame.origin.x = 0
            }completion: { (_ ) in
                guard let menuOption = menuOption else {return}
                self.didSelectMenuOption(menuOption: menuOption)
            }
        }
        animateStatusBar()
    }
    
    func didSelectMenuOption(menuOption: MenuOption){
        switch menuOption{
            
        case .Notes:
            print("Navigatae to home")
        case .Reminders:
            print("Navigatae to home")
            let homeVC = storyboard?.instantiateViewController(withIdentifier: "ContainerController") as! ContainerController
            let container = SettingViewController()
            let newVC = UINavigationController(rootViewController: container)
            present(newVC, animated: true)
        case .CreateNewlable:
            let container = NoteViewController()
            let newVC = UINavigationController(rootViewController: container)
            present(newVC, animated: true)
            
//                present(UINavigationController(rootViewController: container), animated: true)
//                container.modalPresentationStyle = .fullScreen
            
        case .Archive:
            print("Navigatae to home")
        case .Trash:
            print("Navigatae to home")
        case .Setting:
            print("Navigatae to home")
//            let container = SettingViewController()
//                container.userName = "Sam"
//                container.modalPresentationStyle = .fullScreen
        case .HelpAndfeedback:
            print("Navigatae to home")
        }
    }
    
    func animateStatusBar(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0,options: .curveEaseOut) {
            
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
   

}

extension ContainerController: HomeControllerDelegate {
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        if !isExpended {
            configureMenuController()
        }
        
        isExpended = !isExpended
        animatePanelController(shouldExpand: isExpended, menuOption: menuOption)
    }
    
    
}
