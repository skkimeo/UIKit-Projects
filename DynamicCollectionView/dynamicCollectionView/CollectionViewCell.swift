//
//  CollectionViewCell.swift
//  dynamic tableView
//
//  Created by sun on 2022/03/24.
//

import UIKit

import Then

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var noteImageLabel: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

class MyCollectionViewCell: UICollectionViewCell {
    let label = UILabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant:  -8).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
    }
}


class TagCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    /// 첫 단어 라벨
    let firstWordLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17)
        $0.textAlignment = .center
    }
    
    /// 쪽지 배경 이미지
    let noteImageView = UIImageView()
    
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUpViewHierarchy()
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK: - Functions
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.noteImageView.image = UIImage()
        self.firstWordLabel.text = nil
        self.contentView.transform = self.transform
        print(#function)
    }
    
    private func setUpViewHierarchy() {
        self.noteImageView.translatesAutoresizingMaskIntoConstraints = false
        self.firstWordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(self.noteImageView)
        self.contentView.addSubview(self.firstWordLabel)
    }
    
    private func configureConstraints() {
        self.configureNoteImageViewConstraints()
        self.configureFirstWordLabelConstraints()
    }
    
    private func configureNoteImageViewConstraints() {
        NSLayoutConstraint.activate([
            self.noteImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.noteImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.noteImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.noteImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureFirstWordLabelConstraints() {
        NSLayoutConstraint.activate([
            self.firstWordLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.firstWordLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
