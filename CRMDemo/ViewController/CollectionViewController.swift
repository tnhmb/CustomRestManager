//
//  CollectionViewController.swift
//  CRMDemo
//
//  Created by Tariq Najib on 03/09/2019.
//  Copyright © 2019 Tariq Najib. All rights reserved.
//

import UIKit
import CustomRestManager

private let reuseIdentifier = "PinterestCell"

class CollectionViewController: UICollectionViewController {
    let mainURL = URL(string: "http://pastebin.com/raw/wgkJgazE")
    var pins = [Pins]()
    var apiCaller: CustomRestManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        apiCaller = CustomRestManager.shared
        loadPins()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        

        // Do any additional setup after loading the view.
    }
    func loadPins() {
        let getMethod = CustomRestManager.HttpsMethods.get
        apiCaller?.makeRequest(toURL: mainURL!, withHttpMethod: getMethod, completion: { [weak self] (results) in
            print("getting data...")
            DispatchQueue.main.async {
                do {
                    if let data = results.data {
                        let decoder = JSONDecoder()
                        let decodedPins = try decoder.decode([Pins].self, from: data)
                        self?.pins = decodedPins
                        
                        
                        self?.collectionView.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("pins count \(pins.count)")
        return pins.count
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }



    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        if let pinterestCell = cell as? PinterestViewCell {
            
            print("data... \(indexPath.item) ", pins[indexPath.item].height)
            
            pinterestCell.pin = pins[indexPath.item]
            pinterestCell.imageFrame.image = UIImage(named: "img")!
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
