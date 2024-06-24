//
//  PhotoTableViewCell.swift
//  LoremPicsum
//
//  Created by Ashwin D'Silva on 24/06/24.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    // MARK: - Views
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondaryBackground
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .primaryText
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryText
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = spacing
        stackView.addArrangedSubview(photoImageView)
        stackView.addArrangedSubview(labelsStackView)
        return stackView
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.spacing = 2
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        return stackView
    }()
    
    // MARK: - Properties
    
    static let reuseIdentifier: String = "PhotoTableViewCell"
    
    private let spacing: CGFloat = 16
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func setupView() {
        contentView.addSubview(horizontalStackView)
        
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing),
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -spacing),
            
            photoImageView.widthAnchor.constraint(equalToConstant: 100),
            photoImageView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
}
