//
//  PinterestViewController.swift
//  CRMDemo
//
//  Created by Tariq Najib on 03/09/2019.
//  Copyright © 2019 Tariq Najib. All rights reserved.
//

import UIKit
import CustomRestManager

private let reuseIdentifier = "PinterestCell"

class PinterestViewController: UICollectionViewController {
    
    var pins = [Pins]()
    var isGetResponse = true
    var page = 1
    let service = Service.shared
    var apiCaller: CustomRestManager?
    let refreshControl = UIRefreshControl()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        apiCaller = CustomRestManager.shared
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        loadPins()
        collectionView.refreshControl = refreshControl
        collectionView?.contentInset = UIEdgeInsets(top: 23, left: 10, bottom: 10, right: 10)
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
    }
    func loadMorePins(page: Int) {
        service.loadMorePins(page: page) { (pins) in
            self.pins = pins
            self.collectionView.reloadData()
        }
    }
    func loadPins() {
        service.loadPins { (pins) in
            self.pins = pins
            self.collectionView.reloadData()
        }
    }
    @objc func pullToRefresh(_ sender: Any) {
        loadPins()
        refreshControl.endRefreshing()
    }
}
extension PinterestViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pins.count
    }
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == pins.count - 1 && isGetResponse {
            page = page + 1
            loadMorePins(page: page)
        }
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if let pinterestCell = cell as? PinterestViewCell {
            pinterestCell.pin = pins[indexPath.item]
        }
        return cell
    }
    
}

extension PinterestViewController : PinterestLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        return CGFloat(pins[indexPath.item].height!/6)
        //return 200
    }
    
}
