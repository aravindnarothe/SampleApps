//
//  ItemDetailsViewController.h
//  DemoClassifieds
//
//  Created by Aravind on 11/12/2021.
//

#import <UIKit/UIKit.h>

@class ItemsDetailsViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface ItemDetailsViewController : UIViewController

@property (nonatomic, weak) IBOutlet UICollectionView *imageGallery;
@property (nonatomic, weak) IBOutlet UILabel *price;
@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *date;
@property (nonatomic, strong) ItemsDetailsViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
