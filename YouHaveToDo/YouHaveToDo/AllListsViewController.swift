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

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Constants
    // Yeni bir table view cell elde etmek için AllListsViewController'da bu islemler (alternatif yol ile) tamamen kod ile olusturulur. Bunun ilk ayagi let cellIdentifier ile baslar. viewDidLoad icerisindeki tableView.register ile devam eder ve cellForRowAt icerisindeki let cell = tableView.dequeueReusableCell ile 3 adimda yeni bir table view cell olusumu tamamlanir. YouHaveToDoViewController'da bunu tek bir adimda (dequeueReusableCell withIdentifier ile tamamlamistik. dequeueReusableCell çağrısı hala burada da mevcut, ancak daha önce storyboard'un bu tanımlayıcıya sahip bir prototip hücresi vardı ama AllListViewController'da yok.)
    let cellIdentifier = "YouHaveToDoCell"
    
    //MARK: - Variables
    var dataModel: DataModel!
    
    // MARK: - Stubs
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        let newRowIndex = dataModel.lists.count
        dataModel.lists.append(checklist)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        if let index = dataModel.lists.firstIndex(of: checklist) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel!.text = checklist.name
            }
        }
    }
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Bu kod satiri cell identifier'imizi table view'e kaydeder, böylece table view, bu cell identifier ile bir dequeue isteği geldiğinde yeni bir table view cell örneği oluşturmak için hangi cell sınıfının kullanılması gerektiğini bilir. Ayrıca, bu durumda, standart table view cell sınıfını yeni cell'ler oluşturmak için kullanılacak sınıf olarak kaydettik,
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
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
            
            print("prepare")
        }
    }
    
    // Show the last open list
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self

        let index = UserDefaults.standard.integer(forKey: "ChecklistIndex")
        if index != -1 {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)

            print("viewDidAppear")
        }
    }
    
    //MARK: - Navigation Controller Delegates
    // Bu yöntem, navigasyon denetleyicisi yeni bir ekran gösterdiğinde çağrılır.
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // Is back button tapped?
        // Note: === operatörü, iki nesnenin bellekte aynı nesneyi gösterip göstermediğini kontrol eder.
        if viewController === self {
            UserDefaults.standard.set(-1, forKey: "ChecklistIndex")
            //  Geri düğmesine basıldıysa, yeni görünüm denetleyicisi AllListsViewController 'ın kendisidir ve UserDefaults 'taki " ChecklistIndex " değerini -1 olarak ayarlarsınız, bu da şu anda hiçbir kontrol listesinin seçili olmadığı anlamına gelir.
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Bu yöntemin daha önce yaptığına ek olarak, şimdi seçilen satırın indeksini "ChecklistIndex" anahtarı altında UserDefaults 'ta saklıyorsunuz.
        UserDefaults.standard.set(indexPath, forKey: "ChecklistIndex")
        
        let checklist = dataModel.lists[indexPath.row]
        // performSegue'nin yönteminin daha önce nil olarak ayarladığımiz bir sender parametresi vardı. Şimdi bunu, kullanıcının dokunduğu satırdaki Checklist nesnesini göndermek için kullanacagiz.
        // Checklist nesnesini sender parametresine koymak henüz YouHaveToDoViewController'a o nesneyi iletmez. Bu view controller için bu adimdan sonra eklenmesi gereken "prepare-for-segue" içinde gerçekleşecektir.
        performSegue(withIdentifier: "ShowYouHaveToDo", sender: checklist)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    // Segue'nin kod ile yazilmasi ornegidir. View Controller bir storyboard'a gömülüdür ve storyboard nesnesinden bunu yüklemesini istemeniz gerekir.View Controller'lar her zaman bir storyboard 'dan yüklenmediği için storyboard özelliği isteğe bağlıdır.
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // Storyboar'dan yeni view controller olusturulmasi istenir. (identifier ile bu durumda ListDetailVC) Ve bu adim sonrasinda ListDetailViewController scene'de Storyboar ID'yi ListDetailVC olarak ayarlariz.
        let controller = storyboard?.instantiateViewController(withIdentifier: "ListDetailVC") as! ListDetailViewController
        controller.delegate = self
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        navigationController?.pushViewController(controller, animated: true)
    }
    
}


// MARK: - ALL NOTES IN THIS PROJECT:
    // === operatörü, iki nesnenin bellekte aynı nesneyi gösterip göstermediğini kontrol eder. Yani işlenenlerin aynı nesneye atıfta bulunup bulunmadığını kontrol eder.
    // ORNEGIN:
    // let arr1 = NSArray(array: [1, 2])
    // let arr2 = NSArray(array: [1, 2])
    // let arr3 = arr2
    // print(arr2 === arr3) // true
    // print(arr1 === arr2) // false

    // Table view cell oluşturmanın dört yolu vardır:
    // 1: Prototip hücreler kullanarak. Bu en basit ve en hızlı yoldur. Bunu YouHaveToDoViewController'da yaptık.
    // 2: Statik hücreler kullanma. Bunu Item Ekle/Düzenle ekranı için yaptik. Statik hücreler, hangi hücrelere sahip olacağınızı önceden bildiğiniz ekranlarla sınırlıdır. Statik hücrelerin en büyük avantajı, veri kaynağı yöntemlerinden(cellForRowAt vb.) herhangi birini sağlamanıza gerek olmamasıdır.
    // 3: Bir nib dosyası kullanma. Bir nib (XIB olarak da bilinir), yalnızca tek bir özelleştirilmiş UITableViewCell nesnesi içeren mini bir storyboard gibidir.
    // 4: Burada AllListsViewController orneginde yapilanlar gibi tamamiyle elle kod yazarak table view cell olusturulur.

    // Type cast, Swift'e bir değeri farklı bir veri türüne sahipmiş gibi yorumlamasını söyler.

    // Opsiyonellerin her zaman variable olması gerektiğini unutmayın.

    // iOS uygulamanızda sahne başına yalnızca bir UIWindow nesnesi vardır. iOS'ta birden fazla pencereye sahip olmak istediğinizde, ek sahneler oluşturmanız gerekir.

    // .PLIST: Uygulamanın Belgeler klasörünün nerede olduğunu gosterir. Bunu .plist'i bulmak icin kullanacagiz. Gerektiginde .plist dosyasini temizleyerek localde tutulan verileri similatorden temizlemek icin de kullanacagiz.
    //        print("Documents folder is \(documentsDirectory())")
    //        print("Data file path is \(dataFilePath())")

