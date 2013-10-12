//
//  TJLViewController.m
//  TJLQueue
//
//  Created by Terry Lewis II on 10/12/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import "TJLViewController.h"
#import "TJLQueue.h"

@interface TJLViewController () <UITableViewDataSource>
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) TJLQueue *queue;
@property(strong, nonatomic) NSArray *datasource;

@end

@implementation TJLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.queue = [TJLQueue new];
    for(NSUInteger i = 0; i < 20; i++) {
        [self.queue addObject:@(i)];
    }
    self.datasource = [self.queue toArray];
    self.tableView.dataSource = self;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.queue.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.datasource[indexPath.row]];

    return cell;
}


@end
