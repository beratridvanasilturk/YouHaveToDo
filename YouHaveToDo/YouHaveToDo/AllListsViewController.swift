//
//  AllList ViewController.swift
//  YouHaveToDo
//
//  Created by Berat Rıdvan Asiltürk on 25.07.2023.
//

// Table view cell oluşturmanın dört yolu vardır:
// 1: Prototip hücreler kullanarak. Bu en basit ve en hızlı yoldur. Bunu YouHaveToDoViewController'da yaptık.
// 2: Statik hücreler kullanma. Bunu Item Ekle/Düzenle ekranı için yaptik. Statik hücreler, hangi hücrelere sahip olacağınızı önceden bildiğiniz ekranlarla sınırlıdır. Statik hücrelerin en büyük avantajı, veri kaynağı yöntemlerinden(cellForRowAt vb.) herhangi birini sağlamanıza gerek olmamasıdır.
// 3: Bir nib dosyası kullanma. Bir nib (XIB olarak da bilinir), yalnızca tek bir özelleştirilmiş UITableViewCell nesnesi içeren mini bir storyboard gibidir.
// 4: Burada AllListsViewController orneginde yapilanlar gibi tamamiyle elle kod yazarak table view cell olusturulur.


import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate {
    
    // MARK: - Stubs
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        let newRowIndex = lists.count
        lists.append(checklist)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        if let index = lists.firstIndex(of: checklist) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel!.text = checklist.name
            }
        }
    }
    
    // MARK: - Constants
    // Yeni bir table view cell elde etmek için AllListsViewController'da bu islemler (alternatif yol ile) tamamen kod ile olusturulur. Bunun ilk ayagi let cellIdentifier ile baslar. viewDidLoad icerisindeki tableView.register ile devam eder ve cellForRowAt icerisindeki let cell = tableView.dequeueReusableCell ile 3 adimda yeni bir table view cell olusumu tamamlanir. YouHaveToDoViewController'da bunu tek bir adimda (dequeueReusableCell withIdentifier ile tamamlamistik. dequeueReusableCell çağrısı hala burada da mevcut, ancak daha önce storyboard'un bu tanımlayıcıya sahip bir prototip hücresi vardı ama AllListViewController'da yok.)
    let cellIdentifier = "YouHaveToDoCell"
    
    //MARK: - Variables
    var lists = [Checklist]()
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // .plist dosyasindaki dondurulmus verileri uygulamamiza aktararak daha onceden kaydedilen taskleri ToDoListItem icerisine aktarir.
        loadChecklists()
        
        // Uygulamanın Belgeler klasörünün nerede olduğunu gosterir. Bunu .plist'i bulmak icin kullanacagiz. Gerektiginde .plist dosyasini temizleyerek localde tutulan verileri similatorden temizlemek icin de kullanacagiz.
        print("Documents folder is \(documentsDirectory())")
        print("Data file path is \(dataFilePath())")
        
        // Bu kod satiri cell identifier'imizi table view'e kaydeder, böylece table view, bu cell identifier ile bir dequeue isteği geldiğinde yeni bir table view cell örneği oluşturmak için hangi cell sınıfının kullanılması gerektiğini bilir. Ayrıca, bu durumda, standart table view cell sınıfını yeni cell'ler oluşturmak için kullanılacak sınıf olarak kaydettik,
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let checklist = lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let checklist = lists[indexPath.row]
        // performSegue'nin yönteminin daha önce nil olarak ayarladığımiz bir sender parametresi vardı. Şimdi bunu, kullanıcının dokunduğu satırdaki Checklist nesnesini göndermek için kullanacagiz.
        // Checklist nesnesini sender parametresine koymak henüz YouHaveToDoViewController'a o nesneyi iletmez. Bu view controller için bu adimdan sonra eklenmesi gereken "prepare-for-segue" içinde gerçekleşecektir.
        performSegue(withIdentifier: "ShowYouHaveToDo", sender: checklist)
    }
    
    // prepare funtion'u bir view controller'dan segue gerçekleşmeden hemen önce çağrılan hazirlik durumunda gerceklesir.  Burada, görünür hale gelmeden önce yeni view controller'in özelliklerini ayarlama şansımiz olur.
    // prepare(for:sender:) içinde, YouHaveToDoViewController'a kullanıcının dokunduğu satırdaki Checklist nesnesini geçirmemiz gerekir. Bu nesneyi daha önce sender parametresine koymamızın sebebi budur. (didselectrowat'da)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowYouHaveToDo" {
            // Note: Type cast, Swift'e bir değeri farklı bir veri türüne sahipmiş gibi yorumlamasını söyler.
            //  as!: değeri belirttiğiniz türde olmaya zorlar, type cast'ın başarısız olma olasılığı yoktur. Bu nedenle, YuHaveToDoViewController'a özgü özelliklerden herhangi birine erişmeden önce onu genel olan UIViewController türünden bu uygulamada kullanılan özel türe (YouHaveToDoViewController) dönüştürmeniz gerekir.
            
            let controller = segue.destination as! YouHaveToDoViewController
            controller.checklist = sender as? Checklist
            
        } else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    // Segue'nin kod ile yazilmasi ornegidir. View Controller bir storyboard'a gömülüdür ve storyboard nesnesinden bunu yüklemesini istemeniz gerekir.View Controller'lar her zaman bir storyboard 'dan yüklenmediği için storyboard özelliği isteğe bağlıdır.
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // Storyboar'dan yeni view controller olusturulmasi istenir. (identifier ile bu durumda ListDetailVC) Ve bu adim sonrasinda ListDetailViewController scene'de Storyboar ID'yi ListDetailVC olarak ayarlariz.
        let controller = storyboard?.instantiateViewController(withIdentifier: "ListDetailVC") as! ListDetailViewController
        controller.delegate = self
        let checklist = lists[indexPath.row]
        controller.checklistToEdit = checklist
        navigationController?.pushViewController(controller, animated: true)
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
    func saveChecklists() {
        let encoder = PropertyListEncoder()
        // Encode yöntemi, herhangi bir nedenle veriyi kodlayamazsa swift hata firlatir (error throwing)
        do {
            // try anahtar sözcüğü, encode çağrısının başarısız olabileceği durumda bir hata atacağını belirtir.
            let data = try encoder.encode(lists)
            // Let data önceki satırdaki encode çağrısıyla başarıyla oluşturulduysa, datalari dataFilePath() çağrısıyla döndürülen file yolunu kullanarak bir dosyaya yazarsınız. Write yönteminin de hata verebileceğini unutmayın. Bu nedenle, yöntem çağrısından önce başka bir try deyimi kullanmanız gerekir.
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
            // Hata yakalama kodu
        } catch {
            // Catch bloğu içinde yazdığınız herhangi bir kodda error değişkenine başvurabilirsiniz. Bu, hatanın kaynağının ne olduğunu belirten açıklayıcı bir hata mesajının çıktısını almak için kullanışlı olabilir.
            print("Error encoding list array: \(error.localizedDescription)")
        }
    }
    
    // Dosyadan veri okuma, saveChecklist functionunun tam tersi seklinde daha once var olan/kaydedilen veriyi okuruz.
    func loadChecklists() {
        // dataFilePath() functionunun sonuçlarını path adlı geçici bir sabite koyarsınız.
        let path = dataFilePath()
        // YouHaveToDo.plist'in içeriğini yeni bir Data nesnesine yüklemeyi dener
        // try? komutu Data nesnesini oluşturmaya çalışır, ancak başarısız olursa nil döndürür. Bu yüzden bir if let deyimi içine konur. .plist dosyası yoksa, yüklenecek ToDoListItem nesnesi de yoktur bu yuzden basarisiz olmasi ihtimaline karsi if let seklinde olusturulur. Bu durum bu uygulama ilk kez baslatildiginda olan seydir yani henuz YouHaveToDo.plist dosyasi mevcut degildir en basta.
        if let data = try? Data(contentsOf: path) {
            // Uygulama .plist dosyasıni bulduğunda, bir PropertyListDecoder kullanarak tüm diziyi ve içeriğini dosyadan yükleyeceksiniz. Yani decoder sabitine atar.
            let decoder = PropertyListDecoder()
            do {
                // Kaydedilen verileri decoder'in decode yöntemini kullanarak itemlere (items)'e geri yükler. Burada ilgilenilen tek öğe decode'a aktarılan ilk parametre olacaktır. Decoder'in decode işleminin sonucunda ne tür bir data olacağını bilmesi gerekir ve siz de bunun Checklist nesnelerinden oluşan bir Array olacağını belirterek bunu bilmesini sağlarsınız.
                lists = try decoder.decode([Checklist].self, from: data)
            } catch {
                print("Error decoding list array: \(error.localizedDescription)")
            }
        }
        // Artık loadChecklist() yönteminiz var, ancak bunun çalışması için bir yerden çağrılması gerekiyor. Bunu yapabileceğiniz birkaç yer vardır. viewDidLoad su asamada dondurulmus verileri uygulamamamiza yukleyecegimiz en mantikli durum konumundadir.
    }
}
