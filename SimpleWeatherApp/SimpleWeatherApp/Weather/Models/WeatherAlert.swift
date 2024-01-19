//
//  WeatherAlert.swift
//  SimpleWeatherApp
//
//  Created by Fiodar Shtytsko on 19/01/2024.
//

import Foundation

struct WeatherAlert: Decodable {
    let id: String
    let event: String
    let effective: String
    let ends: String
    let senderName: String
}
