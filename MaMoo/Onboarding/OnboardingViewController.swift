//
//  OnboardingViewController.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/24/25.
//

import UIKit
import SnapKit

final class OnboardingViewController: BaseViewController {
    
    private let imageView = {
        let image = UIImageView()
        image.image = UIImage(named: "onboarding")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "Onboarding"
        label.textColor = .white
        label.font = UIFont.italicSystemFont(ofSize: 35, weight: .bold)
        
        return label
    }()
    
    private let contentLabel = {
        let label = UILabel()
        label.text = "당신만의 영화 세상,\nMAMOO를 시작해보세요."
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private let button = MaMooButton(title: "시작하기")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        navigationController?.pushViewController(ProfileViewController(), animated: true)
    }
    
    override func configureView() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(contentLabel)
        view.addSubview(button)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).inset(10)
        }
        contentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        button.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalTo(contentLabel.snp.bottom).offset(40)
        }
    }
    
}
