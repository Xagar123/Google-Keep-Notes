

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import FirebaseFirestore


class LoginViewController: UIViewController {
    
    let signInConfig = GIDConfiguration(clientID: "529423950880-8mr3b48mq38uj3o7hlr1g34633k42o7f.apps.googleusercontent.com")

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    //@IBOutlet weak var errorLable: UILabel!
    
   // @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var googleButton: UIButton!
    var dbreference = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElement()
       
    }
    
    func setUpElement(){
        //Hiding error lable
       // errorLable.alpha = 0
        
        //Style element field
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordField)
        Utilities.styleFilledButton(loginButton)
        //Utilities.styleHollowButton(backButton)
        Utilities.styleHollowButton(googleButton)
    }
    

    
    @IBAction func tapedBackButton(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func goToSignUpButton(_ sender: UIButton) {
        let signupVC = (storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController)!
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
    
    @IBAction func tapedLoginButton(_ sender: UIButton) {
        //validate the text field
        //signing the user
        
        guard let email = emailTextField.text, !email.isEmpty else {
            self.alertPopup(title: "Error", message: "Enter Email")
            //self.errorLable.text = "Enter email"
            return }
        guard let password = passwordField.text, !password.isEmpty else {
            self.alertPopup(title: "Error", message: "Enter Password")
           // self.errorLable.text = "Enter password"
            return }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
          
            if error != nil {
                //couldn't signin
                
                self.alertPopup(title: "Error", message: "Wrong Input")
//                self.errorLable.alpha = 1
//                self.errorLable.text = error?.localizedDescription
            }
            else{
                self.transitionToHome()
            }
          
        }
    }
    
    
    @IBAction func googleSignInButton(_ sender: UIButton) {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }

            let emailAddress = user.profile?.email
            print(emailAddress)
            
                let authentication = user.authentication
            guard let idToken = authentication.idToken else {return}
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            let dataToSave: [String: Any] = ["email":emailAddress]
            self.dbreference.collection("User").addDocument(data: dataToSave)
            
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("authentication error \(error.localizedDescription)")
                }
                else{
                    self.transitionToHome()
                }
            }
        }
        
    }
    
    func transitionToHome(){
        let homeVC = storyboard?.instantiateViewController(withIdentifier: "ContainerController") as! ContainerController
//        let container = ContainerController()
//        let nav = UINavigationController(rootViewController: homeVC)
//        nav.modalPresentationStyle = .fullScreen
//       present(nav,animated: true)
        
        self.navigationController?.pushViewController(homeVC, animated: true)
//        view.window?.rootViewController = "HomeViewController"
//        view.window?.makeKeyAndVisible()
    }
    
    func alertPopup(title:String, message: String){
        
        let alert = UIAlertController(title: title, message: message , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel)  { (action) in alert.dismiss(animated: true) })
        
        self.present(alert, animated: true, completion: nil)
        
    }
    func alert(view: UIViewController, title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            })
            alert.addAction(defaultAction)
            DispatchQueue.main.async(execute: {
                view.present(alert, animated: true)
            })
        }

}
