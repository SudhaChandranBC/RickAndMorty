//
//  ImageLoader.swift
//  RickAndMorty
//
//  Created by Chandran, Sudha on 17/06/21.
//


import Combine
import SwiftUI

/**
 ImageLoader for handling image loading from url using cache
 ### Properties
 - **image**: UIImage object.
 
 ### Functions
 - **init**
 - **load**
 - **cancel**
 */

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private(set) var isLoading = false //property that indicates current loading status.
    private let url: URL //property which holds url of the image.
    private var cache: ImageCache? //property which holds image cache
    private var cancellable: AnyCancellable?
    private static let imageProcessingQueue = DispatchQueue(label: "image-processing") //DispatchQueue queue for image processing.
    
    /**
     init method.
     */
    init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }
    
    /**
     deinit method.
     */
    deinit {
        cancel()
    }
    
    /**
     Methods which loads the image from the cache or url provided.
     */
    func load() {
        guard !isLoading else { return }
        
        if let image = cache?[url] {
            self.image = image
            return
        }
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                          receiveOutput: { [weak self] in self?.cache($0) },
                          receiveCompletion: { [weak self] _ in self?.onFinish() },
                          receiveCancel: { [weak self] in self?.onFinish() })
            .subscribe(on: Self.imageProcessingQueue)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0}
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func onStart() {
        isLoading = true
    }
    
    private func onFinish() {
        isLoading = false
    }
    
    private func cache(_ image: UIImage?) {
        image.map { cache?[url] = $0 }
    }
}
