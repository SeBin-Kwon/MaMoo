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
        label.textColor = .maMooFalseLabel
        label.isHidden = true
        return label
    }()
    
    private var mbtiLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.text = "MBTI"
        label.textColor = .white
        return label
    }()
    
    private var validMBTILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .maMooFalseLabel
        label.isHidden = true
        return label
    }()
    
    private let completeButton = {
        var btn = MaMooButton(title: "완료")
        btn.isEnabled = false
        btn.isHidden = UserDefaultsManager.isDisplayedOnboarding
        
        let buttonStateHandler: UIButton.ConfigurationUpdateHandler = { button in
            switch button.state {
            case .normal:
                button.configuration?.background.strokeColor = .maMooPoint
                button.configuration?.attributedTitle?.foregroundColor = UIColor.maMooPoint
            case .disabled:
                button.configuration?.background.strokeColor = .maMooDisabled
                button.configuration?.attributedTitle?.foregroundColor = UIColor.maMooDisabled
            default:
                return
            }
        }
        btn.configurationUpdateHandler = buttonStateHandler
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
        configureNavigationBar()
        configureAction()
        bindData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
    
    private func bindData() {
        viewModel.output.num.bind { [weak self] num in
            self?.num = num
            self?.profileImageButton.profileImageView.addProfileImage(num)
        }
        viewModel.output.isValid.lazyBind { [weak self] (bool, text) in
            let value = self?.viewModel.output.isValidMBTI.value.0 ?? false && bool
            self?.completeButton.isEnabled = value ? true : false
            
            self?.completeButton.layer.borderColor = value ? UIColor.maMooPoint.cgColor : UIColor.maMooDisabled.cgColor
            
            self?.navigationItem.rightBarButtonItem?.isEnabled = value ? true : false
            self?.validLabel.text = text
            self?.validLabel.textColor =  bool ? .maMooPoint : .maMooFalseLabel
        }
        viewModel.output.lastSelcetSection.lazyBind { [weak self] section in
            self?.collectionView.reloadSections(IndexSet(integer: section))
        }
        viewModel.output.isValidMBTI.lazyBind { [weak self] (bool, text) in
            let value = self?.viewModel.output.isValid.value.0 ?? false && bool
            self?.completeButton.isEnabled = value ? true : false
            
            self?.completeButton.layer.borderColor = value ? UIColor.maMooPoint.cgColor : UIColor.maMooDisabled.cgColor
            
            self?.navigationItem.rightBarButtonItem?.isEnabled = value ? true : false
            self?.validMBTILabel.text = text
        }
    }
    
    private func configureView() {
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MBTICollectionViewCell.self, forCellWithReuseIdentifier: MBTICollectionViewCell.identifier)
    }
    
    private func configureAction() {
        profileImageButton.addTarget(self, action: #selector(profileImageButtonTapped), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureTapped))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = UserDefaultsManager.isDisplayedOnboarding ? "프로필 편집" : "프로필 설정"
        let rightItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(completeButtonTapped))
        rightItem.setTitleTextAttributes([.foregroundColor: UIColor.maMooPoint, .font: UIFont.systemFont(ofSize: 16, weight: .bold)], for: .normal)
        rightItem.isHidden = !UserDefaultsManager.isDisplayedOnboarding
        rightItem.isEnabled = false
        navigationItem.rightBarButtonItem = rightItem
        
        let leftItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(leftItemTapped))
        leftItem.tintColor = .maMooPoint
        if UserDefaultsManager.isDisplayedOnboarding {
            navigationItem.leftBarButtonItem = leftItem
        }
    }
}

// MARK: Button Tapped
extension ProfileViewController {
    @objc private func tapGestureTapped() {
        view.endEditing(true)
    }
    
    @objc private func leftItemTapped() {
        dismiss(animated: true)
    }
    
    @objc private func profileImageButtonTapped() {
        view.endEditing(true)
        let vc = ProfileImageViewController()
        vc.viewModel.input.num.value = num
        vc.contents = { [weak self] value in
            guard let value else { return }
            self?.profileImageButton.profileImageView.image = UIImage(named: "profile_\(value)")
            self?.viewModel.output.num.value = value
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func completeButtonTapped() {
        viewModel.input.completeButtonTapped.value = textField.text
        dismiss(animated: true)
    }
}


// MARK: TextField Delegate
extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        viewModel.input.text.value = textField.text
        validLabel.isHidden = false
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.input.text.value = textField.text
    }
}


// MARK: CollectionView Delegate
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        view.endEditing(true)
        viewModel.input.mbtiSelectedIndex.value = (indexPath.section, indexPath.item)
        validMBTILabel.isHidden = false
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.mbtiList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.mbtiList[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MBTICollectionViewCell.identifier, for: indexPath) as? MBTICollectionViewCell else { return UICollectionViewCell() }
        let text = viewModel.mbtiList[indexPath.section][indexPath.item].type
        let isSelected = viewModel.mbtiList[indexPath.section][indexPath.item].isSelected
        cell.configureData(text)
        cell.updateSelectedCell(isSelected)
        
        return cell
    }
    
}

// MARK: Layout, UI
extension ProfileViewController {
    
    private func configureFlowLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width / 1.4
        let cellCount: CGFloat = 4
        let itemSpacing: CGFloat = 10
        let insetSpacing: CGFloat = 5
        let cellWidth = width - (itemSpacing * (cellCount-1)) - (insetSpacing*(cellCount+1))
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
        textfield.text = UserDefaultsManager.isDisplayedOnboarding ? UserDefaultsManager.nickname : ""
        textfield.textColor = .white
        textfield.font = .systemFont(ofSize: 14)
        textfield.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해주세요", attributes: [
            .foregroundColor: UIColor.maMooGray, .font: UIFont.systemFont(ofSize: 14)])
        textfield.delegate = self
        return textfield
    }
    
    private func configureLayout() {
        [profileImageButton, textField, textFieldBorder, validLabel, mbtiLabel, collectionView, completeButton, validMBTILabel].forEach {
            view.addSubview($0)
        }
        
        profileImageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(UserDefaultsManager.isDisplayedOnboarding ? 30 : 60)
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
            make.top.equalTo(textFieldBorder.snp.bottom).offset(40)
            make.trailing.equalToSuperview().inset(5)
            make.width.equalTo(view.frame.size.width / 1.4)
            make.height.equalTo(view.frame.size.height / 6.8)
        }
        mbtiLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView).inset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        validMBTILabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(15)
            make.leading.equalTo(collectionView)
        }
        completeButton.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
}
