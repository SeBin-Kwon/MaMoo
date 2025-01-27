//
//  ProfileViewController.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/24/25.
//

import UIKit
import SnapKit

final class ProfileViewController: BaseViewController {
    
    private var num = Int.random(in: 0...11)
    private lazy var profileImageButton = ProfileImageButton(num: num)
    private lazy var textField = configureTextFieldUI()
    private var textFieldBorder = {
        let border = UIView()
        border.backgroundColor = .maMooGray
        return border
    }()
    private var validLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .maMooPoint
        label.isHidden = true
        return label
    }()
    private let completeButton = {
        let btn = MaMooButton(title: "완료")
        btn.isEnabled = false
        return btn
    }()
    
    private var isVaild = false {
        didSet {
            completeButton.isEnabled = isVaild ? true : false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "프로필 설정"
        profileImageButton.addTarget(self, action: #selector(profileImageButtonTapped), for: .touchUpInside)
        textField.delegate = self
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func completeButtonTapped() {
        guard let text = textField.text else { return }
        UserDefaultsManager.shared.isDisplayedOnboarding = true
        UserDefaultsManager.shared.nickname = text
        UserDefaultsManager.shared.profileImage = num
        ProfileViewController.changeRootViewController(rootView: TabBarController())
    }
    
    @objc private func profileImageButtonTapped() {
        let vc = ProfileImageViewController()
        vc.num = num
        vc.contents = { value in
            guard let value else { return }
            self.profileImageButton.profileImageView.image = UIImage(named: "profile_\(value)")
            self.num = value
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func configureTextFieldUI() -> UITextField {
        let textfield = UITextField()
        textfield.borderStyle = .none
        textfield.backgroundColor = .none
        textfield.textColor = .white
        textfield.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해주세요", attributes: [
            .foregroundColor: UIColor.maMooGray])
        return textfield
    }
    
    override func configureView() {
        view.addSubview(profileImageButton)
        view.addSubview(textField)
        view.addSubview(textFieldBorder)
        view.addSubview(validLabel)
        view.addSubview(completeButton)
        
        profileImageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.centerX.equalToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(60)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        textFieldBorder.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(2)
        }
        validLabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldBorder).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(validLabel.snp.bottom).offset(50)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
    }
    
}

// MARK: TextField Validate
extension ProfileViewController {
    private func isValidateNickname(_ text: String) -> Bool {
        validLabel.isHidden = false
        
        let pattern = "(?=.*[!@#$%^])"
        if matchesPattern(text, pattern) {
            validLabel.text = "닉네임에 @, #, $, % 는 포함할 수 없어요"
            return false
        }
        
        if text.filter({ $0.isNumber }).count > 0 {
            validLabel.text = "닉네임에 숫자는 포함할 수 없어요"
            return false
        }

        return true
    }
    
    private func matchesPattern(_ string: String, _ pattern: String) -> Bool {
        let regex = try? NSRegularExpression(pattern: pattern)
        if let _ = regex?.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count)) {
            return true
        }
        return false
    }
}


// MARK: TextField Delegate
extension ProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        guard let newRange = Range(range, in: text) else { return true }
        let inputString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        let newString = text.replacingCharacters(in: newRange, with: inputString)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        print(newString, newString.count)
        isVaild = isValidateNickname(text)
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard text.count >= 2 && text.count < 10 else {
            validLabel.text = "2글자 이상 10글자 미만으로 설정해주세요"
            isVaild = false
            return
        }
        print("DidChange: ", text)
        isVaild = isValidateNickname(text)
        if isVaild {
            validLabel.text = "사용할 수 있는 닉네임이에요"
        }
    }
}
