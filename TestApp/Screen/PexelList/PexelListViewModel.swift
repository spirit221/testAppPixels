//
//  PexelListViewModel.swift
//  TestApp
//
//  Created by Sergey Gusev on 07.07.2024.
//

import Foundation
import Combine

class PexelListViewModel: ObservableObject {
    @Published var photos = [Photo]()
    @Published var isLoading = false
    @Published var page = 1
    @Published var perPage = 15
    @Published var reachedEnd = false
    
    private var cancellables = Set<AnyCancellable>()
    private let pexelsService: PexelsServiceProtocol
    
    init(service: PexelsServiceProtocol = PexelsService()) {
        self.pexelsService = service
        fetchPhotos()
    }
    
    func fetchPhotos() {
        guard !isLoading && !reachedEnd else { return }
        
        isLoading = true
        
        pexelsService.fetchCuratedPhotos(page: page, perPage: perPage)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    print("Error fetching photos: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                self.photos.append(contentsOf: response.photos)
                self.isLoading = false
                self.page += 1
                
                if self.photos.count >= response.totalResults {
                    self.reachedEnd = true
                }
            })
            .store(in: &cancellables)
    }
    
    func loadMorePhotos() {
        fetchPhotos()
    }
    
    func refreshPhotos() {
        page = 1
        photos.removeAll()
        reachedEnd = false
        fetchPhotos()
    }
}
