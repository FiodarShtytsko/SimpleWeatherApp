//
//  ImageDownloadError.swift
//  SimpleWeatherApp
//
//  Created by Fiodar Shtytsko on 19/01/2024.
//

import Foundation

enum ImageDownloadError: Error {
    case networkError(Error)
    case dataIsNil
    case imageCreationFailed
    case invalidURL
    
    var errorDescription: String {
        switch self {
        case .networkError(let error):
            return "Network error occurred: \(error.localizedDescription)"
        case .dataIsNil:
            return "No data received from the server."
        case .imageCreationFailed:
            return "Unable to create an image from the data."
        case .invalidURL:
            return "The URL provided was invalid."
        }
    }
}
