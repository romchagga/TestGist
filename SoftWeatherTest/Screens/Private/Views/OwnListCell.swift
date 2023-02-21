//
//  OwnListCell.swift
//  SoftWeatherTest
//
//  Created by macbook on 21.02.2023.
//

import UIKit

final class OwnListCell: UITableViewCell {
    
    static let reuseIdentifier = "ownReuseId"
    
    private(set) lazy var nameGistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    
    private(set) lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 11.0)
        return label
    }()
    
    private(set) lazy var avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person.fill")
        return imageView
    }()
    
    
    override func prepareForReuse() {
        [self.nameGistLabel, self.userNameLabel].forEach { $0.text = nil }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setConstraints()
    }
    
    // MARK: - Methods
    
    func configure(with cellModel: PublicOwnCellModel) {
        nameGistLabel.text = cellModel.fileName
        userNameLabel.text = cellModel.userName
        avatarImage.image = cellModel.avatarURL
    }
    
    private func setConstraints() {
        contentView.addSubview(nameGistLabel)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(avatarImage)
        
        
        NSLayoutConstraint.activate([
            nameGistLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0),
            nameGistLabel.leftAnchor.constraint(equalTo: avatarImage.rightAnchor, constant: 10.0),
            nameGistLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -40.0)
        ])
        
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: nameGistLabel.bottomAnchor, constant: 4.0),
            userNameLabel.leftAnchor.constraint(equalTo: avatarImage.rightAnchor, constant: 10.0),
            userNameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -40.0)
        ])
        
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10.0),
            avatarImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10.0),
            avatarImage.widthAnchor.constraint(equalToConstant: 40),
            avatarImage.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
}
