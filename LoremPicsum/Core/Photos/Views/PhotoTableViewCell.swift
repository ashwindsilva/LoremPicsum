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
        imageView.clipsToBounds = true
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
    
    private lazy var checkbox: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .primaryText
        button.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
        return button
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = spacing
        stackView.addArrangedSubview(photoImageView)
        stackView.addArrangedSubview(labelsStackView)
        stackView.addArrangedSubview(checkbox)
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
    private let imageSize: CGFloat = 100
    private var viewModel: ViewModel?
    private var imageLoadTaskID: UUID?
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private  func setupView() {
        contentView.addSubview(horizontalStackView)
        
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing),
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -spacing),
            
            photoImageView.widthAnchor.constraint(equalToConstant: imageSize),
            photoImageView.heightAnchor.constraint(equalToConstant: imageSize),
            
            checkbox.widthAnchor.constraint(equalToConstant: 50),
            checkbox.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func configure(with viewModel: ViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.description
        updateCheckbox()
        
        imageLoadTaskID = viewModel.imageLoader.loadImage(
            from: viewModel.imageURL(
                width: Int(imageSize),
                height: Int(imageSize)
            )
        ) { [weak self] result in
            do {
                let image = try result.get()
                DispatchQueue.main.async {
                    self?.photoImageView.image = image
                }
            } catch {
                
            }
        }
        
        viewModel.onChecked = { [weak self] _ in
            self?.updateCheckbox()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        photoImageView.image = nil
        
        if let imageLoadTaskID {
            viewModel?.imageLoader.cancelLoad(imageLoadTaskID)
        }
    }
    
    @objc
    private func toggleCheckbox() {
        viewModel?.toggleIsChecked()
    }
    
    private func updateCheckbox() {
        let image = (viewModel?.isChecked ?? false) ? UIImage(named: "checkbox") : UIImage(named: "checkbox_outline")
        checkbox.setImage(image, for: .normal)
    }
}
