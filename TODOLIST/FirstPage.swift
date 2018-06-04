//
//  FirstPage.swift
//  TODOLIST
//
//  Created by Shyngys on 20.04.17.
//  Copyright © 2017 SDU. All rights reserved.
//

import UIKit
import Firebase

class FirstPage: UIViewController {

    @IBOutlet weak var segmentController: SegmentedControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.layer.cornerRadius = 15
        containerView.clipsToBounds = true
        
        segmentController.items = ["Login", "Register"]
        segmentController.selectedLabelColor =  UIColor.red
        segmentController.unselectedLabelColor = UIColor.lightGray
        segmentController.thumbColor = UIColor.white
        segmentController.addTarget(self, action: #selector(enter), for: .valueChanged)
        enter(sender: segmentController)
        
    }
    
    func enter(sender:SegmentedControl)  {
        if sender.selectedIndex == 0 {
            button.setTitle("Login", for: .normal)
        }else {
            button.setTitle("Register", for: .normal)
        }
    }
    
    @IBAction func actionButton(_ sender: Any) {
        if segmentController.selectedIndex == 0 {
            FIRAuth.auth()?.signIn(withEmail: email.text!, password: password.text!, completion: { (user, error) in
                if let _ = user {
                    DispatchQueue.main.async {
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home")
                        self.present(vc, animated: true, completion: nil)
                    }
                }else{
                    let alert = UIAlertController(title: error!.localizedDescription, message: nil, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Try again", style: .cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }else{
            FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!, completion: { (user, error) in
                if let _ = user {
                    DispatchQueue.main.async {
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home")
                        self.present(vc, animated: true, completion: nil)
                    }
                }else{
                    let alert = UIAlertController(title: error!.localizedDescription, message: nil, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Try again", style: .cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
