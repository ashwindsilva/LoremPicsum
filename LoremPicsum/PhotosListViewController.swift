//
//  PhotosListViewController.swift
//  LoremPicsum
//
//  Created by Ashwin D'Silva on 24/06/24.
//

import UIKit

class PhotosListViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var photosListView: PhotosListView = {
        let view = PhotosListView()
        view.delegate = self
        return view
    }()
    
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
        let alertTitle: String?
        let alertMessage: String?
        
        if isChecked {
            alertTitle = "Info"
            alertMessage = """
            Author: \(photo.author ?? "NA")
            """
        } else {
            alertTitle = nil
            alertMessage = "Tick the checkbox to view info"
        }
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
}
