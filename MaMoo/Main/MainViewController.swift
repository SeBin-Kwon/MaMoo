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
    private var movieList = [MovieResults]()
    
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
        mainView.collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        print(NSHomeDirectory())
    }
    
    @objc func rightItemTapped() {
        print(#function)
        let vc = SearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let searchList = UserDefaultsManager.shared.searchResults
        print(searchList)
        guard !searchList.isEmpty else { return }
        if !mainView.searchStackView.arrangedSubviews.isEmpty {
            mainView.searchStackView.removeAll()
        }
        for i in 0..<searchList.count {
            let tagBtn = SearchTagButton()
            tagBtn.searchLabel.text = searchList[i]
            tagBtn.addTarget(self, action: #selector(tagtapped), for: .touchUpInside)
//            tagBtn.removeButton.tag = i
            tagBtn.removeButton.addTarget(self, action: #selector(removeButtontapped), for: .touchUpInside)
            mainView.searchStackView.addArrangedSubview(tagBtn)
            mainView.searchStackView.arrangedSubviews[i].tag = i
        }
    }
    
    private func configureData() {
        mainView.profileEditButton.nicknameLabel.text = UserDefaultsManager.shared.nickname
        mainView.profileEditButton.profileImage.image = UIImage(named: "profile_\(UserDefaultsManager.shared.profileImage)")
        mainView.profileEditButton.dateLabel.text = UserDefaultsManager.shared.signUpDate
        
        mainView.profileEditButton.addTarget(self, action: #selector(profileEditButtontapped), for: .touchUpInside)
    }
    
    @objc private func profileEditButtontapped() {
        print(#function)
    }
    
    @objc private func removeButtontapped(_ sender: UIView) {
        let removeView = mainView.searchStackView.arrangedSubviews[sender.tag]
        print(sender.tag)
        UIView.animate(withDuration: 0.3) {
            removeView.isHidden = true
        } completion: { _ in
            self.mainView.searchStackView.removeArrangedSubview(removeView)
            removeView.removeFromSuperview()
        }
        UserDefaultsManager.shared.searchResults.remove(at: sender.tag)
        for i in 0..<mainView.searchStackView.arrangedSubviews.count {
            mainView.searchStackView.arrangedSubviews[i].tag = i
        }
    }
    
    @objc private func tagtapped() {
        print(#function)
    }
    
    private func callRequest() {
        let group = DispatchGroup()
        group.enter()
        NetworkManager.shared.fetchResults(api: TMDBRequest.trending, type: Movie.self) { value in
            print(value.results.count)
            self.movieList = value.results
            group.leave()
        } failHandler: {
            print("fail")
            group.leave()
        }
        group.notify(queue: .main) {
            print(#function, "-END-")
            self.mainView.collectionView.reloadData()
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


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.movie = movieList[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        cell.configureData(movieList[indexPath.item])
        return cell
    }
    
    
}
