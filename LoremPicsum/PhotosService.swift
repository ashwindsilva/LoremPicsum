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

// TODO: - Implement network layer
// TODO: - Handle errors

struct PhotosService {
    func getPhotos(at page: Int, completion: @escaping (Result<[Photo], PhotosServiceError>) -> ()) {
        let url = URL(string: "https://picsum.photos/v2/list?page=\(page)")!
        
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
