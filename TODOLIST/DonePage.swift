//
//  DonePage.swift
//  TODOLIST
//
//  Created by Shyngys on 20.04.17.
//  Copyright © 2017 SDU. All rights reserved.
//

import UIKit
import Firebase



class DonePage: UITableViewController {

    var list = [Extra]()
    var keys = [String]()
    var ref:FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    override func viewWillAppear(_ animated: Bool) {
        list.removeAll()
        keys.removeAll()
        getFromDatabase()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DoneCell
        if list.count > indexPath.row {
            let each = list[indexPath.row]
            cell.label.text = "\(each.time)\n\(each.text)"
            cell.deleteButton.addTarget(self, action: #selector(deleteNote), for: .touchUpInside)
            cell.deleteButton.tag = indexPath.row
            cell.roundView.layer.cornerRadius = 15
            cell.roundView.clipsToBounds = true
            cell.roundView.backgroundColor = UIColor(red: 133.0/255.0, green: 224.0/255.0, blue: 103.0/255.0, alpha: 1)
            cell.deleteButton.backgroundColor = UIColor(red: 255.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
        
    
    @IBAction func logOut(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
            DispatchQueue.main.async {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "First")
                self.present(vc, animated: true, completion: nil)
            }
            
        }catch {
            
        }
    }
    
    func deleteNote(sender:UIButton) {
        let userId = FIRAuth.auth()?.currentUser?.uid
        let db = self.ref.child(userId!).child("done")
        let dict = self.keys[sender.tag]
        let one = db.child(dict)
        one.removeValue()
        self.list.remove(at: sender.tag)
        self.keys.remove(at: sender.tag)
        tableView.reloadData()
    }
    

    func getFromDatabase() {
        if let selfId = FIRAuth.auth()?.currentUser?.uid {
            self.ref.child(selfId).child("done").observe(.childAdded, with: { (snapshot) in
                let key = snapshot.key
                self.keys.append(key)
                if let db = snapshot.value as? [String:AnyObject] {
                    if let text = db["text"] as? String {
                        if let color = db["color"] as? Int {
                            if let date = db["date"] as? String {
                                self.list.append(Extra(text: text, color: color, time: date))
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
            
        }
    }

}


