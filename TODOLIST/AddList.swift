//
//  AddList.swift
//  TODOLIST
//
//  Created by Shyngys on 20.04.17.
//  Copyright © 2017 SDU. All rights reserved.
//

import UIKit
import Firebase

class AddList: UIViewController, UITextViewDelegate {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var purpleBtn: UIButton!
    @IBOutlet weak var yellowBtn: UIButton!
    @IBOutlet weak var greenBtn: UIButton!
    
    
    var ref:FIRDatabaseReference!
    var color:Int = 1
    var date:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        
        textView.delegate = self
        
        pickDate(datePicker)
        
        purpleBtn.layer.cornerRadius = 5
        yellowBtn.layer.cornerRadius = 5
        greenBtn.layer.cornerRadius = 5
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func colors(_ sender: UIButton) {
        if sender.tag == 1 {
            color = 1
        }else if sender.tag == 2 {
            color = 2
        }else{
            color = 3
        }
        
    }
    
    @IBAction func save(_ sender: Any) {
        if let selfId = FIRAuth.auth()?.currentUser?.uid {
            let incremented = self.ref.child(selfId).child("list").childByAutoId()
            incremented.updateChildValues(["color":color,"text":textView.text,"date":date], withCompletionBlock: { (error, database) in
                if let error = error {
                    print(error.localizedDescription)
                }else {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            })
        }
    }
    
    @IBAction func pickDate(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm d.MM.yyyy"
        let dateString = dateFormatter.string(from: datePicker.date)
        date = dateString
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
