//
//  PhotosListViewController_ViewModel.swift
//  LoremPicsum
//
//  Created by Ashwin D'Silva on 26/06/24.
//

import Foundation

extension PhotosListViewController {
    class ViewModel {        
        let photosListViewModel: PhotosListView.ViewModel
        
        init(photosService: PhotosService) {
            self.photosListViewModel = .init(
                photosService: photosService,
                imageLoader: .init()
            )
        }
        
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
