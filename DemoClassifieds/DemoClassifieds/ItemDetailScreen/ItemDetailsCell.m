//
//  ItemDetailsCell.m
//  DemoClassifieds
//
//  Created by Aravind on 11/12/2021.
//

#import "ItemDetailsCell.h"

@implementation ItemDetailsCell

- (void)setImage:(UIImage *)image {
    if (image == nil) {
        [self.spinner startAnimating];
        self.itemPicture.image = [UIImage imageNamed:@"placeholder"];
        return;
    }
    self.itemPicture.image = image;
    [self.spinner stopAnimating];
}

@end
