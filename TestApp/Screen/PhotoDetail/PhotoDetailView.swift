//
//  PhotoDetailView.swift
//  TestApp
//
//  Created by Sergey Gusev on 07.07.2024.
//

import SwiftUI

struct PhotoDetailView: View {
    let photo: Photo
    
    var body: some View {
        VStack {
            Text(photo.photographer)
                .font(.title)
                .padding()
            if let url = URL(string: photo.src.original) {
                CachedAsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .shadow(radius: 5)
                } placeholder: {
                    ProgressView()
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Photo Details")
    }
}
