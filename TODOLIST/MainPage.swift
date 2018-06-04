//
//  MainPage.swift
//  TODOLIST
//
//  Created by Shyngys on 20.04.17.
//  Copyright © 2017 SDU. All rights reserved.
//

import UIKit
import MCSwipeTableViewCell
import Firebase



class MainPage: UITableViewController, MCSwipeTableViewCellDelegate {
    
    var list1 = [Extra]()
    var keys = [String]()
    var ref:FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        self.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        list1.removeAll()
        keys.removeAll()
        getFromDatabase()
        self.tabBarController?.tabBar.isHidden = false
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list1.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MCSwipeTableViewCell
        
        if list1.count > indexPath.row {
            
            let each = list1[indexPath.row]
            cell.label.text = "Time: \(each.time) \n\(each.text)"
            if each.color == 1 {
                cell.roundView.backgroundColor = UIColor(red: 155.0/255.0, green: 108.0/255.0, blue: 249.0/255.0, alpha: 1)
            }else if each.color == 2 {
                cell.roundView.backgroundColor = UIColor(red: 254.0/255.0, green: 213.0/255.0, blue: 70.0/255.0, alpha: 1)
            }else{
                cell.roundView.backgroundColor = UIColor(red: 133.0/255.0, green: 224.0/255.0, blue: 103.0/255.0, alpha: 1)
            }            
            cell.roundView.layer.cornerRadius = 15
            cell.clipsToBounds = true
            
            cell.delegate = self
            
            
            let view = UIImageView(image: UIImage(named: "checked"))
            view.contentMode = .scaleAspectFit
            
            
            let view1 = UIImageView(image: UIImage(named: "basket"))
            view1.contentMode = .scaleAspectFit
            
            cell.setSwipeGestureWith(view, color: UIColor(red: 67.0/255.0, green: 198.0/255.0, blue: 238.0/255.0, alpha: 1), mode: MCSwipeTableViewCellMode.exit, state: MCSwipeTableViewCellState.state1) { (cell1, state, mode) in
                print(indexPath.row)
                self.makeChanges(indexPath: indexPath)
                
            }
            cell.setSwipeGestureWith(view1, color: UIColor(red: 67.0/255.0, green: 198.0/255.0, blue: 238.0/255.0, alpha: 1), mode: MCSwipeTableViewCellMode.exit, state: MCSwipeTableViewCellState.state3) { (cell, state, mode) in
                print(indexPath.row)
                self.deleteNote(indexPath: indexPath)
            }
        }
        
        return cell
    }
    
    
    func getFromDatabase() {
        if let selfId = FIRAuth.auth()?.currentUser?.uid {
            self.ref.child(selfId).child("list").observe(.childAdded, with: { (snapshot) in
                let key = snapshot.key
                self.keys.append(key)
                if let db = snapshot.value as? [String:AnyObject] {
                    if let text = db["text"] as? String {
                        if let color = db["color"] as? Int {
                            if let date = db["date"] as? String {
                                self.list1.append(Extra(text: text, color: color, time: date))
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
    
    func makeChanges(indexPath:IndexPath) {
        let userId = FIRAuth.auth()?.currentUser?.uid
        let db = self.ref.child(userId!).child("list")
        let dict = self.keys[indexPath.row]
        let one = db.child(dict)
        one.removeValue()
        
        let note = self.list1[indexPath.row]
        
        let incremented = self.ref.child(userId!).child("done").childByAutoId()
        incremented.updateChildValues(["color":note.color,"text":note.text,"date":note.time], withCompletionBlock: { (error, database) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                print(database)
            }
        })
        
        
        
        
        
        self.list1.remove(at: indexPath.row)
        self.keys.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    func deleteNote(indexPath:IndexPath)  {
        let userId = FIRAuth.auth()?.currentUser?.uid
        let db = self.ref.child(userId!).child("list")
        let dict = self.keys[indexPath.row]
        let one = db.child(dict)
        one.removeValue()
        self.list1.remove(at: indexPath.row)
        self.keys.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    
}






















