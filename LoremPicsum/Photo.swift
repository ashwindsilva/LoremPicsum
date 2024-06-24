//
//  Photo.swift
//  LoremPicsum
//
//  Created by Ashwin D'Silva on 24/06/24.
//

import Foundation

struct Photo {
    let id: String
    let author: String?
    let width: Int?
    let height: Int?
}

extension Photo: Decodable { }
