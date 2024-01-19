//
//  ViewController.swift
//  SimpleWeatherApp
//
//  Created by Fiodar Shtytsko on 17/01/2024.
//

import UIKit

final class WeatherAlertsViewController: UIViewController, UITableViewDataSource {
    let tableView = UITableView()
    var weatherAlerts: [WeatherAlert] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.register(WeatherAlertCell.self, forCellReuseIdentifier: WeatherAlertCell.identifier)
        // Set up tableView layout

        loadWeatherAlerts()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherAlerts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherAlertCell.identifier, for: indexPath) as! WeatherAlertCell
        let alert = weatherAlerts[indexPath.row]
        cell.configure(with: alert)
        return cell
    }

    private func loadWeatherAlerts() {
        // Perform a GET request to the weather API
        // Parse the JSON and reload the tableView
    }
}

struct WeatherAlert: Codable {
    let id: String
    let event: String
    let effective: String
    let ends: String
    let senderName: String

    var duration: String {
        return "100"
        // Logic to calculate duration from effective and ends
    }
}

class WeatherAlertCell: UITableViewCell {
    static let identifier = "WeatherAlertCell"

    let titleLabel = UILabel()
    let effectiveLabel = UILabel()
    let endsLabel = UILabel()
    let senderNameLabel = UILabel()
    let durationLabel = UILabel()
    let alertImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Add and layout titleLabel, effectiveLabel, endsLabel, senderNameLabel, durationLabel, and alertImageView
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with alert: WeatherAlert) {
        titleLabel.text = alert.event
        effectiveLabel.text = "Effective: \(alert.effective)"
        endsLabel.text = "Ends: \(alert.ends)"
        senderNameLabel.text = "Source: \(alert.senderName)"
        durationLabel.text = "Duration: \(alert.duration)"
        
        // Load image asynchronously
        if let url = URL(string: "https://picsum.photos/1000") {
            // Use URLSession or a library like SDWebImage to load the image
        }
    }
}
