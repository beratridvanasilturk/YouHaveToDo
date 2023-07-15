//
//  ViewController.swift
//  YouHaveToDo
//
//  Created by Berat Rıdvan Asiltürk on 11.07.2023.
//

// FIXME: Some todo list issues should be fix
import UIKit

class YouHaveToDoViewController: UITableViewController {
    //MARK: - Variables
    
    var items = [ToDoListItem]()
    
      var row0item = ToDoListItem()
      var row1item = ToDoListItem()
      var row2item = ToDoListItem()
      var row3item = ToDoListItem()
      var row4item = ToDoListItem()
    //MARK: - Outlets
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
       
          let item1 = ToDoListItem()
          item1.text = "Walk the dog"
          items.append(item1)

          let item2 = ToDoListItem()
          item2.text = "Brush my teeth"
          item2.chosen = true
          items.append(item2)

          let item3 = ToDoListItem()
          item3.text = "Learn iOS development"
          item3.chosen = true
          items.append(item3)

          let item4 = ToDoListItem()
          item4.text = "Soccer practice"
          items.append(item4)

          let item5 = ToDoListItem()
          item5.text = "Eat ice cream"
          items.append(item5)
        }
    
    
    func configureToDoList(for cell: UITableViewCell, at indexPath: IndexPath){
        
        
        let item = items[indexPath.row]

          if item.chosen {
            cell.accessoryType = .checkmark
          } else {
            cell.accessoryType = .none
          }
        }
    
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YouHaveToDoItem", for: indexPath)
        
        let label = cell.viewWithTag(1000) as! UILabel
        
        if indexPath.row == 0 {
          label.text = row0item.text
        } else if indexPath.row == 1 {
          label.text = row1item.text
        } else if indexPath.row == 2 {
          label.text = row2item.text
        } else if indexPath.row == 3 {
          label.text = row3item.text
        } else if indexPath.row == 4 {
          label.text = row4item.text
        }
        configureToDoList(for: cell, at: indexPath)
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            let item = items[indexPath.row]
            item.chosen.toggle()

            configureToDoList(for: cell, at: indexPath)
          }
          tableView.deselectRow(at: indexPath, animated: true)
        }
    
    
}

