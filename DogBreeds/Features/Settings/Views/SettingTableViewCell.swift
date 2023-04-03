//
//  SettingTableViewCell.swift
//  DogBreeds
//
//  Created by Mahyar Ghaedi on 13/02/2023.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    static let cellId = "SettingTableViewCell"
    
    // MARK: UI
    private lazy var containerView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.cellBackgroundColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.textColor
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var switchView : UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.translatesAutoresizingMaskIntoConstraints = false
        mySwitch.onTintColor = Theme.mainColor
        
        mySwitch.addTarget(self, action: #selector(didChangeSwitch), for: .valueChanged)
        
        return mySwitch
    }()
    
    private weak var delegate: SettingTableViewCellDelegate?
    private var setting: Setting?
}

extension SettingTableViewCell {
    func configure(setting: Setting, isOn: Bool, delegate: SettingTableViewCellDelegate) {
        self.delegate = delegate
        self.setting = setting
        
        titleLabel.text = setting.rawValue
        switchView.isOn = isOn
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(switchView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            switchView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            switchView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
        ])
    }
    
    @objc func didChangeSwitch() {
        guard let setting, let delegate else { return }
        HapticsManager.shared.trigger(with: .light)
        delegate.settingToggled(for: setting, isOn: switchView.isOn)
    }
}
