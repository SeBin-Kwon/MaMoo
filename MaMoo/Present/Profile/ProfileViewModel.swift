//
//  ProfileViewModel.swift
//  MaMoo
//
//  Created by Sebin Kwon on 2/7/25.
//

import Foundation

struct MBTI {
    let type: String
    var isSelected: Bool = false
}

class ProfileViewModel: BaseViewModel {
    
    private(set) var input: Input
    private(set) var output: Output
    
    struct Input {
        var text: Observable<String?> = Observable(nil)
        var completeButtonTapped: Observable<String?> = Observable(nil)
        var mbtiSelectedIndex = Observable((0, 0))
    }
    
    struct Output {
        var num = Observable(UserDefaultsManager.shared.isDisplayedOnboarding ? UserDefaultsManager.shared.profileImage : Int.random(in: 0...11))
        var isValid = Observable((false, ""))
        var isValidMBTI = Observable((false, ""))
        var lastSelcetSection = Observable(0)
    }
    
    var mbtiList = [[MBTI(type: "E"), MBTI(type: "I")],
                    [MBTI(type: "S"), MBTI(type: "N")],
                    [MBTI(type: "T"), MBTI(type: "F")],
                    [MBTI(type: "J"), MBTI(type: "P")]]
    
    init() {
        input = Input()
        output = Output()
        transform()
    }
    
    func transform() {
        input.completeButtonTapped.lazyBind { [weak self] text in
            self?.completeButtonTapped(text)
        }
        input.text.lazyBind { [weak self] text in
            self?.isValidateNickname(text)
        }
        input.mbtiSelectedIndex.lazyBind { [weak self] (section, item) in
            self?.updateOutputMBTISelectList(section: section, item: item)
        }
    }
    
    private func updateOutputMBTISelectList(section: Int, item: Int) {
        if mbtiList[section][item].isSelected {
            mbtiList[section][item].isSelected = false
        } else {
            for i in 0..<mbtiList[section].count {
                mbtiList[section][i].isSelected = false
            }
            mbtiList[section][item].isSelected = true
        }
        
        output.lastSelcetSection.value = section
        isValidateMBTI()
    }
    
    private func isValidateNickname(_ text: String?) {
        guard let text = text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        guard text.count >= 2 && text.count < 10 else {
            output.isValid.value = (false, "2글자 이상 10글자 미만으로 설정해주세요")
            return
        }
        
        let pattern = "(?=.*[!@#$%^])"
        if matchesPattern(text, pattern) {
            output.isValid.value = (false, "닉네임에 @, #, $, % 는 포함할 수 없어요")
            return
        }
        
        if text.filter({ $0.isNumber }).count > 0 {
            output.isValid.value = (false, "닉네임에 숫자는 포함할 수 없어요")
            return
        }

        output.isValid.value = (true, "사용할 수 있는 닉네임이에요")
    }
    
    private func matchesPattern(_ string: String, _ pattern: String) -> Bool {
        let regex = try? NSRegularExpression(pattern: pattern)
        if let _ = regex?.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count)) {
            return true
        }
        return false
    }
    
    private func isValidateMBTI() {
        for mbti in mbtiList {
            if mbti.filter({ $0.isSelected }).count == 0 {
                output.isValidMBTI.value = (false, "MBTI를 모두 선택해주세요")
                return
            }
        }
        output.isValidMBTI.value = (true, "")
    }
    
    private func completeButtonTapped(_ text: String?) {
        guard let text else { return }
        guard output.isValidMBTI.value.0 else {
            return }
        if !UserDefaultsManager.shared.isDisplayedOnboarding {
            UserDefaultsManager.shared.isDisplayedOnboarding = true
            UserDefaultsManager.shared.nickname = text
            UserDefaultsManager.shared.profileImage = output.num.value
            UserDefaultsManager.shared.signUpDate = DateFormatterManager.shared.dateFormatted(Date()) + " 가입"
            ProfileViewController.changeRootViewController(rootView: TabBarController())
        } else {
            NotificationCenter.default.post(name: .profileNotification, object: nil, userInfo: ["nickname": text, "profileImage": output.num.value])
            UserDefaultsManager.shared.nickname = text
            UserDefaultsManager.shared.profileImage = output.num.value
        }
    }
}
