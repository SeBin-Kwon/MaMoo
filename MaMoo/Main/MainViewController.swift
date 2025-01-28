//
//  MainViewController.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/27/25.
//

import UIKit
import SnapKit
import Alamofire

class MainViewController: BaseViewController {

    private let mainView = MainView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "MAMOO"
        let rightItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(rightItemTapped))
        rightItem.tintColor = .maMooPoint
        navigationItem.rightBarButtonItem = rightItem
        configureData()
        callRequest()
    }
    
    @objc func rightItemTapped() {
        print(#function)
    }
    
    private func configureData() {
        mainView.profileEditButton.nicknameLabel.text = UserDefaultsManager.shared.nickname
        mainView.profileEditButton.profileImage.image = UIImage(named: "profile_\(UserDefaultsManager.shared.profileImage)")
        mainView.profileEditButton.dateLabel.text = UserDefaultsManager.shared.signUpDate
        for i in 0..<10 {
            let tag = SearchTagButton()
            tag.searchLabel.text = "어벤져스 \(i)"
            tag.addTarget(self, action: #selector(tagtapped), for: .touchUpInside)
            tag.removeButton.addTarget(self, action: #selector(removeButtontapped), for: .touchUpInside)
            mainView.searchStackView.addArrangedSubview(tag)
        }
        mainView.profileEditButton.addTarget(self, action: #selector(profileEditButtontapped), for: .touchUpInside)
    }
    
    @objc private func profileEditButtontapped() {
        print(#function)
    }
    
    @objc private func removeButtontapped() {
        print(#function)
    }
    
    @objc private func tagtapped() {
        print(#function)
    }
    
    private func callRequest() {
        NetworkManager.shared.fetchResults(api: TMDBRequest.trending, type: Movie.self) { value in
            print(value.results.count)
        } failHandler: {
            print("fail")
        }
    }
    

    override func configureView() {
    }
    
    override func viewDidLayoutSubviews() {
        mainView.searchStackView.subviews.forEach {
            guard let btn = $0 as? SearchTagButton else { return }
            btn.backgroundView.layer.cornerRadius = mainView.searchStackView.frame.height / 2
        }
    }
}
