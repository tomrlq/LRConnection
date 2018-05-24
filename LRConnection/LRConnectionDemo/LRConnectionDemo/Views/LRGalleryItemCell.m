//
//  LRGalleryItemCell.m
//  LRConnectionDemo
//
//  Created by Ruan Lingqi on 23/05/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

#import "LRGalleryItemCell.h"
#import "LRGalleryItem.h"
#import "LRGalleryStore.h"

@interface LRGalleryItemCell ()
{
    __weak IBOutlet UIImageView *thumbnailView;
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
    
    thumbnailView.image = [UIImage imageNamed:@"placeholder"];
}

- (void)setGalleryItem:(LRGalleryItem *)galleryItem {
    captionLabel.text = galleryItem.caption;
    serialLabel.text = galleryItem.itemID;
    ownerLabel.text = galleryItem.owner;
    
    NSInteger tag = self.tag;
    [[LRGalleryStore sharedStore] fetchImageForGalleryItem:galleryItem completion:^(UIImage *image, NSError *error) {
        if (!error && tag == self.tag) {
            thumbnailView.image = image;
        }
    }];
}

@end
