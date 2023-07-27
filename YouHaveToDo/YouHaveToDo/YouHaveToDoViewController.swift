//
//  ViewController.swift
//  YouHaveToDo
//
//  Created by Berat Rıdvan Asiltürk on 11.07.2023.
//

import UIKit

class YouHaveToDoViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    //MARK: - Variables
//    var items = [ToDoListItem]()
    
    // Checklist sonundaki unlem isareti viewDidLoad() gerçekleşene kadar değerinin geçici olarak nil olmasını sağlar.
    var checklist: Checklist!
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
// DELETED
//        // .plist dosyasindaki dondurulmus verileri uygulamamiza aktararak daha onceden kaydedilen taskleri ToDoListItem icerisine aktarir.
//        loadToDoListItems()
//
//
        
        // Bu kod satiri navigation bar'da gösterilen ekranın başlığını Checklist nesnesinin adıyla değiştirir
        title = checklist.name
        
        

        
    }
    
    // Segue functionunun segue identifier'a gore duzenlenmesi icin kullanilir
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ToDoListItem) {
        
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.chosen {
            label.text = "👍🏻"
        } else {
            label.text = ""
        }
    }
    // Text editing icin kullanilir
    func configureText(for cell: UITableViewCell, with item: ToDoListItem) {
        
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    
    

    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "YouHaveToDoItem", for: indexPath)
        
        let item = checklist.items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.chosen.toggle()
            
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
       
// DELETED
//        // Task onay isareti duzenlemesi bittiginde yeni durumu kaydeder
//        saveToDoListItems()
    }
    
    // Swipe to Delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // items.remove(at:) dediğinizde, bu yalnızca ToDoListItem'ı arrayden çıkarmakla kalmaz, aynı zamanda onu kalıcı olarak yok eder. Ancak bu ToDoListItem 'ı diziden çıkardığınızda, referans kaybolur ve nesne yok edilir. Ya da bilgisayar dilinde deallocated olur. Bir nesnenin yok edilmesi ARC tarafindan gerceklestirilir.
        checklist.items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    // MARK: - Add Item ViewController Delegates
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)

// DELETED
//        // Task silinmesi bittiginde yeni icerigi kaydeder/datadan siler.
//        saveToDoListItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ToDoListItem) {
        
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
        
// DELETED
//        // Task eklemesi bittiginde yeni icerigi kaydeder
//        saveToDoListItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ToDoListItem) {
        
        if let index = checklist.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        
// DELETED
//        // Task duzenlemesi bittiginde yeni icerigi kaydeder
//        saveToDoListItems()
    }
}
    //MARK: - Actions
    // Satırların her zaman hem veri modelinize hem de tablo görünümüne eklenmesi gerektiğini unutmayın. Tablo görünümüne insertRows(at:with:) mesajını gönderdiğinizde şunu söylemiş olursunuz: "Hey table, data modelime bir grup yeni item eklendi." Bu çok önemlidir! Tablo görünümüne yeni öğelerinizi söylemeyi unutursanız veya tablo görünümüne yeni öğeler olduğunu söyler ancak bunları veri modelinize eklemezseniz uygulamanız çökecektir.
    
    // Delege yontemi kullanildigi icin bu action'a gerek kalmadi.
    //    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
    //
    //        let newRowIndex = items.count
    //        // Yeni bir ToDoListItem nesnesi oluşturuldu.
    //        let item = ToDoListItem()
    //        item.text = "New Row"
    //        // Veri modeline eklendi.
    //        items.append(item)
    //        //Tablo görünümüne yeni satır hakkında bilgi vermemiz gerekir, böylece bu satır için yeni bir hücre ekleyebilir. Dolayısıyla, önce newRowIndex değişkenindeki satır numarasını kullanarak yeni satıra işaret eden bir IndexPath nesnesi oluşturursunuz.
    //        let indexPath = IndexPath(row: newRowIndex, section: 0)
    //        // Bu satır, yalnızca bir index path öğesini tutan yeni, geçici bir dizi oluşturur.
    //        let indexPaths = [indexPath]
    //        // Bu yöntem aslında isterseniz aynı anda birden fazla satır eklemenize olanak tanır.
    //        tableView.insertRows(at: indexPaths, with: .automatic)
    //    }

