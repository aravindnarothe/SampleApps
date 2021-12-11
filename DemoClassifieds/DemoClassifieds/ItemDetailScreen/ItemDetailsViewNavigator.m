//
//  ItemDetailsViewNavigator.m
//  DemoClassifieds
//
//  Created by Aravind on 11/12/2021.
//

#import "ItemDetailsViewNavigator.h"
#import "ItemDetailsViewController.h"
#import "ItemsDetailsViewModel.h"

@interface ItemDetailsViewNavigator ()

@property (nonatomic, weak) UINavigationController *navigationController;
@property (nonatomic, strong) Item *item;
@end

@implementation ItemDetailsViewNavigator

- (instancetype)initWithNavController:(UINavigationController *)navController item:(Item *)item {
    self = [super init];
    if (self) {
        _navigationController = navController;
        self.item = item;
    }
    return self;
}

- (void)start {
    if (self.navigationController == nil || self.item == nil) {
        return;
    }
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ItemDetailsViewController *itemDetailsScreen = [storyBoard instantiateViewControllerWithIdentifier:@"ItemDetailsViewController"];
    ItemsDetailsViewModel *viewModel = [[ItemsDetailsViewModel alloc] initWith:self.item];
    itemDetailsScreen.viewModel = viewModel;
    [self.navigationController pushViewController:itemDetailsScreen animated:YES];
}

@end
