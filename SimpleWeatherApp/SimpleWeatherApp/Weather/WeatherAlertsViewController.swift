//
//  ViewController.swift
//  SimpleWeatherApp
//
//  Created by Fiodar Shtytsko on 17/01/2024.
//

import UIKit

final class WeatherAlertsViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let hud = CustomHUD()
    private let refreshControl = UIRefreshControl()
    
    private var viewModel: WeatherAlertsViewModelable!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewModel()
        setupTableView()
        loadWeatherData()
    }
    
    private func configureViewModel() {
        viewModel = WeatherAlertsViewModel(networkService: WeatherApiService(),
                                           downloadService: ImageDownloadService())
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.updateUI = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            self?.presentErrorAlert(message: errorMessage)
        }
        
        viewModel.onImageDownloaded = { [weak self] index in
            self?.updateImageForCell(at: index)
        }
    }
    
    private func setupTableView() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        tableView.register(WeatherAlertTableViewCell.self)
    }
    
    private func loadWeatherData() {
        hud.show(over: view)
        viewModel.loadWeatherData()
    }
    
    private func updateUI() {
        tableView.reloadData()
        hud.hide()
        refreshControl.endRefreshing()
    }
    
    private func updateImageForCell(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        if tableView.indexPathsForVisibleRows?.contains(indexPath) == true {
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    private func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    @objc private func refreshWeatherData(_ sender: UIRefreshControl) {
        viewModel.loadWeatherData()
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
        cell.configure(with: model)
        cell.configure(image: image)
        return cell
    }
}

extension WeatherAlertsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.downloadImage(forIndex: indexPath.row)
    }
}
