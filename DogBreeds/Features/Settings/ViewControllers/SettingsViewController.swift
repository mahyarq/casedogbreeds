//
//  SettingsViewController.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 13/02/2023.
//

import UIKit

protocol SettingTableViewCellDelegate: AnyObject {
    func settingToggled(for setting: Setting, isOn: Bool)
}

class SettingsViewController: UIViewController {
    // MARK: UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(SettingTableViewCell.self,
                           forCellReuseIdentifier: SettingTableViewCell.cellId)
        return tableView
    }()
    
    private let viewModel = SettingsViewModel()
    
    // MARK: Lifecycle
    override func loadView() {
        super.loadView()
        setup()
    }
    
    func setup() {
        view.backgroundColor = Theme.backgroundColor
        tableView.backgroundColor = Theme.backgroundColor
        tableView.dataSource = self
        
        view.addSubview(tableView)
      
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.cellId, for: indexPath) as? SettingTableViewCell else { return SettingTableViewCell() }
        
        let setting = viewModel.settings[indexPath.row]
        let isOn = viewModel.isOn(setting: setting)
        cell.configure(setting: setting, isOn: isOn, delegate: self)
        
        return cell
    }
}


extension SettingsViewController: SettingTableViewCellDelegate {
    func settingToggled(for setting: Setting, isOn: Bool) {
        viewModel.set(setting: setting, isOn: isOn)
        
        if setting == .darkMode {
            navigationController?.tabBarController?.overrideUserInterfaceStyle = isOn ? .dark : .light
        }
    }
}
