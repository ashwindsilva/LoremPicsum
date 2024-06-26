//
//  PhotoTableViewCell_ViewModel.swift
//  LoremPicsum
//
//  Created by Ashwin D'Silva on 25/06/24.
//

import Foundation

extension PhotoTableViewCell {
    class ViewModel {
        // MARK: - Properties
        
        let photo: Photo
        let imageLoader: ImageLoader
        
        var title: String {
            return "Author: \(photo.author ?? "NA")"
        }
        
        var description: String? {
            guard let width = photo.width, let height = photo.height else {
                return nil
            }
            
            return """
            Width: \(width)
            Height: \(height)
            """
        }
        
        // MARK: - Init
        
        init(photo: Photo, imageLoader: ImageLoader) {
            self.photo = photo
            self.imageLoader = imageLoader
        }
        
        // MARK: - Methods
        
        func imageURL(width: Int, height: Int) -> URL {
            return URL(string: "https://picsum.photos/id/\(photo.id)/\(width)/\(height)" )!
        }
    }
}
