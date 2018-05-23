//
//  LRGalleryItemCell.m
//  LRConnectionDemo
//
//  Created by Ruan Lingqi on 23/05/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

#import "LRGalleryItemCell.h"
#import "LRGalleryItem.h"

@interface LRGalleryItemCell ()
{
    __weak IBOutlet UILabel *captionLabel;
    __weak IBOutlet UILabel *serialLabel;
    __weak IBOutlet UILabel *ownerLabel;
}
@end

@implementation LRGalleryItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
}

- (void)setGalleryItem:(LRGalleryItem *)galleryItem {
    captionLabel.text = galleryItem.caption;
    serialLabel.text = galleryItem.itemID;
    ownerLabel.text = galleryItem.owner;
}

@end
