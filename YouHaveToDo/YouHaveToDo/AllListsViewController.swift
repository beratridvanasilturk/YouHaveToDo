//
//  AllList ViewController.swift
//  YouHaveToDo
//
//  Created by Berat Rıdvan Asiltürk on 25.07.2023.
//

import UIKit

class AllListsViewController: UITableViewController {

    // MARK: - Constants
    let cellIdentifier = "YouHaveToDoCell"
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Bu kod satiri cell identifier'imizi table view'e kaydeder, böylece table view, bu cell identifier ile bir dequeue isteği geldiğinde yeni bir table view cell örneği oluşturmak için hangi cell sınıfının kullanılması gerektiğini bilir. Ayrıca, bu durumda, standart table view cell sınıfını yeni cell'ler oluşturmak için kullanılacak sınıf olarak kaydettik,
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel!.text = "List \(indexPath.row)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowYouHaveToDo", sender: nil)
    }
}
