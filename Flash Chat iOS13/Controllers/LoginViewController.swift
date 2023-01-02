

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import FirebaseCoreInternal

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        loginIndicator.isHidden=true
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        
        loginIndicator.isHidden=false
        loginIndicator.startAnimating()

        
        
        if let email=emailTextfield.text{
            if let password=passwordTextfield.text{
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                    guard self != nil else { return }
                    // ...
                    if let e=error{
                        print(e)
                    }
                    else {
                        self?.performSegue(withIdentifier: K.loginSegue, sender: self)
                    }
                }
            }}
        
    }
}
