//
//  CachedAsyncImage.swift
//  TestApp
//
//  Created by Sergey Gusev on 07.07.2024.
//

import SwiftUI

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let content: (Image) -> Content
    private let placeholder: Placeholder
    
    init(url: URL, @ViewBuilder content: @escaping (Image) -> Content, @ViewBuilder placeholder: () -> Placeholder) {
        self.content = content
        self.placeholder = placeholder()
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
    }
    
    var body: some View {
        Group {
            if let uiImage = loader.image {
                content(Image(uiImage: uiImage))
            } else {
                placeholder
            }
        }
        .onAppear(perform: loader.load)
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func load() {
        if let cachedImage = ImageCache.shared.getImage(forKey: url.absoluteString) {
            self.image = cachedImage
        } else {
            downloadImage()
        }
    }
    
    private func downloadImage() {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self,
                  let data = data,
                  let uiImage = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                ImageCache.shared.setImage(uiImage, forKey: self.url.absoluteString)
                self.image = uiImage
            }
        }.resume()
    }
}
