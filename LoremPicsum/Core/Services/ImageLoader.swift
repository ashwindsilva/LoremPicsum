//
//  ImageLoader.swift
//  LoremPicsum
//
//  Created by Ashwin D'Silva on 26/06/24.
//

import UIKit

protocol ImageLoader {
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> ()) -> UUID?
    func cancelLoad(_ uuid: UUID)
}
