//
//  RemotePhotoService.swift
//  LoremPicsum
//
//  Created by Ashwin D'Silva on 26/06/24.
//

import Foundation

enum RemotePhotosServiceError: Error {
    case invalidResponse
    case badResponse(URLResponse)
    case noData
    case decoding(Error)
    case unknown(Error)
}

class RemotePhotosService: PhotosService {
    func getPhotos(at page: Int, completion: @escaping (Result<[Photo], Error>) -> ()) {
        let url = URL(string: "https://picsum.photos/v2/list?page=\(page)")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(RemotePhotosServiceError.unknown(error!)))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(RemotePhotosServiceError.invalidResponse))
                return
            }
            
            guard case let statusCode = response.statusCode, (200...300).contains(statusCode) else {
                completion(.failure(RemotePhotosServiceError.badResponse(response)))
                return
            }
            
            guard let data else {
                completion(.failure(RemotePhotosServiceError.noData))
                return
            }
            
            do {
                let photos = try JSONDecoder().decode([Photo].self, from: data)
                completion(.success(photos))
            } catch {
                completion(.failure(RemotePhotosServiceError.decoding(error)))
            }
        }.resume()
    }
}
