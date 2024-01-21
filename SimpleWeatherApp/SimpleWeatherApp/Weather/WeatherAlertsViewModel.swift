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
    var onImageDownloaded: ((Int) -> Void)? { get set }
    
    func loadWeatherData()
    func downloadImage(forIndex index: Int)
}

final class WeatherAlertsViewModel: WeatherAlertsViewModelable {
    
    var updateUI: (() -> Void)?
    var onError: ((String) -> Void)?
    var onImageDownloaded: ((Int) -> Void)?

    private(set) var images: [Int: UIImage] = [:]
    private(set) var models: [WeatherAlertTableViewModel] {
        didSet {
            updateUI?()
        }
    }
    
    private let networkService: WeatherApi
    private let downloadService: ImageDownloadable

    init(models: [WeatherAlertTableViewModel] = [],
         networkService: WeatherApi,
         downloadService:  ImageDownloadable) {
        self.models = models
        self.networkService = networkService
        self.downloadService = downloadService
    }
}

extension WeatherAlertsViewModel {
    
    func loadWeatherData() {
        networkService.fetchWeatherAlerts { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let alerts):
                        self?.models = alerts.compactMap { [weak self] in
                            return self?.makeWeatherAlertModel(with: $0)
                        }
                    case .failure(let error):
                        self?.onError?(error.errorDescription)
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
                        self?.onImageDownloaded?(index)
                    case .failure(let error):
                        self?.onError?(error.errorDescription)
                    }
                }
            }
        }
}

private extension WeatherAlertsViewModel {
    func makeWeatherAlertModel(with model: WeatherAlert) -> WeatherAlertTableViewModel{
        let readableStart = model.effective.toReadableDate()
        let readableEnd = model.ends?.toReadableDate() ?? "No date"
        
        let eventName = "Name: \(model.event)"
        let startDate = "Start: \(readableStart)"
        let endDate = "End: \(readableEnd)"
        let sourceAndDuration = "\(model.senderName): \(readableStart) - \(readableEnd)"
        
        return WeatherAlertTableViewModel(eventName: eventName,
                                          startDate: startDate,
                                          endDate: endDate,
                                          sourceAndDuration: sourceAndDuration)
    }
}
