//
//  PhotosListViewController_ViewModel.swift
//  LoremPicsum
//
//  Created by Ashwin D'Silva on 26/06/24.
//

import Foundation

extension PhotosListViewController {
    class ViewModel {  
        // MARK: - Properties
        
        let photosListViewModel: PhotosListView.ViewModel
        
        // MARK: - Init
        
        init(photosService: PhotosService, imageLoader: ImageLoader) {
            self.photosListViewModel = .init(
                photosService: photosService,
                imageLoader: imageLoader
            )
        }
        
        // MARK: - Methods
        
        /// Generates alert info for the specified photo
        func alertInfo(for photo: Photo) -> (title: String, message: String?) {
            let title: String = "Info"
            let message: String? = {
                guard let author = photo.author, let width = photo.width, let height = photo.height else {
                    return nil
                }
                
                return """
                Author: \(author)
                Image dimension: \(width)x\(height)
                """
            }()
            
            return (title, message)
        }
    }
}
