//
//  ViewController.swift
//  YouHaveToDo
//
//  Created by Berat Rıdvan Asiltürk on 11.07.2023.
//

import UIKit

class YouHaveToDoViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    //MARK: - Variables
    var items = [ToDoListItem]()
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // .plist dosyasindaki dondurulmus verileri uygulamamiza aktararak daha onceden kaydedilen taskleri ToDoListItem icerisine aktarir.
        loadToDoListItems()
        
        // Uygulamanın Belgeler klasörünün nerede olduğunu gosterir. Bunu .plist'i bulmak icin kullanacagiz. Gerektiginde .plist dosyasini temizleyerek localde tutulan verileri similatorden temizlemek icin de kullanacagiz.
        print("Documents folder is \(documentsDirectory())")
        print("Data file path is \(dataFilePath())")
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
    // Text editing icin kullanilir
    func configureText(for cell: UITableViewCell, with item: ToDoListItem) {
        
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    // iOS, dosya sistemindeki dosyalara başvurmak için URL'leri kullanır.
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // dataFilePath() functionu, todolist öğelerini depolayacak dosyanın tam yolunu oluşturmak için documentsDirectory() yöntemini kullanır. Bu dosya YouHaveToDoList.plist olarak adlandırılır ve Documents klasörünün içinde bulunur.
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
    
    // Dosyadan veri okuma, saveToDoListItems functionunun tam tersi seklinde daha once var olan/kaydedilen veriyi okuruz.
    // Bu kod satiri arraylari YouHaveToDoList.plist dosyasında dondurulmuş olan ToDoListItem nesnelerinin tam kopyalarıyla doldurur.
    func loadToDoListItems() {
        // dataFilePath() functionunun sonuçlarını path adlı geçici bir sabite koyarsınız.
        let path = dataFilePath()
        // YouHaveToDo.plist'in içeriğini yeni bir Data nesnesine yüklemeyi dener
        // try? komutu Data nesnesini oluşturmaya çalışır, ancak başarısız olursa nil döndürür. Bu yüzden bir if let deyimi içine konur. .plist dosyası yoksa, yüklenecek ToDoListItem nesnesi de yoktur bu yuzden basarisiz olmasi ihtimaline karsi if let seklinde olusturulur. Bu durum bu uygulama ilk kez baslatildiginda olan seydir yani henuz YouHaveToDo.plist dosyasi mevcut degildir en basta.
        if let data = try? Data(contentsOf: path) {
            // Uygulama .plist dosyasıni bulduğunda, bir PropertyListDecoder kullanarak tüm diziyi ve içeriğini dosyadan yükleyeceksiniz. Yani decoder sabitine atar.
            let decoder = PropertyListDecoder()
            do {
                // Kaydedilen verileri decoder'in decode yöntemini kullanarak itemlere (items)'e geri yükler. Burada ilgilenilen tek öğe decode'a aktarılan ilk parametre olacaktır. Decoder'in decode işleminin sonucunda ne tür bir data olacağını bilmesi gerekir ve siz de bunun ToDoListItem nesnelerinden oluşan bir Array olacağını belirterek bunu bilmesini sağlarsınız.
                items = try decoder.decode([ToDoListItem].self, from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
        // Artık loadToDoListItem() yönteminiz var, ancak bunun çalışması için bir yerden çağrılması gerekiyor. Bunu yapabileceğiniz birkaç yer vardır. viewDidLoad su asamada dondurulmus verileri uygulamamamiza yukleyecegimiz en mantikli durum konumundadir.
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

