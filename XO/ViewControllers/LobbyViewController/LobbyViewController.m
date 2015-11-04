//
//  LobbyViewController.m
//  XO
//
//  Created by Stas Volskyi on 11/3/15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

// ViewControllers
#import "LobbyViewController.h"
#import "GameViewController.h"

// Views
#import "LobbyTableViewCell.h"

// Services
#import "BLEService.h"

static NSString *const PeripheralKey = @"PeripheralKey";
static NSString *const DeviceNameKey = @"DeviceNameKey";

static NSString *const LobbyToGameSeque = @"LobbyToGame";

@interface LobbyViewController () <UITableViewDataSource, LobbyTableViewCellDelegate, BLEServiceDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *searchingLabel;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (weak, nonatomic) GameManager *gameManager;
@property (strong, nonatomic) NSTimer *searchTimer;

@property (assign, nonatomic) NSInteger indexToConnect;
@property (assign, nonatomic) NSInteger searchingCounter;

@end

@implementation LobbyViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gameManager = [GameManager sharedInstance];
    self.dataSource = [NSMutableArray array];
    self.indexToConnect = NSNotFound;
    self.searchingCounter = -1;
    self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.9 target:self selector:@selector(updateTimerLabel:) userInfo:nil repeats:YES];
    [self.searchTimer fire];
    
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

- (void)updateTimerLabel:(NSTimer *)timer
{
    self.searchingCounter++;
    if (self.searchingCounter == 4) {
        self.searchingCounter = 0;
    }
    NSString *text = NSLocalizedString(@"LobbyViewController.searching", nil);
    for (int i = 0; i < self.searchingCounter; i++) {
        text = [text stringByAppendingString:@"."];
    }
    self.searchingLabel.text = text;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:LobbyToGameSeque]) {
        GameViewController *gameVC = (GameViewController *)segue.destinationViewController;
        gameVC.gameMode = GameModeOnline;
        gameVC.userName = [[UIDevice currentDevice] name];
        if (sender && [sender isKindOfClass:[NSString class]]) {
            gameVC.opponentName = sender;
            gameVC.isHost = NO;
        } else {
            gameVC.opponentName = self.dataSource[self.indexToConnect][DeviceNameKey];
            gameVC.isHost = YES;
        }
        self.indexToConnect = NSNotFound;
    }
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
    CBPeripheral *peripheral = self.dataSource[index][PeripheralKey];
    NSParameterAssert(peripheral);
    self.indexToConnect = index;
    [self.gameManager.managerService connectToPerephiral:peripheral];
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

- (void)BLEServiceDidDiscoverPeripheral:(nonnull CBPeripheral *)peripheral advertisementData:(nonnull NSDictionary<NSString *,id> *)advertisementData RSSI:(nonnull NSNumber *)RSSI
{
    NSString *deviceName = advertisementData[@"kCBAdvDataLocalName"];
    BOOL isConactable = [advertisementData[@"kCBAdvDataIsConnectable"] boolValue];
    if (peripheral && deviceName && isConactable) {
        NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"SELF.%@ LIKE %@", DeviceNameKey, deviceName];
        BOOL deviceExistsInList = [self.dataSource filteredArrayUsingPredicate:namePredicate].count > 0;
        if (!deviceExistsInList) {
            [self.dataSource addObject:@{PeripheralKey : peripheral,
                                         DeviceNameKey : deviceName}];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

- (void)BLEServiceDidConnect:(CBPeripheral *)peripheral
{
    DLog(@"connected");
}

- (void)BLEServiceDidDiscoveredServiceForPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSString *text = [NSString stringWithFormat:@"connected;%@", [UIDevice currentDevice].name];
    [self.gameManager.managerService sendData:[text dataUsingEncoding:NSUTF8StringEncoding]];
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf performSegueWithIdentifier:LobbyToGameSeque sender:nil];
    });
}

- (void)BLEServiceDidFailWithError:(NSError *)error peripheral:(CBPeripheral *)peripheral
{
    DLog(@"%@", error);
    if (self.indexToConnect != NSNotFound) {
        [self.dataSource removeObjectAtIndex:self.indexToConnect];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        self.indexToConnect = NSNotFound;
    }
}

- (void)BLEServiceDidReceiveData:(NSData *)data peripheral:(CBPeripheral *)peripheral service:(BLEService *)BLEService
{
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *components = [text componentsSeparatedByString:@";"];
    if (components.count == 2) {
        [self performSegueWithIdentifier:LobbyToGameSeque sender:components.lastObject];
    }
}

@end
