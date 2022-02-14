//
//  ImageCache.swift
//  BR Eng Test
//
//  Created by Randy Varela on 2/11/22.
//

import Foundation

class ImageCache {
    static let shared = ImageCache()
    private init() {}
    
    var images: [String: Data] = [:]
}
