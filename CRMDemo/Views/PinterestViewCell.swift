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
    
    var pin: Pins? {
        didSet {
            updateCell()
        }
    }
    var apiCaller: CustomRestManager = CustomRestManager.shared
    func updateCell() {
        
        if let pin = pin {
            if let cachedImg = self.apiCaller.ctCache.memoryCache.getCachedObjForKey(cacheKey: NSString(string: pin.imageUrls!.regular)) {
                imageFrame.image = UIImage(data: cachedImg)
            } else {
                apiCaller.makeRequest(toURL: URL(string: pin.imageUrls!.regular)!, withHttpMethod: CustomRestManager.HttpsMethods.get) { [weak self] (result) in
                    DispatchQueue.main.async {
                        if result.response?.httpStatusCode == 200 {
                            if let data = result.data {
                                self?.imageFrame.image = UIImage(data: data)
                            } else {
                                print("Error fetching images", result.error!)
                            }
                        }
                    }
                }
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }
    override func prepareForReuse() {
        //imageFrame.image = UIImage()
    }
}
