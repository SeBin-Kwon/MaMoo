//
//  MainViewController.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/27/25.
//

import UIKit
import SnapKit
import Alamofire

final class MainViewController: BaseViewController {

    private let mainView = MainView()
    private var movieList = [MovieResults]()
    private var searchList = [String]()
    private var likeDictionary = [String:Bool]()
    
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
        configureDelegate()
        NotificationCenter.default.addObserver(self, selector: #selector(profileNotification), name: .profileNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(likeNotification), name: .likeNotification, object: nil)
        mainView.allRemoveButton.addTarget(self, action: #selector(allRemoveButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchList = UserDefaultsManager.shared.searchResults
        likeDictionary = UserDefaultsManager.shared.like
        updateLikeCount()
        mainView.isSearchLabel.isHidden = searchList.isEmpty ? false : true
        mainView.allRemoveButton.isHidden = searchList.isEmpty ? true : false
        mainView.searchCollectionView.reloadData()
    }
    
    private func configureDelegate() {
        mainView.collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        mainView.searchCollectionView.register(SearchTagCollectionViewCell.self, forCellWithReuseIdentifier: SearchTagCollectionViewCell.identifier)
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.searchCollectionView.delegate = self
        mainView.searchCollectionView.dataSource = self
    }
    
    @objc private func rightItemTapped() {
        print(#function)
        let vc = SearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func allRemoveButtonTapped() {
        print(#function)
        searchList.removeAll()
        UserDefaults.standard.removeObject(forKey: "searchResults")
        mainView.isSearchLabel.isHidden = false
        mainView.allRemoveButton.isHidden = true
        mainView.searchCollectionView.reloadSections(IndexSet(integer: 0))
    }
    
    @objc private func profileEditButtontapped() {
        print(#function)
        let vc = UINavigationController(rootViewController: ProfileViewController())
        if let sheet = vc.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
        present(vc, animated: true)
    }
    
    @objc private func removeButtontapped(_ sender: UIButton) {
        print(#function)
        print("sender", sender.tag)
        let index = IndexPath(item: sender.tag, section: 0)
        searchList.remove(at: sender.tag)
        UserDefaultsManager.shared.searchResults = searchList
        mainView.isSearchLabel.isHidden = searchList.isEmpty ? false : true
        mainView.allRemoveButton.isHidden = searchList.isEmpty ? true : false
        mainView.searchCollectionView.deleteItems(at: [index])
        mainView.searchCollectionView.reloadSections(IndexSet(integer: 0))
    }
    
    private func updateLikeCount() {
        let likeCount = likeDictionary.filter { $1 == true }.count
        mainView.profileEditButton.movieBoxLabel.text = "\(likeCount)개의 무비박스 보관중"
    }
    
    private func configureData() {
        mainView.profileEditButton.nicknameLabel.text = UserDefaultsManager.shared.nickname
        mainView.profileEditButton.profileImage.image = UIImage(named: "profile_\(UserDefaultsManager.shared.profileImage)")
        mainView.profileEditButton.dateLabel.text = UserDefaultsManager.shared.signUpDate
        mainView.profileEditButton.addTarget(self, action: #selector(profileEditButtontapped), for: .touchUpInside)
    }
    
    private func callRequest() {
        let group = DispatchGroup()
        group.enter()
        NetworkManager.shared.fetchResults(api: TMDBRequest.trending, type: Movie.self) { value in
            print(value.results.count)
            self.movieList = value.results
            print(self.movieList)
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
}

// MARK: Notification
extension MainViewController {
    @objc private func likeNotification(value: NSNotification) {
        guard let id = value.userInfo!["id"] as? String,
              let like = value.userInfo!["like"] as? Bool else { return }
        likeDictionary[id] = like
        UserDefaultsManager.shared.like[id] = like
        updateLikeCount()
        mainView.collectionView.reloadData()
        print("like신호받음", likeDictionary)
    }
    
    @objc private func profileNotification(value: NSNotification) {
        guard let nickname = value.userInfo!["nickname"] as? String,
              let imageNum = value.userInfo!["profileImage"] as? Int else { return }
        mainView.profileEditButton.nicknameLabel.text = nickname
        mainView.profileEditButton.profileImage.image = UIImage(named: "profile_\(imageNum)")
        print("신호받음")
    }
}

// MARK: UICollectionView Delegate
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case mainView.collectionView:
            let vc = DetailViewController()
            vc.movie = movieList[indexPath.item]
            navigationController?.pushViewController(vc, animated: true)
        default:
            print(#function)
            let vc = SearchViewController()
            vc.searchText = searchList[indexPath.item]
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case mainView.collectionView:
            movieList.count
        default:
            searchList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case mainView.collectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
            let movie = movieList[indexPath.item]
            cell.backgroundColor = .black
            cell.configureData(movie)
            let isLiked = likeDictionary[String(movie.id), default: false]
            cell.updateLikeButton(isLiked)
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchTagCollectionViewCell.identifier, for: indexPath) as? SearchTagCollectionViewCell else { return UICollectionViewCell() }
            cell.backgroundColor = .maMooLightGray
            DispatchQueue.main.async {
                cell.layer.cornerRadius = cell.frame.height / 2
            }
            cell.removeButton.addTarget(self, action: #selector(removeButtontapped), for: .touchUpInside)
            cell.removeButton.tag = indexPath.item
            cell.configureData(searchList[indexPath.item])
            return cell
        }
        
    }
}
