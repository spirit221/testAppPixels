//
//  PexelListView.swift
//  TestApp
//
//  Created by Sergey Gusev on 07.07.2024.
//

import SwiftUI

struct PexelListView: View {
    @StateObject private var viewModel = PexelListViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.photos) { photo in
                        NavigationLink(destination: PhotoDetailView(photo: photo)) {
                            PhotoCell(photo: photo)
                        }
                        .onAppear {
                            if photo == viewModel.photos.last {
                                viewModel.loadMorePhotos()
                            }
                        }
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                    }
                }
            }
            .navigationTitle("Pexels Photos")
            .toolbar {
                Button("Clear cache") {
                    ImageCache.shared.clearCache()
                }
            }
            .refreshable {
                viewModel.refreshPhotos()
            }
        }
    }
}

struct PhotoCell: View {
    let photo: Photo
    
    var body: some View {
        HStack {
            Rectangle()
                .aspectRatio(1, contentMode: .fit)
                .tint(.gray)
                .overlay {
                    if let url = URL(string: photo.src.medium) {
                        CachedAsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
            
            .frame(width: 200, height: 200)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            Text(photo.photographer)
                .font(.caption)
                .padding(.top, 5)
            
            Spacer()
        }
        .padding()
    }
}
