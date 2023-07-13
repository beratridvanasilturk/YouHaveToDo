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
    var row0chosen = false
    var row1chosen = false
    var row2chosen = false
    var row3chosen = false
    var row4chosen = false
    //MARK: - Outlets
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureToDoList(for cell: UITableViewCell, at indexPath: IndexPath){
        
        
        var isChecked = false
        
        if indexPath.row == 0 {
            isChecked = row0chosen
        }
        if indexPath.row == 1 {
            isChecked = row1chosen
        }
        if indexPath.row == 2 {
            isChecked = row2chosen
        }
        if indexPath.row == 3 {
            isChecked = row3chosen
        }
        if indexPath.row == 4 {
            isChecked = row4chosen

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
            label.text = "1. Row"
        } else if indexPath.row == 1 {
            
            label.text = "2. Row"
        } else if indexPath.row == 2 {
            label.text = "3. Row"
        } else if indexPath.row == 3 {
            label.text = "4. Row"
        } else if indexPath.row == 4 {
            label.text = "5. Row"
        }
        
        configureToDoList(for: cell, at: indexPath)
        return cell
        //MARK: - Actions
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
          if indexPath.row == 0 {
            row0chosen.toggle()
          } else if indexPath.row == 1 {
            row1chosen.toggle()
          } else if indexPath.row == 2 {
            row2chosen.toggle()
          } else if indexPath.row == 3 {
            row3chosen.toggle()
          } else if indexPath.row == 4 {
            row4chosen.toggle()
          }
          configureToDoList(for: cell, at: indexPath)
        }
        tableView.deselectRow(at: indexPath, animated: true)
      }
    
    
}

