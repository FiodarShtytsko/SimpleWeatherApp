//
//  ImageDonwloadService.swift
//  SimpleWeatherApp
//
//  Created by Fiodar Shtytsko on 19/01/2024.
//

import UIKit

protocol ImageDownloadable {
    func downloadImage(with id: Int,
                       completion: @escaping (Result<UIImage, ImageDownloadError>) -> Void)
}

final class ImageDownloadService {
    private let imageCache = NSCache<NSString, UIImage>()
    private let urlSession: URLSession
    
    init(session: URLSession = .shared) {
        self.urlSession = session
    }
}

extension ImageDownloadService: ImageDownloadable {
    func downloadImage(with id: Int,
                       completion: @escaping (Result<UIImage, ImageDownloadError>) -> Void) {
        if let image = getCachedImage(for: id) {
            completion(.success(image))
            return
        }
        performNetworkRequest(completion: completion)
    }
}

private extension ImageDownloadService {
    func getCachedImage(for id: Int) -> UIImage? {
        let cacheKey = NSString(string: String(id))
        return imageCache.object(forKey: cacheKey)
    }
    
    func performNetworkRequest(completion: @escaping (Result<UIImage, ImageDownloadError>) -> Void) {
        let imageURL = URL(string: "https://picsum.photos/1000")
        guard let url = imageURL else {
            completion(.failure(.invalidURL))
            return
        }
        
        urlSession.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.networkError(error)))
                    return
                }
                
                guard let self = self, let data = data else {
                    completion(.failure(.dataIsNil))
                    return
                }
                
                self.handleDownloadedData(data, for: url, completion: completion)
            }
        }.resume()
    }
    
    func handleDownloadedData(_ data: Data,
                              for url: URL,
                              completion: (Result<UIImage, ImageDownloadError>) -> Void) {
        guard let image = UIImage(data: data) else {
            completion(.failure(.imageCreationFailed))
            return
        }
        
        let cacheKey = NSString(string: url.absoluteString)
        imageCache.setObject(image, forKey: cacheKey)
        completion(.success(image))
    }
}
