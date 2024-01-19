//
//  WeatherAlertsViewModel.swift
//  SimpleWeatherApp
//
//  Created by Fiodar Shtytsko on 19/01/2024.
//

import UIKit

protocol WeatherAlertsViewModelable {
    var models: [WeatherAlertTableViewModel] { get }
    var images: [Int: UIImage] { get }

    var updateUI: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    var onImageDownloaded: ((Int, UIImage) -> Void)? { get set }
    
    func loadWeatherData()
    func downloadImage(forIndex index: Int)
}

final class WeatherAlertsViewModel: WeatherAlertsViewModelable {
    
    var updateUI: (() -> Void)?
    var onError: ((String) -> Void)?
    var onImageDownloaded: ((Int, UIImage) -> Void)?

    private(set) var images: [Int: UIImage] = [:]
    private(set) var models: [WeatherAlertTableViewModel] {
        didSet {
            updateUI?()
        }
    }
    private let network = WeatherApiService()
    private let downloadService = ImageDownloadService()

    init(models: [WeatherAlertTableViewModel] = []) {
        self.models = models
    }
}

extension WeatherAlertsViewModel {
    
    func loadWeatherData() {
        network.fetchWeatherAlerts { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let alerts):
                        self?.models = alerts.compactMap {
                            return WeatherAlertTableViewModel(eventName: $0.event,
                                                              startDate: $0.effective.toReadableDate(),
                                                              endDate: $0.ends?.toReadableDate() ?? "No date",
                                                              sourceAndDuration: $0.senderName,
                                                              image: .checkmark)
                        }
                        
                    case .failure(let error):
                        self?.onError?(error.localizedDescription)
                    }
                }
            }
        }
    
    func downloadImage(forIndex index: Int) {
        guard images[index] == nil else { return }
        downloadService.downloadImage(with: index) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        self?.images[index] = image
                        self?.onImageDownloaded?(index, image)
                    case .failure(let error):
                        self?.onError?(error.localizedDescription)
                    }
                }
            }
        }
}
