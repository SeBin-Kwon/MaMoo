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
    let viewModel = MainViewModel()

    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureData()
        configureDelegate()
        configureAction()
        bindData()
    }
    
    private func bindData() {
        viewModel.output.likeDictionary.lazyBind { [weak self] dict in
            self?.mainView.collectionView.reloadData()
        }
        viewModel.output.searchList.bind { [weak self] list in
            self?.mainView.isSearchLabel.isHidden = list.isEmpty ? false : true
            self?.mainView.allRemoveButton.isHidden = list.isEmpty ? true : false
            self?.mainView.searchCollectionView.reloadSections(IndexSet(integer: 0))
        }
        viewModel.output.likeCount.bind { [weak self] num in
            self?.mainView.profileEditButton.movieBoxLabel.text = "\(num)개의 무비박스 보관중"
        }
        viewModel.output.nickname.bind { [weak self] text in
            self?.mainView.profileEditButton.nicknameLabel.text = text
        }
        viewModel.output.profileImage.bind { [weak self] num in
            self?.mainView.profileEditButton.profileImage.image = UIImage(named: "profile_\(num)")
        }
        viewModel.output.reloadCollectionView.bind { [weak self] _ in
            self?.mainView.collectionView.reloadSections(IndexSet(integer: 0))
        }
        viewModel.output.error.lazyBind { [weak self] error in
            guard let error else { return }
            self?.displayAlert(title: error.title, message: error.reason, isCancel: false)
        }
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "MAMOO"
        let rightItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
        rightItem.tintColor = .maMooPoint
        navigationItem.rightBarButtonItem = rightItem
    }
    
    private func configureDelegate() {
        mainView.collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        mainView.searchCollectionView.register(SearchTagCollectionViewCell.self, forCellWithReuseIdentifier: SearchTagCollectionViewCell.identifier)
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.searchCollectionView.delegate = self
        mainView.searchCollectionView.dataSource = self
    }
    
    private func configureData() {
        mainView.profileEditButton.nicknameLabel.text = UserDefaultsManager.nickname
        mainView.profileEditButton.profileImage.image = UIImage(named: "profile_\(UserDefaultsManager.profileImage)")
        mainView.profileEditButton.dateLabel.text = UserDefaultsManager.signUpDate
        mainView.profileEditButton.addTarget(self, action: #selector(profileEditButtontapped), for: .touchUpInside)
    }
    
    private func configureAction() {
        NotificationCenter.default.addObserver(self, selector: #selector(profileNotification), name: .profileNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(likeNotification), name: .likeNotification, object: nil)
        mainView.allRemoveButton.addTarget(self, action: #selector(allRemoveButtonTapped), for: .touchUpInside)
    }
}

// MARK: ButtonTapped
extension MainViewController {
    
    @objc private func searchButtonTapped() {
        let vc = SearchViewController()
        vc.sendLatestSearches = { [weak self] value in
            guard let value else { return }
            self?.viewModel.output.searchList.value = value
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func profileEditButtontapped() {
        let vc = UINavigationController(rootViewController: ProfileViewController())
        if let sheet = vc.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
        present(vc, animated: true)
    }
    
    @objc private func removeButtonTapped(_ sender: UIButton) {
        viewModel.input.isRemoveButtonTapped.value = sender.tag
    }
    
    @objc private func allRemoveButtonTapped() {
        viewModel.input.isAllRemoveButtonTapped.value = ()
        mainView.isSearchLabel.isHidden = false
        mainView.allRemoveButton.isHidden = true
        mainView.searchCollectionView.reloadSections(IndexSet(integer: 0))
    }
}

// MARK: Notification
extension MainViewController {
    @objc private func likeNotification(value: NSNotification) {
        viewModel.input.likeNotification.value = value
    }
    
    @objc private func profileNotification(value: NSNotification) {
        viewModel.input.profileNotification.value = value
    }
}

// MARK: UICollectionView Delegate
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case mainView.collectionView:
            let vc = DetailViewController()
            vc.viewModel.input.movie.value = viewModel.movieList[indexPath.item]
            navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = SearchViewController()
            vc.viewModel.input.searchTag.value = viewModel.output.searchList.value[indexPath.item]
            vc.sendLatestSearches = { [weak self] value in
                guard let value else { return }
                self?.viewModel.output.searchList.value = value
            }
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case mainView.collectionView:
            viewModel.movieList.count
        default:
            viewModel.output.searchList.value.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case mainView.collectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
            let movie = viewModel.movieList[indexPath.item]
            cell.configureData(movie)
            let isLiked = viewModel.output.likeDictionary.value[String(movie.id), default: false]
            cell.updateLikeButton(isLiked)
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchTagCollectionViewCell.identifier, for: indexPath) as? SearchTagCollectionViewCell else { return UICollectionViewCell() }
            DispatchQueue.main.async {
                cell.layer.cornerRadius = cell.frame.height / 2
            }
            cell.removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
            cell.removeButton.tag = indexPath.item
            cell.configureData(viewModel.output.searchList.value[indexPath.item])
            return cell
        }
        
    }
}
