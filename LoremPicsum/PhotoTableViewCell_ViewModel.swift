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
        
        init(photo: Photo) {
            self.photo = photo
        }
    }
}
