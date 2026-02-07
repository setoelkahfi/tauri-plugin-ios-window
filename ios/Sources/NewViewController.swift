//
//  NewViewController.swift
//  tauri-plugin-ios-window
//
//  Created by Seto Elkahfi on 2026-02-07.
//

import UIKit
import WebKit

final class NewViewController: UIViewController {

    var url: String = ""

    private var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Window"
        view.backgroundColor = .systemBackground

        setupUI()
        loadURL()
    }

    private func setupUI() {
        // Configure WebView
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        view.addSubview(webView)

        // Close button
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        closeButton.backgroundColor = .systemBackground.withAlphaComponent(0.9)
        closeButton.layer.cornerRadius = 8
        closeButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)

        NSLayoutConstraint.activate([
            // WebView constraints
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Close button constraints
            closeButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
        ])
    }

    private func loadURL() {
        guard let urlToLoad = URL(string: url) else {
            print("Invalid URL: \(url)")
            return
        }

        let request = URLRequest(url: urlToLoad)
        webView.load(request)
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}
