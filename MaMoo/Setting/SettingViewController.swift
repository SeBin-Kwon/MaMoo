//
//  SettingViewController.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/29/25.
//

import UIKit
import SnapKit

final class SettingViewController: BaseViewController {
    let button = UIButton()
    let profileEditButton = ProfileEditButton()
    let tableView = {
        let tabel = UITableView()
        tabel.separatorStyle = .singleLine
        tabel.separatorColor = .maMooGray
        return tabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "설정"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        
        configureData()
        NotificationCenter.default.addObserver(self, selector: #selector(profileNotification), name: NSNotification.Name("profile"), object: nil)
        
        
        button.setTitle("탈퇴", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func profileNotification(value: NSNotification) {
        guard let nickname = value.userInfo!["nickname"] as? String,
              let imageNum = value.userInfo!["profileImage"] as? Int else { return }
        profileEditButton.nicknameLabel.text = nickname
        profileEditButton.profileImage.image = UIImage(named: "profile_\(imageNum)")
        print("신호받음")
    }
    
    private func configureData() {
        profileEditButton.nicknameLabel.text = UserDefaultsManager.shared.nickname
        profileEditButton.profileImage.image = UIImage(named: "profile_\(UserDefaultsManager.shared.profileImage)")
        profileEditButton.dateLabel.text = UserDefaultsManager.shared.signUpDate
        
        profileEditButton.addTarget(self, action: #selector(profileEditButtontapped), for: .touchUpInside)
    }
    
    @objc private func profileEditButtontapped() {
        print(#function)
        let vc = UINavigationController(rootViewController: ProfileViewController())
        if let sheet = vc.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
        present(vc, animated: true)
    }
    
    @objc func buttonTapped() {
        print(#function)
        UserDefaultsManager.shared.isDisplayedOnboarding = false
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
    
    override func configureView() {
        tableView.backgroundColor = .black
        view.addSubview(profileEditButton)
        view.addSubview(tableView)
        view.addSubview(button)
        profileEditButton.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(140)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(profileEditButton.snp.bottom).offset(10)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
//        button.snp.makeConstraints { make in
//            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
//            make.height.equalTo(30)
//        }
    }

}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            print(#function)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .black
        cell.configureData(indexPath.row)
        cell.selectionStyle = .none
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    
}
