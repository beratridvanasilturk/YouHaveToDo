//
//  DataModel.swift
//  YouHaveToDo
//
//  Created by Berat Rıdvan Asiltürk on 28.07.2023.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    // Tum UserDefaults ogelerini DataModel'e tasiyalim
    // Calculated Var
    var indexOfSelectedChecklists: Int {
        
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        } set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
            }
        }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Uygulamanın Belgeler klasörünün nerede olduğunu gosterir. Bunu .plist'i bulmak icin kullanacagiz. Gerektiginde .plist dosyasini temizleyerek localde tutulan verileri similatorden temizlemek icin de kullanacagiz.
//        print("Documents folder is \(documentsDirectory())")
//        print("Data file path is \(dataFilePath())")
//    }
    
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
    
    // UserDefaults, kendisinden bir anahtar istediğinizde ve bu anahtar için bir değer bulamadığında bu sözlükteki varsayilan değerleri kullanacaktır.
    func registerDefaults() {

        let dictionary = [ "ChecklistIndex": -1, "FirstTime": true ] as [String : Any]
        
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firtTime = userDefaults.bool(forKey: "FirstTime")
        // FirstTime degeri true ise uygulama ilk defa calistiriliyor demektir
        if firtTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            indexOfSelectedChecklists = 0
            userDefaults.set(false, forKey: "FirstTime")
        }
    }
    
}
