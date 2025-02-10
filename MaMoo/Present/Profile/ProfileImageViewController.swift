//
//  ProfileImageViewController.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/26/25.
//

import UIKit
import SnapKit

final class ProfileImageViewController: BaseViewController {
    
    let viewModel = ProfileImageViewModel()
    private lazy var profileImageButton = ProfileImageButton()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
        configureNavigationBar()
        bindData()
    }
    
    deinit {
        print("ProfileImageViewController Deinit")
    }
    
    private func bindData() {
        viewModel.output.num.lazyBind { [weak self] num in
            self?.profileImageButton.profileImageView.image = UIImage(named: "profile_\(num ?? 0)")
        }
    }
    
    @objc private func leftItemTapped() {
        viewModel.input.backButtonTapped.value = ()
        navigationController?.popViewController(animated: true)
    }
    
    private func configureView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
        collectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.identifier)
    }
    
    private func configureLayout() {
        view.addSubview(profileImageButton)
        view.addSubview(collectionView)
        profileImageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(UserDefaultsManager.shared.isDisplayedOnboarding ? 30 : 60)
            make.centerX.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(80)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func configureNavigationBar() {
        navigationItem.title = UserDefaultsManager.shared.isDisplayedOnboarding ? "프로필 이미지 편집" : "프로필 이미지 설정"
        let leftItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(leftItemTapped))
        leftItem.tintColor = .maMooPoint
        navigationItem.leftBarButtonItem = leftItem
    }

}


// MARK: CollectionView Delegate
extension ProfileImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProfileImageCollectionViewCell else { return }
        cell.updateSelectedCell(false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProfileImageCollectionViewCell else { return }
        cell.updateSelectedCell(true)
        profileImageButton.profileImageView.image = UIImage(named: "profile_\(indexPath.item)")
        viewModel.input.num.value = indexPath.item
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.profileList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.identifier, for: indexPath) as? ProfileImageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureImageView(index: indexPath.item)
        if viewModel.input.num.value == indexPath.item {
            cell.updateSelectedCell(true)
        } else {
            cell.updateSelectedCell(false)
        }
        DispatchQueue.main.async {
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height / 2
        }
        
        return cell
    }
    
    private func configureFlowLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        let cellCount: CGFloat = 4
        let itemSpacing: CGFloat = 15
        let insetSpacing: CGFloat = 30
        let cellWidth = width - (itemSpacing * (cellCount-1)) - (insetSpacing*2)
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: insetSpacing, bottom: 0, right: insetSpacing)
        layout.itemSize = CGSize(width: cellWidth / cellCount, height: cellWidth / cellCount)
        layout.scrollDirection = .vertical
        return layout
    }
}
