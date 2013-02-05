//
//  Venue.h
//  CoffeeShop
//
//  Created by Gary Coppeler on 2/4/13.
//  Copyright (c) 2013 Geecee Designs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
#import "Stats.h"

@interface Venue : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) Location *location;
@property (strong, nonatomic) Stats *stats;

@end
