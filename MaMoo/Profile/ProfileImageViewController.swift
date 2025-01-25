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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "프로필 이미지 설정"
        collectionView.delegate = self
        collectionView.dataSource = self
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
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    private func configureFlowLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 10
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: itemSpacing, bottom: 0, right: itemSpacing)
        layout.itemSize = CGSize(width: 200, height: 300)
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return layout
    }

}

extension ProfileImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.identifier, for: indexPath) as? ProfileImageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = .red
        return cell
    }
    
    
}
