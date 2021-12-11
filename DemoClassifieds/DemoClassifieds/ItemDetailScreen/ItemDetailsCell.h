//
//  ItemDetailsCell.h
//  DemoClassifieds
//
//  Created by Aravind on 11/12/2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ItemDetailsCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *itemPicture;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;

- (void)setImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
