//
//  PhotosListView_ViewModel.swift
//  LoremPicsum
//
//  Created by Ashwin D'Silva on 25/06/24.
//

import Foundation

extension PhotosListView {
    
    class ViewModel {
        
        // MARK: - Properties
        
        private let photosService: PhotosService
        private(set) var photos: [Photo]
        
        var onPhotosUpdate: (() -> ())?
        
        // MARK: - Init
        
        init(photosService: PhotosService) {
            self.photosService = photosService
            self.photos = []
        }
        
        // MARK: - Methods
        
        func fetchPhotos() {
            photosService.getPhotos { result in
                switch result {
                case .success(let photos):
                    self.photos = photos
                    self.onPhotosUpdate?()
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        func viewModel(for indexPath: IndexPath) -> PhotoTableViewCell.ViewModel {
            let photo = photos[indexPath.row]
            return .init(photo: photo)
        }
    }
}
