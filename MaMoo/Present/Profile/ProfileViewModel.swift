//
//  ProfileViewModel.swift
//  MaMoo
//
//  Created by Sebin Kwon on 2/7/25.
//

import Foundation

class ProfileViewModel {
    var inputText: Observable<String?> = Observable(nil)
    var inputCompleteButtonTapped: Observable<String?> = Observable(nil)
    var outputNum = Observable(UserDefaultsManager.shared.isDisplayedOnboarding ? UserDefaultsManager.shared.profileImage : Int.random(in: 0...11))
    var outputIsValid = Observable((false, ""))
    let mbtiContents = [["E", "I"], ["S", "N"], ["T", "F"], ["J", "P"]]
    var inputMBTISelectedIndex = Observable((0, 0))
    var mbtiSelectList = Array(repeating: [false, false], count: 4)
    var outputMBTI: Observable<String?> = Observable(nil)
    var outputLastSelcetSection = Observable(0)

    init() {
        inputCompleteButtonTapped.lazyBind { [weak self] text in
            self?.completeButtonTapped(text)
        }
        inputText.lazyBind { [weak self] text in
            self?.isValidateNickname(text)
        }
        inputMBTISelectedIndex.lazyBind { [weak self] (section, item) in
            self?.updateOutputMBTISelectList(section: section, item: item)
        }
    }
    
    deinit {
        print("ProfileViewModel Deinit")
    }
    
    private func updateOutputMBTISelectList(section: Int, item: Int) {
                
        if mbtiSelectList[section][item] {
            mbtiSelectList[section][item] = false
        } else {
            mbtiSelectList[section] = [false, false]
            mbtiSelectList[section][item] = true
        }
        
        outputLastSelcetSection.value = section
    }
    
    private func isValidateNickname(_ text: String?) {
        guard let text = text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        guard text.count >= 2 && text.count < 10 else {
            outputIsValid.value = (false, "2글자 이상 10글자 미만으로 설정해주세요")
            return
        }
        
        let pattern = "(?=.*[!@#$%^])"
        if matchesPattern(text, pattern) {
            outputIsValid.value = (false, "닉네임에 @, #, $, % 는 포함할 수 없어요")
            return
        }
        
        if text.filter({ $0.isNumber }).count > 0 {
            outputIsValid.value = (false, "닉네임에 숫자는 포함할 수 없어요")
            return
        }

        outputIsValid.value = (true, "사용할 수 있는 닉네임이에요")
    }
    
    private func matchesPattern(_ string: String, _ pattern: String) -> Bool {
        let regex = try? NSRegularExpression(pattern: pattern)
        if let _ = regex?.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count)) {
            return true
        }
        return false
    }
    
    private func completeButtonTapped(_ text: String?) {
        guard let text else { return }
        if !UserDefaultsManager.shared.isDisplayedOnboarding {
            UserDefaultsManager.shared.isDisplayedOnboarding = true
            UserDefaultsManager.shared.nickname = text
            UserDefaultsManager.shared.profileImage = outputNum.value
            UserDefaultsManager.shared.signUpDate = DateFormatterManager.shared.dateFormatted(Date()) + " 가입"
            ProfileViewController.changeRootViewController(rootView: TabBarController())
        } else {
            NotificationCenter.default.post(name: .profileNotification, object: nil, userInfo: ["nickname": text, "profileImage": outputNum.value])
            UserDefaultsManager.shared.nickname = text
            UserDefaultsManager.shared.profileImage = outputNum.value
        }
    }
}
