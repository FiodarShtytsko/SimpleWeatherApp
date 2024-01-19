//
//  WeatherAlert.swift
//  SimpleWeatherApp
//
//  Created by Fiodar Shtytsko on 19/01/2024.
//

import Foundation

struct FeatureCollection: Decodable {
    let features: [Feature]
}

struct Feature: Decodable {
    let properties: WeatherAlert
}

struct WeatherAlert: Decodable {
    let id: String
    let event: String
    let effective: String
    let ends: String?
    let senderName: String
}
