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
        
        viewModel.updateUI = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.onError = { [weak self] errorMessage in
            self?.presentErrorAlert(message: errorMessage)
        }
        
        
        tableView.register(WeatherAlertTableViewCell.self)
        viewModel.loadWeatherAlert()
    }
    
    private func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
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
