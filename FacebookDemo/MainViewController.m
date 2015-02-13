//
//  MainViewController.m
//  FacebookDemo
//
//  Created by Timothy Lee on 10/22/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

#import "MainViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "StatusCell.h"
#import "PhotoCell.h"
#import "UIImageView+AFNetworking.h"

@interface MainViewController ()

- (void)reload;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) NSArray* posts;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self reload];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.rowHeight = UITableViewAutomaticDimension;
    self.mainTableView.estimatedRowHeight = 100;
    
        //prefer content width
    
    UIImage *rightButtonImage = [[UIImage imageNamed:@"rightButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:rightButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(onRightButton)];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(onRightButton)];
    
    //self.navigationController.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.rightBarButtonItem = rightButton;


    UINib *StatusCellNib = [UINib nibWithNibName:@"StatusCell" bundle:nil];
    [self.mainTableView registerNib:StatusCellNib forCellReuseIdentifier:@"StatusCellNib"];
    UINib *PhotoCellNib = [UINib nibWithNibName:@"PhotoCell" bundle:nil];
    [self.mainTableView registerNib:PhotoCellNib forCellReuseIdentifier:@"PhotoCellNib"];
}

- (void)onRightButton {
    NSLog(@"Tapped right button.");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *data = self.posts[indexPath.row];
    
    if ([self.posts[indexPath.row][@"type"] isEqualToString:@"photo"] && self.posts[indexPath.row][@"message"]) {
        PhotoCell *photoCell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCellNib"];
        photoCell.messageLabel.text = data[@"message"];
        photoCell.nameLabel.text = data[@"name"];
        NSURL *imgURL = [NSURL URLWithString:data[@"picture"]];
        [photoCell.imgView setImageWithURL:imgURL];
        return photoCell;
    } else if (self.posts[indexPath.row][@"message"]) {
        StatusCell *statusCell = [tableView dequeueReusableCellWithIdentifier:@"StatusCellNib"];
        statusCell.messageLabel.text = data[@"message"];
        statusCell.nameLabel.text = data[@"name"];
        return statusCell;
    } else {
        // skip
        UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"];
        return cell;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Private methods

- (void)reload {
    [FBRequestConnection startWithGraphPath:@"/me/home"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              self.posts = result[@"data"];
                              NSLog(@"result: %@", result);
                              [self.mainTableView reloadData];
                          }];
}

@end
