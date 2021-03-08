//
//  DownloadImage.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 01/03/2021.
//  Copyright © 2021 Zakariya Mohummed. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func downloaded(from urlString: String, contentMode mode: UIView.ContentMode = .scaleAspectFit)  {
        if let url  = URL(string: urlString) {
            self.kf.indicatorType = .activity
            self.kf.setImage(
                with: url,
                options: [
                    .cacheOriginalImage,
                    .forceTransition,
                    .onFailureImage(KFCrossPlatformImage(named: "No Image")),
                    .scaleFactor(UIScreen.main.scale),
                ])
        }

    }
}
