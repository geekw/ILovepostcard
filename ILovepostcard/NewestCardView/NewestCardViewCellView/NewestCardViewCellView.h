//
//  NewestCardViewCellView.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-6-18.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewestCardViewCellView : UITableViewCell

@property (retain, nonatomic) IBOutlet UIButton *btn1;

@property (retain, nonatomic) IBOutlet UILabel *label1;

@property (retain, nonatomic) IBOutlet UIButton *btn2;

@property (retain, nonatomic) IBOutlet UILabel *label2;


+ (NewestCardViewCellView *)getInstance;

- (void)configCellWithImgUrl:(NSString *)urlStr 
                    address:(NSString *)address
                    tagValue:(NSString *)tag;


@end
