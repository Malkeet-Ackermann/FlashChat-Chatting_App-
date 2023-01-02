
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import FirebaseCoreInternal
class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email=emailTextfield.text{
            if let password=passwordTextfield.text{
                //        passwordTextfield.text=sender.titleLabel?.text
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    
                    if let e=error{
                        print(e)
                    }
                    else{
                        // MARK: move to next VC
                        self.performSegue(withIdentifier:K.registerSegue, sender: self)
                    }
                   
                    
                }
            }}
    }
    
}
