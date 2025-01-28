//
//  SettingViewController.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/29/25.
//

import UIKit

class SettingViewController: BaseViewController {
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        button.setTitle("탈퇴", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        print(#function)
        UserDefaultsManager.shared.isDisplayedOnboarding = false
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
    
    override func configureView() {
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(30)
        }
    }

}
