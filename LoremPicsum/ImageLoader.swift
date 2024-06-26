//
//  ImageLoader.swift
//  LoremPicsum
//
//  Created by Ashwin D'Silva on 26/06/24.
//

import UIKit

class ImageLoader {
    
    // MARK: - Properties
    
    private var cache: NSCache<NSString, UIImage> = .init()
    private var activeRequests: [UUID: URLSessionDataTask] = .init()
    
    // MARK: - Methods
    
    @discardableResult
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> ()) -> UUID? {
        let key = url.absoluteString as NSString
        
        if let image = cache.object(forKey: key) {
            completion(image)
            return nil
        }
        
        let uuid = UUID()
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self else { return }
            
            defer {
                activeRequests.removeValue(forKey: uuid)
            }
            
            guard error == nil, let data, let image = UIImage(data: data) else {
                // TODO: handle error
                completion(nil)
                return
            }
            
            completion(image)
            self.cache.setObject(image, forKey: key)
        }
        
        activeRequests[uuid] = task
        
        task.resume()
        
        return uuid
    }
    
    func cancelLoad(_ uuid: UUID) {
        guard let task = activeRequests[uuid] else {
            return
        }
        
        task.cancel()
        activeRequests.removeValue(forKey: uuid)
    }
}
