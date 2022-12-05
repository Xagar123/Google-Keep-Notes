

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var errorLable: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    var dbreference = Firestore.firestore()
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElement()
    }
    
    func setUpElement() {
        //hiding the error lable
        errorLable.alpha = 0
        
        //style the element
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signupButton)
        Utilities.styleHollowButton(backButton)
        Utilities.styleHollowButton(loginButton)
        
    }
    
    func validateFields() -> String? {
        
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "please fill in the fields"
        }
        let cleanedPassword = (passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        if Utilities.isPasswordValid(cleanedPassword) == false {
            
            return "please make sure your password is atleast 8 character"
        }
        
        return nil
    }
    
    @IBAction func tapedBackButton(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func showError(_ message: String) {
        errorLable.text = message
        errorLable.alpha = 1
    }
    

    @IBAction func tapedSignUpButton(_ sender: UIButton) {
        //validate the user
        //create the user
        //Transfer to the home page
        
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        }
        else{
            
            
            let firstName = firstNameTextField.text!
            let lastName = lastNameTextField.text!
            let email = emailTextField.text!
            let password = passwordTextField.text!
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if error == nil {
                    let userData = ["first Name": firstName,"last Name":lastName,"email": email,
                                    "password": password]
                    self.dbreference.collection("User").addDocument(data: userData) { (error) in
                        if error != nil {
                            self.showError("Enter valid input")
                        }else{
                            self.errorLable.alpha = 1
                            self.errorLable.text = "Account created"
                        }
                    }
                }else{
                    self.showError("error - User already exist")
                    self.errorLable.text = "error \(error)"
                    return
                }
                //transition to login screen
                
            }
        }
    }
    
    
    @IBAction func tapedToLogin(_ sender: UIButton) {
        self.transitionToLogin()
    }
    
    func transitionToLogin(){
        let loginVC = storyboard?.instantiateViewController( withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
}
