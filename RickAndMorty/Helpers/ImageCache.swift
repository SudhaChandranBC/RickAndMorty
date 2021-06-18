//
//  ImageCache.swift
//  RickAndMorty
//
//  Created by Chandran, Sudha on 17/06/21.
//


import SwiftUI

/**
 ImageCache struct for maintain a memory cache and a disk cache using NSCache.
 */
protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

/**
 TemporaryImageCache struct for abstraction layer on top of NSCache.
 ### Properties
 - **cache**: NSCache object.
 */
struct TemporaryImageCache: ImageCache {
    private let cache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.countLimit = 200 // 200 items
        cache.totalCostLimit = 1024 * 1024 * 200 // 200 MB
        return cache
    }()
    
    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set { newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL) }
    }
}

/**
 ImageCacheKey to save the image in cache.
 ### Properties
 - **defaultValue**: ImageCache , TemporaryImageCache object.
 */
struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

/**
 Environment is essentially a dictionary with app-wide preferences. SwiftUI passes it automatically from the root view to its children.
 ### Properties
 - **imageCache**: ImageCache object.
 */
extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}
