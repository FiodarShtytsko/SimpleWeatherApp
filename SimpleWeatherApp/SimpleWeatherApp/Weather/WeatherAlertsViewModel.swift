//
//  WeatherAlertsViewModel.swift
//  SimpleWeatherApp
//
//  Created by Fiodar Shtytsko on 19/01/2024.
//

import Foundation

protocol WeatherAlertsViewModelable {
    var models: [WeatherAlertTableViewModel] { get }
    
    func loadWeatherAlert()
}

final class WeatherAlertsViewModel: WeatherAlertsViewModelable {
    
    private(set) var models: [WeatherAlertTableViewModel]
    
    init(models: [WeatherAlertTableViewModel] = []) {
        self.models = models
    }
}

extension WeatherAlertsViewModel {
    func loadWeatherAlert() {
        for index in 0...10 {
            models.append(WeatherAlertTableViewModel(eventName: "EventNAME - \(index)",
                                                     startDate: "startDate - \(index)",
                                                     endDate: "endDate - \(index)",
                                                     sourceAndDuration: "sourceAndDuration - \(index)"))
        }
    }
}
