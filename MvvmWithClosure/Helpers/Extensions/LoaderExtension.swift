//
//  LoaderExtension.swift
//  MvvmWithClosure
//
//  Created by Yunus Icmen on 24.03.2022.
//

import UIKit

// MARK: - Loading
final class LoadingOverlay {

    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.frame = CGRect(x: .zero,
                            y: .zero,
                            width: 60.0,
                            height: 60.0)
        return view
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.style = .medium
        indicatorView.color = .red
        indicatorView.frame = CGRect(x: .zero,
                                     y: .zero,
                                     width: 40.0,
                                     height: 40.0)
        indicatorView.center = CGPoint(x: overlayView.bounds.width / 2,
                                       y: overlayView.bounds.height / 2)
        return indicatorView
    }()

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        return view
    }()

    static let shared = LoadingOverlay()

    init(){}

    func startLoader() {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first

        guard let window = keyWindow else { return }

        backgroundView.frame = window.frame
        backgroundView.addSubview(overlayView)

        overlayView.center = window.center
        overlayView.addSubview(activityIndicator)

        window.addSubview(backgroundView)
        activityIndicator.startAnimating()
    }

    func stopLoader() {
        activityIndicator.stopAnimating()
        backgroundView.removeFromSuperview()
    }
}
