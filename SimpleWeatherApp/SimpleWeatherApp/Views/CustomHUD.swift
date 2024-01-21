//
//  CustomHUD.swift
//  SimpleWeatherApp
//
//  Created by Fiodar Shtytsko on 21/01/2024.
//

import UIKit

final class CustomHUD: UIView {
    private let spinner = UIActivityIndicatorView(style: .large)
    private let messageLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHUD()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupHUD()
    }
    
    func show(over view: UIView) {
        let size: CGFloat = 120
        frame = CGRect(x: (view.bounds.width - size) / 2,
                       y: (view.bounds.height - size) / 2,
                       width: size, height: size)
        view.addSubview(self)
    }

    func hide() {
        removeFromSuperview()
    }

    private func setupHUD() {
        setupAppearance()
        setupSpinner()
        setupMessageLabel()
        setupConstraints()
    }

    private func setupAppearance() {
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        layer.cornerRadius = 10
    }

    private func setupSpinner() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        spinner.color = .white
        addSubview(spinner)
    }

    private func setupMessageLabel() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = "Loading..."
        messageLabel.textColor = .white
        addSubview(messageLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageLabel.topAnchor.constraint(equalTo: spinner.bottomAnchor, constant: 10),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
