//
//  AddItemViewController.swift
//  YouHaveToDo
//
//  Created by Berat Rıdvan Asiltürk on 18.07.2023.
//

import UIKit
// Kullanici cancel butonuna tikladiginda cagrilan 1 func, done butonuna tikladiginda cagrilan 2 func vardir.
protocol ItemDetailViewControllerDelegate: AnyObject {
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    // didFinishAdding parametresi yeni ToDoListItem nesnesini iletir.
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ToDoListItem)
    // Yeni bir öğe ekledikten sonra didFinishAdding yöntemini çağırırsınız, ancak mevcut bir öğeyi düzenlerken artık bunun yerine didFinishEditing yöntemi çağrılmalıdır.
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ToDoListItem)
    
}

// Class'a delege atamamiz tek basina bir anlam ifade etmez. Text Field'a kendisi için bir temsilcisi olduğunu bildirmemiz gerekir.
class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    // MARK: - Variables
    weak var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: ToDoListItem?
    // MARK: - Outlets
    @IBOutlet var doneBarButton: UIBarButtonItem!
    @IBOutlet var cancelBarButton: UIBarButtonItem!
    @IBOutlet var textField: UITextField!
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This name is "variable shadowing". Ve unwrapp edilirken yaygin kullanilan bir durumdur.
        if let itemToEdit = itemToEdit {
            title = "Edit Item"
            textField.text = itemToEdit.text
            doneBarButton.isEnabled = true
        }
    }

    // MARK: - Actions
    // Note: "sender: Any" seklindeki yapi baska bir sender biciminde olursa (any haricinde) text field'dan klavye girisindeki done butonunu bu done butonuna 'did end on exit' olarak birbiriyle senkron biciminde baglayamazsin.
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        // Kullanıcı İptal düğmesine dokunduğunda, itemDetailViewControllerDidCancel(_:) mesajını delegeye geri gönderirsiniz.
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        // İlk olarak itemToEdit özelliğinin bir nesne içerip içermediğini kontrol eder. Nil degilse metin alanındaki metni o anki mevcut ToDoListItem nesnesine yerleştirir ve ardından yeni temsilci yöntemini çağırırsınız.
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        } else {
            // itemToEdit öğesinin nil olması durumunda, kullanıcı yeni bir öğe ekler.
            let item = ToDoListItem()
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    // MARK: - Table View Delegates
    // Satir secildikten sonra o satira ait gri arka plan gorunumu kaldirir.
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    // MARK: - Text Field Delegates
    override func viewWillAppear(_ animated: Bool) {
        // Bu satir add ekrani acildiginda textfield'a tiklamadan klavyenin hemen acilmasini saglar
        textField.becomeFirstResponder()
    }
    // Bu kod satirinin amaci Done button'unu text fieldda metin olmadigi durumlarda devre disi birakarak bos bir task'i todo listemize eklemeyi onlemektir.
    // Bu kod satiri UITextField delege yontemlerinden biridir. Kullanici klavyeye her dokundugunda veya cut/paste yoluyla metni her degistirdiginde cagrilir. "textField(_:shouldChangeCharactersIn:replacementString:)" delege yöntemi size yeni metni vermez, yalnızca metnin hangi kısmının değiştirilmesi gerektiğini verir.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Yukarıdaki kodda, NSRange olarak bir parametre alırsınız ve bunu bir Range değerine dönüştürürsünüz. Orjinal NSRange değerini neden bir Range değerine dönüştürdüğümüzü merak edebilirsiniz. NSRange bir Objective-C yapısıdır, Range ise Swift eşdeğeridir.
        
        // Ilk olarak yeni metnin ne olacagini belirleriz
        // Text Field'in metnini alarak ve değiştirme işlemini kendiniz yaparak yeni metnin ne olacağını hesaplamanız gerekir. Bu size newText sabitinde sakladığınız yeni bir array nesnesi verir.
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(
            in: stringRange,
            with: string)
        
        // Yeni metni oluşturduktan sonra, boş olup olmadığını kontrol edip ve Done düğmesini buna göre etkinleştirir veya devre dışı bırakıriz.
        if newText.isEmpty {
            doneBarButton.isEnabled = false
        } else {
            doneBarButton.isEnabled = true
        }
        // Yukaridaki if else yerine basitlestirilmis olarak "doneBarButton.isEnabled = !newText.isEmpty" kullanabilirdik.
        return true
    }
    
    // Bu kod satiri Main'de text field'daki "clear button" seceneginin "appeirs while editing" secenegi seciliyken clear dugmesini dogru sekilde islemek ve done buttonu devre disi birakmak icin kullanilir.
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}


