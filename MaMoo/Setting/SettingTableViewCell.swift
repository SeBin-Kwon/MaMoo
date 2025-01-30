//
//  SettingTableViewCell.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/31/25.
//

import UIKit
import SnapKit

final class SettingTableViewCell: UITableViewCell {

    static let identifier = "SettingTableViewCell"
    private let contentText = ["자주 묻는 질문", "1:1 문의", "알림 설정", "탈퇴하기"]
    
    private let settingLabel = {
       let label = UILabel()
        label.textColor = .white
        label.text = "sdfsdf"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(settingLabel)
        settingLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureData(_ index: Int) {
        print(index)
        settingLabel.text = contentText[index]
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
