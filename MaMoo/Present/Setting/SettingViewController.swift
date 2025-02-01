//
//  SettingViewController.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/29/25.
//

import UIKit
import SnapKit

final class SettingViewController: BaseViewController {
    private let profileEditButton = ProfileEditButton()
    private let tableView = {
        let tabel = UITableView()
        tabel.separatorStyle = .singleLine
        tabel.separatorColor = .maMooGray
        return tabel
    }()
    private var likeDictionary = [String:Bool]()
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(profileNotification), name: .profileNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        likeDictionary = UserDefaultsManager.shared.like
        updateLikeCount()
    }
    
    @objc private func profileNotification(value: NSNotification) {
        guard let nickname = value.userInfo!["nickname"] as? String,
              let imageNum = value.userInfo!["profileImage"] as? Int else { return }
        profileEditButton.nicknameLabel.text = nickname
        profileEditButton.profileImage.image = UIImage(named: "profile_\(imageNum)")
        updateLikeCount()
        print("신호받음")
    }
    
    private func configureData() {
        profileEditButton.nicknameLabel.text = UserDefaultsManager.shared.nickname
        profileEditButton.profileImage.image = UIImage(named: "profile_\(UserDefaultsManager.shared.profileImage)")
        profileEditButton.dateLabel.text = UserDefaultsManager.shared.signUpDate
        profileEditButton.addTarget(self, action: #selector(profileEditButtontapped), for: .touchUpInside)
    }
    
    private func updateLikeCount() {
        let likeCount = likeDictionary.filter { $1 == true }.count
        profileEditButton.movieBoxLabel.text = "\(likeCount)개의 무비박스 보관중"
    }
    
    @objc private func profileEditButtontapped() {
        print(#function)
        let vc = UINavigationController(rootViewController: ProfileViewController())
        if let sheet = vc.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
        present(vc, animated: true)
    }
    
    override func configureView() {
        tableView.backgroundColor = .black
        view.addSubview(profileEditButton)
        view.addSubview(tableView)
        profileEditButton.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(140)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(profileEditButton.snp.bottom).offset(10)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }

}


// MARK: TableView Delegate
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            print(#function)
            self.displayAlert(title: "탈퇴하기", message: "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?", isCancel: true) { _ in
                UserDefaultsManager.shared.isDisplayedOnboarding = false
                for key in UserDefaults.standard.dictionaryRepresentation().keys {
                    UserDefaults.standard.removeObject(forKey: key.description)
                }
                SettingViewController.changeRootViewController(rootView: OnboardingViewController())
            }
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
