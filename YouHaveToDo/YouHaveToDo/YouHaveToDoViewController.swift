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
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
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
            label.text = items[0].text
        } else if indexPath.row == 1 {
            label.text = items[1].text
        } else if indexPath.row == 2 {
            label.text = items[2].text
        } else if indexPath.row == 3 {
            label.text = items[3].text
        } else if indexPath.row == 4 {
            label.text = items[4].text
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
    // Swipe to Delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // items.remove(at:) dediğinizde, bu yalnızca ToDoListItem'ı arrayden çıkarmakla kalmaz, aynı zamanda onu kalıcı olarak yok eder. Ancak bu ToDoListItem 'ı diziden çıkardığınızda, referans kaybolur ve nesne yok edilir. Ya da bilgisayar dilinde deallocated olur. Bir nesnenin yok edilmesi ARC tarafindan gerceklestirilir.
        items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
        //MARK: - Actions
    // Satırların her zaman hem veri modelinize hem de tablo görünümüne eklenmesi gerektiğini unutmayın. Tablo görünümüne insertRows(at:with:) mesajını gönderdiğinizde şunu söylemiş olursunuz: "Hey table, data modelime bir grup yeni item eklendi." Bu çok önemlidir! Tablo görünümüne yeni öğelerinizi söylemeyi unutursanız veya tablo görünümüne yeni öğeler olduğunu söyler ancak bunları veri modelinize eklemezseniz uygulamanız çökecektir.
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        let newRowIndex = items.count
        // Yeni bir ToDoListItem nesnesi oluşturuldu.
        let item = ToDoListItem()
        item.text = "New Row"
        // Veri modeline eklendi.
        items.append(item)
        //Tablo görünümüne yeni satır hakkında bilgi vermemiz gerekir, böylece bu satır için yeni bir hücre ekleyebilir. Dolayısıyla, önce newRowIndex değişkenindeki satır numarasını kullanarak yeni satıra işaret eden bir IndexPath nesnesi oluşturursunuz.
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        // Bu satır, yalnızca bir index o path öğesini tutan yeni, geçici bir dizi oluşturur.
        let indexPaths = [indexPath]
        // Bu yöntem aslında isterseniz aynı anda birden fazla satır eklemenize olanak tanır.
        tableView.insertRows(at: indexPaths, with: .automatic)
        
    }
    
}

