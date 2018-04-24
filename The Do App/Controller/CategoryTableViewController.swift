//
//  CategoryTableViewController.swift
//  The Do App
//
//  Created by Nick John on 4/21/18.
//  Copyright © 2018 Nick John. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
   
    }

    //MARK: - TableView Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "categoryCell")
        
        cell.textLabel?.text = categoryArray[indexPath.row].categoryName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TheDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    


    @IBAction func addButtonPRessed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (addTextField) in
            addTextField.placeholder = "Type New Category Here"
            textField = addTextField
        }
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
        let newCategory = Category(context: self.context)
            newCategory.categoryName = textField.text!
            self.categoryArray.append(newCategory)
            
            self.saveData()
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - CoreData Methods
    
    func saveData() {
        do{
            try context.save()
        }catch {
            print("Error saving Context, \(error)")
        }
        tableView.reloadData()
    }
        
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
            do {
                categoryArray = try context.fetch(request)
            }catch {
                print("Error loading Data, \(error)")
            }
            tableView.reloadData()
            
        
    }
    

}
