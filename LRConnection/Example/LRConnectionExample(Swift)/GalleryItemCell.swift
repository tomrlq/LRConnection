//
//  GalleryItemCell.swift
//  LRConnectionExample(Swift)
//
//  Created by Ruan Lingqi on 26/05/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

import UIKit

class GalleryItemCell: UITableViewCell {

    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var serialLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnailView.image = #imageLiteral(resourceName: "placeholder")
    }

    func setGalleryItem(_ galleryItem: GalleryItem) {
        captionLabel.text = galleryItem.caption
        serialLabel.text = galleryItem.itemID
        ownerLabel.text = galleryItem.owner
        
        let tag = self.tag
        GalleryStore.shared.fetchImage(for: galleryItem) { (imageResult) in
            if case let .success(image) = imageResult {
                if tag == self.tag {
                    self.thumbnailView.image = image
                }
            }
        }
    }
    
}
