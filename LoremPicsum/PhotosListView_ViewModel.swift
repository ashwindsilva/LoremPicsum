//
//  PhotosListView_ViewModel.swift
//  LoremPicsum
//
//  Created by Ashwin D'Silva on 25/06/24.
//

import Foundation

extension PhotosListView {
    class ViewModel {
        protocol Delegate: AnyObject {
            func failedToFetchInitialPhotos(_ error: Error)
            func failedToLoadMorePhotos(_ error: Error)
            func failedToRefresh(_ error: Error)
        }
        
        // MARK: - Types
        
        enum UpdateType {
            case reload
            case newRows([IndexPath])
        }
        
        // MARK: - Properties
        
        private let photosService: PhotosService
        private let imageLoader: ImageLoader
        private(set) var photos: [PhotoTableViewCell.ViewModel]
        private var page: Int
        private var hasMorePages: Bool
        private var isLoading: Bool {
            didSet {
                onLoading?(isLoading)
            }
        }
        
        weak var delegate: Delegate?
        
        var onPhotosUpdate: ((UpdateType) -> ())?
        var onLoading: ((Bool) -> ())?
        
        // MARK: - Init
        
        init(photosService: PhotosService, imageLoader: ImageLoader) {
            self.photosService = photosService
            self.imageLoader = imageLoader
            self.photos = []
            self.page = 0
            self.hasMorePages = true
            self.isLoading = false
        }
        
        // MARK: - Methods
        
        private func fetchPhotos(atPage page: Int, completion: @escaping (Result<[Photo], Error>) -> ()) {
            guard isLoading == false else {
                return
            }
            
            isLoading = true
            
            photosService.getPhotos(at: page) { [weak self] result in
                guard let self else { return }
                
                defer { self.isLoading = false }
                
                if let photos = try? result.get(), photos.isEmpty == false {
                    self.page = page
                }
                
                completion(result)
            }
        }
        
        private func viewModel(for photo: Photo) -> PhotoTableViewCell.ViewModel {
            return .init(photo: photo, imageLoader: imageLoader)
        }
        
        func viewModel(for indexPath: IndexPath) -> PhotoTableViewCell.ViewModel {
            return photos[indexPath.row]
        }
        
        func fetchInitialPhotos() {
            fetchPhotos(atPage: 1) { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let photos):
                    self.photos = photos.map(viewModel(for:))
                    self.onPhotosUpdate?(.reload)
                case .failure(let error):
                    delegate?.failedToFetchInitialPhotos(error)
                }
            }
        }
        
        
        func refresh() {
            isLoading = false
            hasMorePages = true
            
            fetchPhotos(atPage: 1) { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let photos):
                    self.photos = photos.map(viewModel(for:))
                    self.onPhotosUpdate?(.reload)
                case .failure(let error):
                    delegate?.failedToRefresh(error)
                }
            }
        }
        
        func loadMorePhotos() {
            guard hasMorePages else {
                return
            }
            
            fetchPhotos(atPage: page + 1) { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let photos):
                    let startIndex = self.photos.endIndex
                    let endIndex = startIndex + photos.count
                    let indexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0)}
                    
                    self.photos.append(contentsOf: photos.map(viewModel(for:)))
                    self.hasMorePages = !photos.isEmpty
                    self.onPhotosUpdate?(.newRows(indexPaths))
                case .failure(let error):
                    delegate?.failedToLoadMorePhotos(error)
                }
            }
        }
    }
}
