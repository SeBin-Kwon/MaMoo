//
//  ProfileViewController.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/24/25.
//

import UIKit
import SnapKit

final class ProfileViewController: BaseViewController {
    
    private var num: Int?
    private var profileImageButton = ProfileImageButton()
    private lazy var textField = configureTextFieldUI()
    private let viewModel = ProfileViewModel()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureFlowLayout())
    
    private var textFieldBorder = {
        let border = UIView()
        border.backgroundColor = .maMooGray
        return border
    }()
    
    private var validLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .maMooPoint
        label.isHidden = true
        return label
    }()
    
    private let completeButton = {
        let btn = MaMooButton(title: "완료")
        btn.isEnabled = false
        btn.isHidden = UserDefaultsManager.shared.isDisplayedOnboarding
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureNavigationBar()
        configureAction()
        bindData()
    }
    
    private func bindData() {
        viewModel.outputNum.bind { [weak self] num in
            self?.num = num
            self?.profileImageButton.profileImageView.addProfileImage(num)
        }
        viewModel.outputIsValid.lazyBind { [weak self] (value, text) in
            self?.completeButton.isEnabled = value ? true : false
            self?.navigationItem.rightBarButtonItem?.isEnabled = value ? true : false
            self?.validLabel.text = text
        }
    }
    
    override func configureView() {
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MBTICollectionViewCell.self, forCellWithReuseIdentifier: MBTICollectionViewCell.identifier)
    }
    
    private func configureAction() {
        profileImageButton.addTarget(self, action: #selector(profileImageButtonTapped), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureTapped))
        view.addGestureRecognizer(tap)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = UserDefaultsManager.shared.isDisplayedOnboarding ? "프로필 편집" : "프로필 설정"
        let rightItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(completeButtonTapped))
        rightItem.setTitleTextAttributes([.foregroundColor: UIColor.maMooPoint, .font: UIFont.systemFont(ofSize: 16, weight: .bold)], for: .normal)
        rightItem.isHidden = !UserDefaultsManager.shared.isDisplayedOnboarding
        rightItem.isEnabled = false
        navigationItem.rightBarButtonItem = rightItem
        
        let leftItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(leftItemTapped))
        leftItem.tintColor = .maMooPoint
        if UserDefaultsManager.shared.isDisplayedOnboarding {
            navigationItem.leftBarButtonItem = leftItem
        }
    }
    
    @objc private func tapGestureTapped() {
        view.endEditing(true)
    }
    
    @objc private func leftItemTapped() {
        dismiss(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
    
    @objc private func completeButtonTapped() {
        viewModel.inputCompleteButtonTapped.value = textField.text
        dismiss(animated: true)
    }
    
    @objc private func profileImageButtonTapped() {
        let vc = ProfileImageViewController()
        vc.num = num
        vc.contents = { [weak self] value in
            guard let value else { return }
            self?.profileImageButton.profileImageView.image = UIImage(named: "profile_\(value)")
            self?.viewModel.outputNum.value = value
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: TextField Delegate
extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        viewModel.inputText.value = textField.text
        validLabel.isHidden = false
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.inputText.value = textField.text
    }
}


// MARK: CollectionView Delegate
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print(#function)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MBTICollectionViewCell.identifier, for: indexPath) as? MBTICollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
    
}

// MARK: Layout, UI
extension ProfileViewController {
    
    private func configureFlowLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width / 1.5
        let cellCount: CGFloat = 4
        let itemSpacing: CGFloat = 10
        let insetSpacing: CGFloat = 0
        let cellWidth = width - (itemSpacing * (cellCount-1)) - (insetSpacing*2)
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: insetSpacing, bottom: 0, right: insetSpacing)
        layout.itemSize = CGSize(width: cellWidth / cellCount, height: cellWidth / cellCount)
        layout.scrollDirection = .horizontal
        return layout
    }
    
    private func configureTextFieldUI() -> UITextField {
        let textfield = UITextField()
        textfield.borderStyle = .none
        textfield.backgroundColor = .none
        textfield.text = UserDefaultsManager.shared.isDisplayedOnboarding ? UserDefaultsManager.shared.nickname : ""
        textfield.textColor = .white
        textfield.font = .systemFont(ofSize: 14)
        textfield.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해주세요", attributes: [
            .foregroundColor: UIColor.maMooGray, .font: UIFont.systemFont(ofSize: 14)])
        textfield.delegate = self
        return textfield
    }
    
    private func configureLayout() {
        [profileImageButton, textField, textFieldBorder, validLabel, collectionView, completeButton].forEach {
            view.addSubview($0)
        }
        
        profileImageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(UserDefaultsManager.shared.isDisplayedOnboarding ? 30 : 60)
            make.centerX.equalToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(60)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        textFieldBorder.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(13)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(1.5)
        }
        validLabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldBorder).offset(15)
            make.leading.equalToSuperview().offset(20)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(validLabel.snp.bottom).offset(30)
            make.trailing.equalToSuperview().inset(10)
            make.width.equalTo(view.frame.size.width / 1.5)
            make.height.equalTo(view.frame.size.height / 6.5)
        }
        completeButton.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
}
