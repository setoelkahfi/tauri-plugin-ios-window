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
    var windowTitle: String = "Sign in"

    private var webView: WKWebView!
    private var progressView: UIProgressView!
    private var navigationBar: UIView!
    private var titleLabel: UILabel!
    private var loadingIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupNavigationBar()
        setupWebView()
        setupProgressIndicator()
        loadURL()
    }

    private func setupNavigationBar() {
        // Navigation bar container
        navigationBar = UIView()
        navigationBar.backgroundColor = .systemBackground
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)

        // Add subtle bottom border
        let borderView = UIView()
        borderView.backgroundColor = .separator.withAlphaComponent(0.3)
        borderView.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addSubview(borderView)

        // Close button (leading position per Apple HIG for modal presentations)
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        navigationBar.addSubview(closeButton)

        // Title label (centered)
        titleLabel = UILabel()
        titleLabel.text = windowTitle
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addSubview(titleLabel)

        // Loading indicator (trailing position)
        loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            // Navigation bar
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 44),

            // Border view
            borderView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor),
            borderView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 0.5),

            // Close button (leading, per Apple HIG)
            closeButton.leadingAnchor.constraint(
                equalTo: navigationBar.leadingAnchor, constant: 16),
            closeButton.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor),

            // Title label (centered)
            titleLabel.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor),
            titleLabel.leadingAnchor.constraint(
                greaterThanOrEqualTo: closeButton.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: loadingIndicator.leadingAnchor, constant: -16),

            // Loading indicator (trailing)
            loadingIndicator.trailingAnchor.constraint(
                equalTo: navigationBar.trailingAnchor, constant: -16),
            loadingIndicator.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor),
        ])
    }

    private func setupWebView() {
        // Configure WebView with optimized settings
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []

        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.navigationDelegate = self

        // Improve rendering
        webView.isOpaque = false
        webView.backgroundColor = .systemBackground

        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupProgressIndicator() {
        // Modern progress bar
        progressView = UIProgressView(progressViewStyle: .bar)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .systemBlue
        progressView.trackTintColor = .clear
        progressView.alpha = 0
        view.addSubview(progressView)

        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2),
        ])

        // Observe loading progress
        webView.addObserver(
            self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }

    private func loadURL() {
        guard let urlToLoad = URL(string: url) else {
            showErrorState()
            return
        }

        var request = URLRequest(url: urlToLoad)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        webView.load(request)
    }

    private func showErrorState() {
        let errorLabel = UILabel()
        errorLabel.text = "Unable to load page"
        errorLabel.textColor = .secondaryLabel
        errorLabel.font = .systemFont(ofSize: 17, weight: .medium)
        errorLabel.textAlignment = .center
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorLabel)

        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    override func observeValue(
        forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == "estimatedProgress" {
            let progress = Float(webView.estimatedProgress)

            UIView.animate(withDuration: 0.2) {
                self.progressView.alpha = progress < 1.0 ? 1.0 : 0.0
                self.progressView.setProgress(progress, animated: true)
            }
        }
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }

    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
}

// MARK: - WKNavigationDelegate
extension NewViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingIndicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingIndicator.stopAnimating()
        print("Navigation failed: \(error.localizedDescription)")
    }

    func webView(
        _ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: Error
    ) {
        loadingIndicator.stopAnimating()
        showErrorState()
    }
}
