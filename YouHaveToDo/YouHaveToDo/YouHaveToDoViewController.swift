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
      var row0item = ToDoListItem()
      var row1item = ToDoListItem()
      var row2item = ToDoListItem()
      var row3item = ToDoListItem()
      var row4item = ToDoListItem()
    //MARK: - Outlets
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureToDoList(for cell: UITableViewCell, at indexPath: IndexPath){
        
        
        var isChecked = false
        
        if indexPath.row == 0 {
          isChecked = row0item.chosen
        } else if indexPath.row == 1 {
          isChecked = row1item.chosen
        } else if indexPath.row == 2 {
          isChecked = row2item.chosen
        } else if indexPath.row == 3 {
          isChecked = row3item.chosen
        } else if indexPath.row == 4 {
          isChecked = row4item.chosen
        }

        
        if isChecked == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
    }
        
        
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
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
            
            if indexPath.row == 0 {
              row0item.chosen.toggle()
            } else if indexPath.row == 1 {
              row1item.chosen.toggle()
            } else if indexPath.row == 2 {
              row2item.chosen.toggle()
            } else if indexPath.row == 3 {
              row3item.chosen.toggle()
            } else if indexPath.row == 4 {
              row4item.chosen.toggle()
            }
          configureToDoList(for: cell, at: indexPath)
        }
        tableView.deselectRow(at: indexPath, animated: true)
      }
    
    
}

