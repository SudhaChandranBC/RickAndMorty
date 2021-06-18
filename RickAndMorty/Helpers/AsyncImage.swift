//
//  AsyncImage.swift
//  RickAndMorty
//
//  Created by Chandran, Sudha on 17/06/21.
//

import SwiftUI

/**
 AsyncImage struct for UIImage which can be loaded asynchronously with URL.
 ### Properties
 - **loader**: ImageLoader object to load image from url.
 - **placeholder**: Placeholder view (eg: color, image, ProgressView())
 - **image**: UIImage for AsyncImage
 
 ### SeeAlso
 - **ImageLoader**: Info struct in ImageLoader.swift.
 */
struct AsyncImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder
    private let image: (UIImage) -> Image
    
    init(
        url: URL,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)
    ) {
        self.placeholder = placeholder()
        self.image = image
        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue))
    }
    
    var body: some View {
        content
            .onAppear(perform: loader.load)
    }
    
    private var content: some View {
        Group {
            if loader.image != nil {
                image(loader.image!)
            } else {
                placeholder
            }
        }
    }
}
