//
//  PhotosService.swift
//  LoremPicsum
//
//  Created by Ashwin D'Silva on 24/06/24.
//

import Foundation

enum PhotosServiceError: Error {
    case networkError
    case decodingError
}

protocol PhotosServiceProtocol {
    func getPhotos(completion: @escaping (Result<[Photo], PhotosServiceError>) -> ())
}

// TODO: - Implement network layer
// TODO: - Handle errors

struct PhotosService {
    func getPhotos(completion: @escaping (Result<[Photo], PhotosServiceError>) -> ()) {
        let url = URL(string: "https://picsum.photos/v2/list")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data else {
                completion(.failure(.networkError))
                return
            }
            
            do {
                let photos = try JSONDecoder().decode([Photo].self, from: data)
                completion(.success(photos))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
