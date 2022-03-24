//
//  UIImageViewExtension.swift
//  MvvmWithClosure
//
//  Created by Yunus Icmen on 24.03.2022.
//

import UIKit

// MARK: - Extension for async image download
extension UIImageView {

    func setImage(with url: String?, completion: ((CGFloat)->())? = nil) {
        guard let urlString = url,
              let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                self.image = nil
                return
            }

            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                  let data = data else {
                      self.image = nil
                      return
                  }

            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.image = image
                self.clipsToBounds = true
                if completion != nil {
                    guard let imageWidth = image?.size.width,
                          let imageHeight = image?.size.height else { return }

                    if imageWidth != 0.0 && imageHeight != 0.0 {
                        let ratio = imageWidth / imageHeight
                        let scaledHeight = imageHeight * ratio
                        completion!(scaledHeight)
                    }
                }
            }
        }.resume()
    }
}
