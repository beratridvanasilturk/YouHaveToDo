//
//  ViewController.swift
//  YouHaveToDo
//
//  Created by Berat Rıdvan Asiltürk on 11.07.2023.
//

// FIXME: Some todo list issues should be fix
import UIKit

class YouHaveToDoViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    //MARK: - Variables
    
    var items = [ToDoListItem]()
    
    //MARK: - Outlets
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item1 = ToDoListItem()
        item1.text = "First Task"
        items.append(item1)
        
        let item2 = ToDoListItem()
        item2.text = "Second Task"
        item2.chosen = true
        items.append(item2)
        
        let item3 = ToDoListItem()
        item3.text = "Third Task"
        item3.chosen = true
        items.append(item3)
        
        let item4 = ToDoListItem()
        item4.text = "Fourth Task"
        items.append(item4)
        
        let item5 = ToDoListItem()
        item5.text = "Fifth Task"
        items.append(item5)
        
        // Uygulamanın Belgeler klasörünün gerçekte nerede olduğunu gosterir.
        print("Documents folder is \(documentsDirectory())")
        print("Data file path is \(dataFilePath())")
    }
    
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
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
    
    func configureText(for cell: UITableViewCell, with item: ToDoListItem) {
        
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    // iOS, dosya sistemindeki dosyalara başvurmak için URL'leri kullanır.
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // dataFilePath() yöntemi, kontrol listesi öğelerini depolayacak dosyanın tam yolunu oluşturmak için documentsDirectory() yöntemini kullanır. Bu dosya Checklists.plist olarak adlandırılır ve Documents klasörünün içinde bulunur.
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("YouHaveToDo.plist")
    }
    // Verileri bir dosyada kaydetme.
    func saveToDoListItems() {
        let encoder = PropertyListEncoder()
        // Encode yöntemi, herhangi bir nedenle veriyi kodlayamazsa swift hata firlatir (error throwing)
        do {
            // try anahtar sözcüğü, encode çağrısının başarısız olabileceği durumda bir hata atacağını belirtir.
            let data = try encoder.encode(items)
            // Let data önceki satırdaki encode çağrısıyla başarıyla oluşturulduysa, datalari dataFilePath() çağrısıyla döndürülen file yolunu kullanarak bir dosyaya yazarsınız. Write yönteminin de hata verebileceğini unutmayın. Bu nedenle, yöntem çağrısından önce başka bir try deyimi kullanmanız gerekir.
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        // Hata yakalama kodu
        } catch {
            // Catch bloğu içinde yazdığınız herhangi bir kodda error değişkenine başvurabilirsiniz. Bu, hatanın kaynağının ne olduğunu belirten açıklayıcı bir hata mesajının çıktısını almak için kullanışlı olabilir.
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "YouHaveToDoItem", for: indexPath)
        
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.chosen.toggle()
            
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Task onay isareti duzenlemesi bittiginde yeni durumu kaydeder
        saveToDoListItems()
    }
    
    // Swipe to Delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // items.remove(at:) dediğinizde, bu yalnızca ToDoListItem'ı arrayden çıkarmakla kalmaz, aynı zamanda onu kalıcı olarak yok eder. Ancak bu ToDoListItem 'ı diziden çıkardığınızda, referans kaybolur ve nesne yok edilir. Ya da bilgisayar dilinde deallocated olur. Bir nesnenin yok edilmesi ARC tarafindan gerceklestirilir.
        items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    // MARK: - Add Item ViewController Delegates
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
        
        // Task silinmesi bittiginde yeni icerigi kaydeder/datadan siler.
        saveToDoListItems()
    }
    
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ToDoListItem) {
        
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
        // Task eklemesi bittiginde yeni icerigi kaydeder
        saveToDoListItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ToDoListItem) {
        
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        // Task duzenlemesi bittiginde yeni icerigi kaydeder
        saveToDoListItems()
    }
    
    
    //MARK: - Actions
    @IBAction func editButtonTapped(_ sender: Any) {
    }
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
}

