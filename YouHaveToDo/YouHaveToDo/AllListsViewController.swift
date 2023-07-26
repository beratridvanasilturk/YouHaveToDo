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

class AllListsViewController: UITableViewController {
    
    // MARK: - Constants
    // Yeni bir table view cell elde etmek için AllListsViewController'da bu islemler (alternatif yol ile) tamamen kod ile olusturulur. Bunun ilk ayagi let cellIdentifier ile baslar. viewDidLoad icerisindeki tableView.register ile devam eder ve cellForRowAt icerisindeki let cell = tableView.dequeueReusableCell ile 3 adimda yeni bir table view cell olusumu tamamlanir. YouHaveToDoViewController'da bunu tek bir adimda (dequeueReusableCell withIdentifier ile tamamlamistik. dequeueReusableCell çağrısı hala burada da mevcut, ancak daha önce storyboard'un bu tanımlayıcıya sahip bir prototip hücresi vardı ama AllListViewController'da yok.)
    let cellIdentifier = "YouHaveToDoCell"
    
    //MARK: - Variables
    var lists = [Checklist]()
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var list = Checklist(name: "Daily Checklist")
        lists.append(list)
        
        
        list = Checklist(name: "Weekly Checklist")
        lists.append(list)
        
        
        list = Checklist(name: "Mountly Checklist")
        lists.append(list)
        
        
        list = Checklist(name: "VI Checklist")
        lists.append(list)
        
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
            let controller = segue.destination as! YouHaveToDoViewController
            controller.checklist = sender as? Checklist
        }
    }
    
}
