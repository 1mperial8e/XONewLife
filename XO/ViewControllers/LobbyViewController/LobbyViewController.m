//
//  LobbyViewController.m
//  XO
//
//  Created by Stas Volskyi on 11/3/15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "LobbyViewController.h"
#import "LobbyTableViewCell.h"

// Services
#import "BLEService.h"

static NSString *const PeripheralKey = @"PeripheralKey";
static NSString *const DeviceNameKey = @"DeviceNameKey";

@interface LobbyViewController () <UITableViewDataSource, LobbyTableViewCellDelegate, BLEServiceDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (weak, nonatomic) GameManager *gameManager;

@end

@implementation LobbyViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gameManager = [GameManager sharedInstance];
    self.dataSource = [NSMutableArray array];
    
    [self setupTableView];
    [self createBLEService];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Private

- (void)setupTableView
{
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LobbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LobbyTableViewCell.ID];
    cell.delegate = self;
    [cell configureWithUserName:self.dataSource[indexPath.row][DeviceNameKey] andIndex:indexPath.row];
    return cell;
}

#pragma mark - LobbyTableViewCellDelegate

- (void)connectToUserAtIndex:(NSInteger)index
{
    
}

#pragma mark - BLE

- (void)createBLEService
{
    self.gameManager.managerService = [[BLEService alloc] initWithType:BLETypeManager];
    self.gameManager.peripheralService = [[BLEService alloc] initWithType:BLETypePeripheral];
    self.gameManager.managerService.delegate = self;
    self.gameManager.peripheralService.delegate = self;
}

#pragma mark - BLEServiceDelegate

- (void)BLEServiceDidReceiveData:(nullable NSData *)data peripheral:(nullable CBPeripheral *)peripheral service:(nonnull BLEService *)BLEService
{
    
}

- (void)BLEServiceDidDiscoverPeripheral:(nonnull CBPeripheral *)peripheral advertisementData:(nonnull NSDictionary<NSString *,id> *)advertisementData RSSI:(nonnull NSNumber *)RSSI
{
    NSString *deviceName = advertisementData[@"kCBAdvDataLocalName"];
    if (peripheral && deviceName) {
        NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"%@ LIKE %@", DeviceNameKey, deviceName];
        BOOL deviceExistsInList = [self.dataSource filteredArrayUsingPredicate:namePredicate].count > 0;
        if (!deviceExistsInList) {
            [self.dataSource addObject:@{PeripheralKey : peripheral,
                                         DeviceNameKey : deviceName}];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

@end
