//
//  PhotoGalleryViewController.swift
//  LRConnectionExample(Swift)
//
//  Created by Ruan Lingqi on 26/05/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

import UIKit

class PhotoGalleryViewController: UITableViewController {
    
    var currentItems = [GalleryItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false

        self.tableView.tableFooterView = UIView()
        GalleryStore.shared.fetchRecentPhotos(success: { (galleryItems) in
            self.currentItems = galleryItems
            self.tableView.reloadData()
        }, failure: { (error) in
            print(error)
        })
    }
    

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let galleryItem = currentItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryItemCell", for: indexPath) as! GalleryItemCell
        cell.tag = indexPath.row
        cell.setGalleryItem(galleryItem)
        return cell
    }

}
