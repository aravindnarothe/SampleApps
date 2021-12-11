//
//  ItemDetailsViewNavigator.h
//  DemoClassifieds
//
//  Created by Aravind on 11/12/2021.
//

#import <UIKit/UIKit.h>

@class Item;
NS_ASSUME_NONNULL_BEGIN

@interface ItemDetailsViewNavigator : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNavController:(UINavigationController *)navController item:(Item *)item NS_DESIGNATED_INITIALIZER;

- (void)start;

@end

NS_ASSUME_NONNULL_END
