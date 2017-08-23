//
//  ImageTableViewCell.swift
//  Smashtag
//
//  Created by Tong Qiu on 8/17/17.
//  Copyright © 2017 Tong Qiu. All rights reserved.
//

import UIKit
import Twitter

class ImageTableViewCell: UITableViewCell {

    var imageToDisplay: Twitter.MediaItem? { didSet { updateUI() } }
    
    @IBOutlet weak var displayImageView: UIImageView!
    
    private var requestUrl: URL?
    
    private func updateUI() {
        if let existingImage = imageToDisplay {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.requestUrl = existingImage.url
                let urlContents = try? Data(contentsOf: existingImage.url)
                
                if let imageData = urlContents, existingImage.url == self?.requestUrl {
                    DispatchQueue.main.async {
                        self?.displayImageView?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
}
