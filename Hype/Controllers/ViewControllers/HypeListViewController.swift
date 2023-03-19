//
//  HypeListViewController.swift
//  Hype
//
//  Created by Andrew Acton on 3/18/23.
//

import UIKit

class HypeListViewController: UIViewController {

    var refresh: UIRefreshControl = UIRefreshControl()
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupViews()
    }
    
    //MARK: - Actions
    
    @IBAction func addHypeButtonTapped(_ sender: Any) {
        presentAddHypeAlert()
    }
    
    //MARK: - Helper Methods
    
    @objc func loadData() {
        HypeController.shared.fetchHypes { success in
            if success {
                self.updateViews()
            }
        }
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refresh.endRefreshing()
        }
    }
    
    func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        refresh.attributedTitle = NSAttributedString(string: "Pull to see more hypes")
        refresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.addSubview(refresh)
    }
    
    func presentAddHypeAlert(){
        let alert = UIAlertController(title: "Get Hype!", message: "What is hype may never die", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "What is Hype today?"
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .sentences
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let addHypeAction = UIAlertAction(title: "Send", style: .default) { (_) in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else { return }
            HypeController.shared.saveHype(with: text) { success in
                if success {
                    self.updateViews()
                }
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addHypeAction)
        
        self.present(alert, animated: true)
    }

}//End Of Class

extension HypeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HypeController.shared.hypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hypeCell", for: indexPath)
        
        let hype = HypeController.shared.hypes[indexPath.row]
        
        cell.textLabel?.text = hype.body
        cell.detailTextLabel?.text = hype.timestamp.formatDate()
        
        return cell
    }
    
    
}//End Of Extension
