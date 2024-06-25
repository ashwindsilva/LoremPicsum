//
//  PhotosListView_ViewModel.swift
//  LoremPicsum
//
//  Created by Ashwin D'Silva on 25/06/24.
//

import Foundation

extension PhotosListView {
    enum UpdateType {
        case reload
        case newRows([IndexPath])
    }
    
    class ViewModel {
        
        // MARK: - Properties
        
        private let photosService: PhotosService
        private(set) var photos: [Photo]
        private var page: Int
        private var hasMorePages: Bool
        private var isLoading: Bool {
            didSet {
                onLoading?(isLoading)
            }
        }
        
        var onPhotosUpdate: ((UpdateType) -> ())?
        var onLoading: ((Bool) -> ())?
        
        // MARK: - Init
        
        init(photosService: PhotosService) {
            self.photosService = photosService
            self.photos = []
            self.page = 0
            self.hasMorePages = true
            self.isLoading = false
        }
        
        // MARK: - Methods
        
        private func fetchPhotos(atPage page: Int, onSuccess: @escaping ([Photo]) -> ()) {
            guard isLoading == false else {
                return
            }
            
            isLoading = true
            
            photosService.getPhotos(at: page) { [weak self] result in
                guard let self else { return }
                
                defer { self.isLoading = false }
                
                switch result {
                case .success(let photos):
                    self.page = page
                    onSuccess(photos)
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        func viewModel(for indexPath: IndexPath) -> PhotoTableViewCell.ViewModel {
            let photo = photos[indexPath.row]
            return .init(photo: photo)
        }
        
        func fetchInitialPhotos() {
            fetchPhotos(atPage: 1) { [weak self] photos in
                guard let self else { return }
                
                self.photos = photos
                self.onPhotosUpdate?(.reload)
            }
        }
        
        
        func refresh() {
            isLoading = false
            hasMorePages = true
            fetchInitialPhotos()
        }
        
        func loadMorePhotos() {
            guard hasMorePages else {
                return
            }
            
            fetchPhotos(atPage: page + 1) { [weak self] photos in
                guard let self else { return }
                
                let startIndex = self.photos.endIndex
                let endIndex = startIndex + photos.count
                let indexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0)}

                self.photos.append(contentsOf: photos)
                self.hasMorePages = !photos.isEmpty
                self.onPhotosUpdate?(.newRows(indexPaths))
            }
        }
    }
}
