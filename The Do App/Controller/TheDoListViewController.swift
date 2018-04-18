//
//  ViewController.swift
//  The Do App
//
//  Created by Nick John on 4/16/18.
//  Copyright © 2018 Nick John. All rights reserved.
//

import UIKit

class TheDoListViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    
    
    var itemArray = [ToDoItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item = ToDoItem()
        item.text = "Buy Molly"
        itemArray.append(item)
        
        let item2 = ToDoItem()
        item2.text = "Buy Weed"
        itemArray.append(item2)

        let item3 = ToDoItem()
        item3.text = "Buy Mushrooms"
        itemArray.append(item3)
        
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [ToDoItem] {
            itemArray = items
        } }
    
    //MARK - Add Button Functionality
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New The Do Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when user clicks add button on Alert.
            let newItem = ToDoItem()
            newItem.text = textField.text!
            
       self.itemArray.append(newItem)
            self.defaults.setValue(self.itemArray, forKey: "ToDoListArray") as! [ToDoItem]
            
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
      
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return itemArray.count
    }
    
    //MARK - TableViewMethods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TheDoItemCell")!
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.text
       
        // ternary operator below
        cell.accessoryType = item.accessory ? .checkmark : .none
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        tableView.deselectRow(at: indexPath, animated: true)
        
        itemArray[indexPath.row].accessory = !itemArray[indexPath.row].accessory
    
        
        tableView.reloadData()
        
        
        
        
       
    }
}






