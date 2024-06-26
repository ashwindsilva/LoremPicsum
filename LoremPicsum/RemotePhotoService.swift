//
//  RemotePhotoService.swift
//  LoremPicsum
//
//  Created by Ashwin D'Silva on 26/06/24.
//

import Foundation

// TODO: - Implement network layer
// TODO: - Handle errors

class RemotePhotosService: PhotosService {
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
