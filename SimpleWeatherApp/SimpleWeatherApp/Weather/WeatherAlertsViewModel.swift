//
//  WeatherAlertsViewModel.swift
//  SimpleWeatherApp
//
//  Created by Fiodar Shtytsko on 19/01/2024.
//

import Foundation

protocol WeatherAlertsViewModelable {
    var models: [WeatherAlertTableViewModel] { get }
    var updateUI: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    
    func loadWeatherAlert()
}

final class WeatherAlertsViewModel: WeatherAlertsViewModelable {
    
    var updateUI: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private(set) var models: [WeatherAlertTableViewModel] {
        didSet {
            updateUI?()
        }
    }
    private let network = WeatherApiService()
    
    init(models: [WeatherAlertTableViewModel] = []) {
        self.models = models
    }
}

extension WeatherAlertsViewModel {
    func loadWeatherAlert() {
        network.fetchWeatherAlerts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let alerts):
                    self?.models = alerts.compactMap { return WeatherAlertTableViewModel(eventName: $0.event,
                                                                                         startDate: $0.effective.toReadableDate(),
                                                                                         endDate: $0.ends?.toReadableDate() ?? "No date",
                                                                                         sourceAndDuration: $0.senderName)}
                case .failure(let error):
                    self?.onError?(error.errorDescription)
                }
            }
        }
    }
}
