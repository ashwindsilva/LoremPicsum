//
//  RemoteImageLoader.swift
//  LoremPicsum
//
//  Created by Ashwin D'Silva on 27/06/24.
//

import UIKit

/// Utility class for asynchronously loading images from remote URLs
class RemoteImageLoader: ImageLoader {
    deinit {
        print("DEINIT RemoteImageLoader")
    }
    
    // MARK: - Properties
    
    private var cache: NSCache<NSString, UIImage> = .init()
    private var activeTasks: [UUID: URLSessionDataTask] = .init()
    
    // MARK: - Methods
    
    @discardableResult
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> ()) -> UUID? {
        let key = url.absoluteString as NSString
        
        // If image is cached immediately return the image
        if let image = cache.object(forKey: key) {
            completion(image)
            return nil
        }
        
        let uuid = UUID()
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self else { return }
            
            // Remove the task from active tasks on receiving a response
            defer {
                activeTasks.removeValue(forKey: uuid)
            }
            
            guard error == nil, let data, let image = UIImage(data: data) else {
                // TODO: handle error
                completion(nil)
                return
            }
            
            completion(image)
            
            // Cache the image
            self.cache.setObject(image, forKey: key)
        }
        
        activeTasks[uuid] = task
        
        task.resume()
        
        return uuid
    }
    
    func cancelLoad(_ uuid: UUID) {
        guard let task = activeTasks[uuid] else {
            return
        }
        
        task.cancel()
        activeTasks.removeValue(forKey: uuid)
    }
}
