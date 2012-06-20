//
//  WeiBoCell.h
//  ILovepostcard
//
//  Created by 振东 何 on 12-6-19.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WEIBOBTNTAG 1000

@interface WeiBoCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *portraitImag;
@property (retain, nonatomic) IBOutlet UILabel *titleLbl;
@property (retain, nonatomic) IBOutlet UIButton *authorizeBtn;


+ (WeiBoCell *)getInstance;
- (void)configCellWithImage:(UIImage *)image title:(NSString *)title state:(BOOL)state;

@end
