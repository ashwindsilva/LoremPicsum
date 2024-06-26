//
//  PhotosListViewController.swift
//  LoremPicsum
//
//  Created by Ashwin D'Silva on 24/06/24.
//

import UIKit

class PhotosListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: ViewModel
    
    private lazy var photosListView: PhotosListView = {
        let view = PhotosListView()
        view.delegate = self
        return view
    }()
    
    // MARK: - Init
    
    init() {
        self.viewModel = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = photosListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - PhotosListViewDelegate

extension PhotosListViewController: PhotosListViewDelegate {
    func didSelect(_ photo: Photo, isChecked: Bool) {
        if isChecked {
            showPhotoInfo(for: photo)
        } else {
            showCheckboxAlert()
        }
    }
}

// MARK: - Methods

extension PhotosListViewController {
    private func showPhotoInfo(for photo: Photo) {
        let (title, message) = viewModel.alertInfo(for: photo)
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showCheckboxAlert() {
        let alert = UIAlertController(
            title: nil,
            message: "Tick the checkbox to view info",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        self.present(alert, animated: true, completion: nil)
    }
}
