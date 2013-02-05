//
//  VenueCell.h
//  CoffeeShop
//
//  Created by Gary Coppeler on 2/4/13.
//  Copyright (c) 2013 Geecee Designs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VenueCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *checkinsLabel;

@end
