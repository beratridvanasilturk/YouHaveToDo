//
//  AddItemViewController.swift
//  YouHaveToDo
//
//  Created by Berat Rıdvan Asiltürk on 18.07.2023.
//

import UIKit

class AddItemViewController: UITableViewController {

    @IBOutlet var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // Note: sender: Any olmadan text field'dan klavye girisindeki done butonunu bu done butonuna 'did end on exit' olarak birbiriyle senkron biciminde baglayamazsin.
    @IBAction func doneButtonTapped(_ sender: Any) {
        print("Girilen metin: \(textField.text!)")
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Table View Delegates
    // Satir secildikten sonra o satira ait gri arka plan gorunumu kaldirir.
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Bu satir add ekrani acildiginda textfield'a tiklamadan klavyenin hemen acilmasini saglar
        textField.becomeFirstResponder()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
