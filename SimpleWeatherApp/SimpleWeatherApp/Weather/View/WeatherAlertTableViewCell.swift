//
//  WeatherAlertTableViewCell.swift
//  SimpleWeatherApp
//
//  Created by Fiodar Shtytsko on 19/01/2024.
//

import UIKit

struct WeatherAlertTableViewModel {
    let eventName: String
    let startDate: String
    let endDate: String
    let sourceAndDuration: String
    let image: UIImage
}

final class WeatherAlertTableViewCell: UITableViewCell {

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var eventLabel: UILabel!
    @IBOutlet private weak var startDateLabel: UILabel!
    @IBOutlet private weak var endDateLabel: UILabel!
    @IBOutlet private weak var sourceAndDurationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with model: WeatherAlertTableViewModel) {
        eventLabel.text = model.eventName
        startDateLabel.text = model.startDate
        endDateLabel.text = model.endDate
        sourceAndDurationLabel.text = model.sourceAndDuration
    }
    
    func configure(image: UIImage) {
        avatarImageView.image = image
    }
}
