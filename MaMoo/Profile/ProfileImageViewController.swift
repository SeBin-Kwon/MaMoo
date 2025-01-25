//
//  ProfileImageViewController.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/26/25.
//

import UIKit
import SnapKit

class ProfileImageViewController: BaseViewController {
    
    var num: Int?
    private lazy var profileImageButton = ProfileImageButton(num: num)
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureFlowLayout())
    private let profileList = Array(0...11)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "프로필 이미지 설정"
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
        collectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        profileImageButton.profileImageView.image = UIImage(named: "profile_\(num ?? 0)")
    }

    override func configureView() {
        view.addSubview(profileImageButton)
        view.addSubview(collectionView)
        profileImageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.centerX.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(50)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func configureFlowLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        let cellCount: CGFloat = 4
        let itemSpacing: CGFloat = 20
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

extension ProfileImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        profileList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.identifier, for: indexPath) as? ProfileImageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureImageView(index: indexPath.item)
        DispatchQueue.main.async {
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height / 2
        }
        
        return cell
    }
    
    
}
