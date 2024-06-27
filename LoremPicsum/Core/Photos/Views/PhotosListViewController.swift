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
        let viewModel = viewModel.photosListViewModel
        viewModel.delegate = self
        let view = PhotosListView(viewModel: viewModel)
        return view
    }()
    
    // MARK: - Init
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
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
            showPhotoInfoAlert(for: photo)
        } else {
            showCheckboxAlert()
        }
    }
}

// MARK: - PhotosListView.ViewModel.Delegate

extension PhotosListViewController: PhotosListView.ViewModel.Delegate {
    func didFailToFetchInitialPhotos(with error: any Error) {
        showFailedInitialPhotosFetchAlert()
    }
    
    func didFailToLoadMorePhotos(with error: any Error) {
        showFailedLoadMorePhotosFetchAlert()
    }
    
    func didFailToRefresh(with error: any Error) {
        showFailedRefreshPhotosAlert()
    }
}

// MARK: - Methods

extension PhotosListViewController {
    /// Returns alert view controller with the specified title and message along with 'ok' action
    private func alert(title: String?, message: String?) -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        return alert
    }
    
    /// Presents an alert with information of  the specified photo
    private func showPhotoInfoAlert(for photo: Photo) {
        let info = viewModel.alertInfo(for: photo)
        let alert = alert(title: info.title, message: info.message)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /// Presents an alert instructing the user to tick the checkbox to view photo info
    private func showCheckboxAlert() {
        let alert = alert(title: nil, message: "Tick the checkbox to view photo info")
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showFailedInitialPhotosFetchAlert() {
        let alert = alert(title: "Error", message: "Failed to fetch photos")
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showFailedLoadMorePhotosFetchAlert() {
        let alert = alert(title: "Error", message: "Failed to fetch more photos")
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showFailedRefreshPhotosAlert() {
        let alert = alert(title: "Error", message: "Failed to refresh photos")
        self.present(alert, animated: true, completion: nil)
    }
}
