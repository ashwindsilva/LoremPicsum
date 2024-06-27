//
//  PhotosService.swift
//  LoremPicsum
//
//  Created by Ashwin D'Silva on 24/06/24.
//

import Foundation

protocol PhotosService {
    func getPhotos(at page: Int, completion: @escaping (Result<[Photo], any Error>) -> ())
}
