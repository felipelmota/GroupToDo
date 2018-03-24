//
//  GroupToDoTableViewController.swift
//  MyBase
//
//  Created by Felipe Mota on 24/03/18.
//  Copyright © 2018 Daniel Macedo. All rights reserved.
//

import UIKit
import Firebase

class GroupToDoTableViewController: UITableViewController {
    var ref: FIRDatabaseReference!
    var items:[Item] = [Item]()
    
    
    @IBAction func sair(_ sender: Any) {
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            self.dismiss(animated: true, completion: nil)
        } catch let error as NSError {
            print("Nao conseguimos sair: \(error)")
        }
    }
    
    @IBAction func addTask(_ sender: Any) {
        let alert = UIAlertController(title: "Nova Tareda", message: "Digite o titule da nova tarefa:", preferredStyle: .alert)
        
        alert.addTextField { (textField) in }
        
        let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        let saveAction = UIAlertAction.init(title: "Salvar", style: .default) { (action) in
            print("Ok")
            
            let title = alert.textFields![0].text!
            let addedBy = FIRAuth.auth()?.currentUser?.email!
            let newItem = Item.init(title: title, addedBy: addedBy, completed: false, ref: nil)
            
            self.ref.child("items").childByAutoId().setValue(newItem.toAnyObject())
        }
        
        alert.addAction(closeAction)
        alert.addAction(saveAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        
        self.ref.child("items").observeSingleEvent(of:.value, with: { (snapshot) in
            self.items.removeAll()
            for childSnapshot in snapshot.children {
                let child = childSnapshot as! FIRDataSnapshot
                let value = child.value as! [String: Any]
                
                let newItem = Item(title: value["title"] as? String, addedBy: value["addedBy"] as? String, completed: value["completed"] as! Bool, ref:child.ref)
                
                self.items.append(newItem)
                self.tableView.reloadData()
            }
        })
        
        self.ref.child("items").observe(.childAdded, with: { (snapshot) in
            let value = snapshot.value as! [String: Any]
            
            let newItem = Item(title: value["title"] as? String, addedBy: value["addedBy"] as? String, completed: value["completed"] as! Bool, ref:snapshot.ref)
            
            self.items.append(newItem)
            let indexPath = IndexPath(row: self.items.count - 1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .fade)
        })
        
        self.ref.child("items").observe(.childRemoved, with: { (snapshot) in
            let key = snapshot.key
            
            for (index, item) in self.items.enumerated() {
                if item.ref!.key == key {
                    self.items.remove(at: index)
                    let indexPath = IndexPath(row: index, section: 0)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    break;
                }
            }
            
            
        })
        
        self.ref.child("items").observe(.childChanged, with: { (snapshot) in
            let key = snapshot.key
            let updatedValue = snapshot.value as! [String:Any]
            
            for (index, item) in self.items.enumerated() {
                if item.ref!.key == key {
                    self.items[index].title = updatedValue["title"] as? String
                    self.items[index].addedBy = updatedValue["addedBy"] as? String
                    self.items[index].completed = updatedValue["completed"] as! Bool
                    break;
                }
            }
            
            self.tableView.reloadData()
        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        
        let item = self.items[indexPath.row]
        cell.textLabel?.text = item.title!
        cell.detailTextLabel?.text = "Adicionado por \(item.addedBy!)"

        if(item.completed) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        let newValue = !item.completed
        
        item.ref?.updateChildValues(["completed": newValue])
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = self.items[indexPath.row]
            item.ref?.removeValue()
        }
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
