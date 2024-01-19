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
        
        viewModel.onImageDownloaded = { [weak self] index, image in
            let indexPath = IndexPath(row: index, section: 0)
            self?.tableView.reloadRows(at: [indexPath], with: .fade)
        }
        
        
        tableView.register(WeatherAlertTableViewCell.self)
        viewModel.loadWeatherData()
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
        let image = viewModel.images[indexPath.row] ?? .placeholder
        let cell: WeatherAlertTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        viewModel.downloadImage(forIndex: indexPath.row)
        cell.configure(with: model)
        cell.configure(image: image)
        return cell
    }
}
