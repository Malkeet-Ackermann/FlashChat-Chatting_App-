import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import FirebaseCoreInternal

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    var messages:[message]=[]
    let db=Firestore.firestore()
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden=true
    }
    override func viewDidLoad() {
        loadMessages()

        //MARK: when dealing with the delegtes make it self in viewDidLoad and don't forget to register when new message cell coomeses !
        tableView.dataSource=self
        super.viewDidLoad()
        title="⚡️FlashChat"
        navigationItem.hidesBackButton=true
        tableView.register( UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        view.endEditing(true)
        if let messageBody = messageTextfield.text, let messageSender=Auth.auth().currentUser?.email{
            db.collection(K.FStore.collectionName ).addDocument(data: [K.FStore.senderField :messageSender,K.FStore.bodyField:messageBody,
            K.FStore.dateField: Date().timeIntervalSince1970                                                    ]){
                (error) in
                if error != nil{
                    print("Oops! We found an error ")
                }
                else
                {
                    print("File saved successfully")
                }
            }
            
        }
        DispatchQueue.main.async {
            self.messageTextfield.text=" "
        }
     
      
        
    }
    func loadMessages(){
        
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener {(querySnapshot,error) in
            self.messages=[]
        
            if error != nil{
                print("Oops! Something went wrong !")
            }
            else{
                if let querySnap=querySnapshot?.documents{
                 
                   for doc in querySnap{
                       let dataVal=doc.data()
                       if let sender=dataVal[K.FStore.senderField] as? String,let messages1=dataVal[K.FStore.bodyField] as? String{
                           let finalMessage=message(sender: sender, body: messages1)
                           self.messages.append(finalMessage)
                        
                       }
                    }
                }
            }
            
            
            // MARK: reloading the table and seeing always the bottom most messages
            DispatchQueue.main.async {
                self.tableView.reloadData()
                let indexPath=IndexPath(row: self.messages.count-1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                
            }
        }
    }
  
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        
        
    }}
    
extension ChatViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mssg=messages[indexPath.row]
        // MARK: this is the cell that we fetched
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier,
                                                 for: indexPath) as! MessageCell
        cell.label.text = mssg.body
        
        
        if mssg.sender == Auth.auth().currentUser?.email{
            cell.leftImageview.isHidden=true
            cell.rightImageView.isHidden=false
            cell.messageBubble.backgroundColor=UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor=UIColor(named: K.BrandColors.purple)
        }
        //MARK: when other sender is chatting
        else{
            cell.messageBubble.backgroundColor=UIColor(named: K.BrandColors.lighBlue)
            cell.leftImageview.isHidden=false
            cell.label.textColor=UIColor(named: K.BrandColors.blue)
            cell.rightImageView.isHidden=true
            
        }
        
        
        
        return cell
    }
    
        
    }
    

