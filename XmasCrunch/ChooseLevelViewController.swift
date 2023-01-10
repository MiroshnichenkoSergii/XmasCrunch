//
//  ChooseLevelViewController.swift
//  XmasCrunch
//
//  Created by Sergii Miroshnichenko on 04.01.2023.
//

import UIKit

class ChooseLevelViewController: UIViewController {
    
    var levelList = [Int]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension ChooseLevelViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LevelNumber", for: indexPath)
        let text = "Level " + String(levelList[indexPath.row] + 1)
        
        cell.textLabel?.text = text
        cell.textLabel?.font = UIFont(name: "Chalkduster", size: 26)
        cell.textLabel?.textColor = .white
        cell.textLabel?.shadowColor = .green
        cell.textLabel?.shadowOffset = CGSize(width: 2, height: 2)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        Setting.shared.currentSettings.level = levelList[indexPath.row]
        navigationController?.popViewController(animated: true)
    }
}
