//
//  PostOfficeViewCell.h
//  ILovepostcard
//
//  Created by 振东 何 on 12-6-16.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FD_IMAGE_PATH(file) [NSString stringWithFormat:@"%@/Documents/ScreenShot/%@",NSHomeDirectory(),file]

@interface PostOfficeViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *postCard;
@property (retain, nonatomic) IBOutlet UILabel *address;
@property (retain, nonatomic) IBOutlet UIImageView *paymentStatus;
@property (retain, nonatomic) IBOutlet UILabel *paymentDescribe;


+ (PostOfficeViewCell *)getInstance;

- (void)configCellWithIndex:(int)index 
                    address:(NSString *)address
              paymentStatus:(NSString *)paymentStatus;

@end
