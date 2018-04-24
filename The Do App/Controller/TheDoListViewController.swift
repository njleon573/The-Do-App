//
//  ViewController.swift
//  The Do App
//
//  Created by Nick John on 4/16/18.
//  Copyright © 2018 Nick John. All rights reserved.
//

import UIKit
import CoreData

class TheDoListViewController: UITableViewController {
    

    
    var itemArray = [ToDoItem]()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
       
        
//        let item = ToDoItem()
//        item.text = "Buy Molly"
//        itemArray.append(item)
//
//        let item2 = ToDoItem()
//        item2.text = "Buy Weed"
//        itemArray.append(item2)
//
//        let item3 = ToDoItem()
//        item3.text = "Buy Mushrooms"
//        itemArray.append(item3)
//
//
//        if let items = defaults.array(forKey: "ToDoListArray") as? [ToDoItem] {
//            itemArray = items
         }
    
    //MARK - Add Button Functionality
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New The Do Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when user clicks add button on Alert.
            
            
            let newItem = ToDoItem(context: self.context)
            newItem.text = textField.text!
            newItem.accessory = false
            newItem.parentCategory = self.selectedCategory
            
       self.itemArray.append(newItem)
   self.saveData()
        
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
    
    //MARK: - TableViewMethods
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
   saveData()
    }
    
    //MARK: - CoreData Methods
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }
    

    
    func loadItems(with request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.categoryName MATCHES %@", selectedCategory!.categoryName!)
        
        if let selectedPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, selectedPredicate])
            request.predicate = compoundPredicate
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data. \(error)")
        }
        tableView.reloadData()
    }
    
}

//MARK: - SearchBar Methods
extension TheDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print("SEARCH BAR HIT!!!")
        
        let predicate = NSPredicate(format: "text CONTAINS[cd] %@", searchBar.text!)
        
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
     
        loadItems(predicate: predicate)
        
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        } else {
           let predicate = NSPredicate(format: "text CONTAINS[cd] %@", searchBar.text!)
            loadItems(predicate: predicate)
        }
    }
}






