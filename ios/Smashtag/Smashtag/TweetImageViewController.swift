//
//  TweetImageViewController.swift
//  Smashtag
//
//  Created by Tong Qiu on 8/18/17.
//  Copyright © 2017 Tong Qiu. All rights reserved.
//

import UIKit

class TweetImageViewController: UIViewController, UIScrollViewDelegate {
    
    var imageUrl: URL? {
        didSet {
            image = nil
            if view.window != nil { fetchImage() }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    // MARK: - Scroll view delegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: - Private implementation
    
    private var imageView = UIImageView()
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }
    
    private func fetchImage() {
        if let url = imageUrl {
            spinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContent = try? Data(contentsOf: url)
                if let imageData = urlContent, url == self?.imageUrl {
                    DispatchQueue.main.async {
                        self?.image = UIImage(data: imageData)
                        self?.setCorrectZoom()
                    }
                }
            }
        }
    }
    
    private func setCorrectZoom() {
        if let tabHeight = tabBarController?.tabBar.frame.height {
            let scrollHeight = scrollView.frame.height - 2 * tabHeight

            let horizontal = scrollView.frame.width / imageView.frame.width
            let vertical = scrollHeight / imageView.frame.height
            
            scrollView.minimumZoomScale = min(horizontal, vertical)
            scrollView.maximumZoomScale = 10
            scrollView.setZoomScale(max(horizontal, vertical), animated: false)
        }
    }
    
}
