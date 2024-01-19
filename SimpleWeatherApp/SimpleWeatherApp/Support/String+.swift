//
//  String+.swift
//  SimpleWeatherApp
//
//  Created by Fiodar Shtytsko on 19/01/2024.
//

import Foundation

extension String {
    func toReadableDate() -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let date = isoFormatter.date(from: self) else { return "Invalid Date" }
        return  DateHelper.shared.format(date)
    }
}
