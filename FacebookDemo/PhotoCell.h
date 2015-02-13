//
//  PhotoCell.h
//  FacebookDemo
//
//  Created by Sean Dy on 2/12/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
