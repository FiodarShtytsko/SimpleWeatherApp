//
//  ViewController.swift
//  SimpleWeatherApp
//
//  Created by Fiodar Shtytsko on 17/01/2024.
//

import UIKit

final class WeatherAlertsViewController: UIViewController {
   
    @IBOutlet private weak var tableView: UITableView!
    
    private var viewModel: WeatherAlertsViewModelable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = WeatherAlertsViewModel()
        tableView.register(WeatherAlertTableViewCell.self)
        
        viewModel.loadWeatherAlert()
    }
}

extension WeatherAlertsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.models[indexPath.row]
        let cell: WeatherAlertTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: model)
        return cell
    }
}
