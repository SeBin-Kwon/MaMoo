//
//  MainViewController.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/27/25.
//

import UIKit
import SnapKit
import Alamofire

class MainViewController: BaseViewController {

    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "MAMOO"
        configureView()
        button.setTitle("탈퇴", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        print(#function)
        UserDefaultsManager.shared.isDisplayedOnboarding = false
    }

    override func configureView() {
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(30)
        }
    }
}
