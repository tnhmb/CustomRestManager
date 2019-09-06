//
//  PinterestViewCell.swift
//  CRMDemo
//
//  Created by Tariq Najib on 03/09/2019.
//  Copyright © 2019 Tariq Najib. All rights reserved.
//

import UIKit
import CustomRestManager

class PinterestViewCell: UICollectionViewCell {
    @IBOutlet weak var imageFrame: UIImageView!
    @IBOutlet weak var containerView: UIView!
    var service = Service.shared
    var pin: Pins? {
        didSet {
            updateCell()
        }
    }
    var apiCaller: CustomRestManager = CustomRestManager.shared
    func updateCell() {
        
        if let pin = pin {
            guard let imageURL = pin.imageUrls?.regular,
            let stringToURL = URL(string: imageURL)
            else { return }
            service.downloadImages(toURL: stringToURL) { (image) in
                self.imageFrame.image = image
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
