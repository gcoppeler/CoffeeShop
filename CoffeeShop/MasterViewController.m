//
//  MasterViewController.m
//  CoffeeShop
//
//  Created by Gary Coppeler on 2/4/13.
//  Copyright (c) 2013 Geecee Designs. All rights reserved.
//

#import "MasterViewController.h"
#import <RestKit/RestKit.h>
#import "Venue.h"
#import "VenueCell.h"

// #import "Location.h"

#define kCLIENTID "D2CP330DRT1YZXUEYL5HIZP0CU5CZTQR3LZ1SLFNWNNJOHAT	"
#define kCLIENTSECRET "CGKN3UC03GDWQYSLNZNEJKE4OISOULUIP1MOXJAZEZSAS2VK"

@interface MasterViewController () {
    NSMutableArray *_objects;
    NSArray *cafeArray;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Make left button "Edit"
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    // Make right button "+"	
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
	
    // FourSquare base API URL
    NSURL *baseURL = [NSURL URLWithString:@"https://api.foursquare.com/v2"];

    // AFNetworking HTTP client object setup
    AFHTTPClient * client = [AFHTTPClient clientWithBaseURL:baseURL];
    
    // Set AFHTTPClient Default Header to Accept RKMIMETypeJSON
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    
    // Create an RKObjectManager object and initialize it with our FourSquare API URL
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // Define the mapping between returned JSON data and our data model class (just "name" for now)
    RKObjectMapping *venueMapping = [RKObjectMapping mappingForClass:[Venue class]];
    [venueMapping addAttributeMappingsFromDictionary:@{@"name" : @"name"}];
    
    // Define the location mapping relationships
    RKObjectMapping *locationMapping = [RKObjectMapping mappingForClass:[Location class]];
    [locationMapping addAttributeMappingsFromDictionary:@{ @"address": @"address", @"city": @"city", @"country": @"country", @"crossStreet": @"crossStreet", @"postalCode": @"postalCode", @"state": @"state", @"distance": @"distance", @"lat": @"lat", @"lng": @"lng"}];
    
    RKObjectMapping *statsMapping = [RKObjectMapping mappingForClass:[Stats class]];
    [statsMapping addAttributeMappingsFromDictionary:@{ @"checkinsCount" : @"checkins", @"tipCount" : @"tips", @"usersCount" : @"users"}];
    
    /*
    [venueMapping mapRelationship:@"location" withMapping:locationMapping];
    [objectManager.mappingProvider setMapping:locationMapping forKeyPath:@"location"]; 
     */
    
    
    // Add the location mapping relationships to the main venueMapping object
    [venueMapping addPropertyMapping:
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"location" toKeyPath:@"location"
                                                  withMapping:locationMapping]];
    
    // Add the statistics mapping relationships to the main venueMapping object
    [venueMapping addPropertyMapping:
     [RKRelationshipMapping relationshipMappingFromKeyPath:@"stats" toKeyPath:@"stats"
                                               withMapping:statsMapping]];
    
    // Set up the RKResponseDescriptor to look for "response.venues" in JSON
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:venueMapping
                                                                                        pathPattern:nil
                                                                                            keyPath:@"response.venues"
                                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    // Add the responseDescriptor to the objectManager
    [objectManager addResponseDescriptor:responseDescriptor];
    
    // Set up our latitude / longitude
    NSString *latLon = @"39.110000,-77.305298";
    
    // Our FourSquare clientID and clientSecret
    NSString *clientID = [NSString stringWithUTF8String:kCLIENTID];
    NSString *clientSecret = [NSString stringWithUTF8String:kCLIENTSECRET];
    
    // Our query parameters
    NSDictionary *queryParams;
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:latLon, @"ll", clientID, @"client_id", clientSecret, @"client_secret", @"coffee", @"query", @"20120602", @"v", nil];
    
    [objectManager getObjectsAtPath:@"https://api.foursquare.com/v2/venues/search"
                         parameters:queryParams
                            success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
     {
         //NSLog(@"success: mappings: %@", mappingResult);
         NSArray *result = [mappingResult array];
         cafeArray = [mappingResult array];
         for (Venue *item in result)
         {
             NSLog(@"name=%@",item.name);
             NSLog(@"name=%@",item.location.distance);
         }
         [self.tableView reloadData];
    }
        failure:^(RKObjectRequestOperation * operaton, NSError * error)
     {
         NSLog (@"failure: operation: %@ \n\nerror: %@", operaton, error);
     }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cafeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VenueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VenueCell"];
    /*
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDate *object = [_objects objectAtIndex:indexPath.row];
     cell.textLabel.text = [object description];
    */
    
    Venue *venueObject = [cafeArray objectAtIndex: indexPath.row];
    
    /*
    cell.textLabel.text = [venueObject.name length] > 24 ? [venueObject.name substringToIndex:24] : venueObject.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0fm", [venueObject.location.distance floatValue]];
    */
    
    // Set the nameLabel
    cell.nameLabel.text = [venueObject.name length] > 24 ? [venueObject.name substringToIndex:24] : venueObject.name;
    
    //Set the distanceLabel
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.0fm", [venueObject.location.distance floatValue]];
    
    //Set the checkinsLabel
    cell.checkinsLabel.text = [NSString stringWithFormat:@"%d checkins", [venueObject.stats.checkins intValue]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath  
 {  
 // Return NO if you do not want the item to be re-orderable.  
 return YES;  
 }  
 */  

@end