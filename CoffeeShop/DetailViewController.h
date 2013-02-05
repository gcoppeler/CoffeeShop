//
//  DetailViewController.h
//  CoffeeShop
//
//  Created by Gary Coppeler on 2/4/13.
//  Copyright (c) 2013 Geecee Designs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
