//
//  Location.h
//  CoffeeShop
//
//  Created by Gary Coppeler on 2/4/13.
//  Copyright (c) 2013 Geecee Designs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *crossStreet;
@property (nonatomic, strong) NSString *postalCode;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSNumber *lat;
@property (nonatomic, strong) NSNumber *lng;
@property (nonatomic, strong) NSNumber *checkins;

@end
