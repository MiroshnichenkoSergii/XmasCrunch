//
//  SettingsViewController.swift
//  XmasCrunch
//
//  Created by Sergii Miroshnichenko on 10.01.2023.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var musicSwitcher: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSettings()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func switchMusic(_ sender: UISwitch) {
        Setting.shared.currentSettings.music = sender.isOn
    }
    
    func loadSettings() {
        musicSwitcher.isOn = Setting.shared.currentSettings.music
    }
    
}
