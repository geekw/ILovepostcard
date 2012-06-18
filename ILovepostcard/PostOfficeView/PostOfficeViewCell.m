//
//  PostOfficeViewCell.m
//  ILovepostcard
//
//  Created by 振东 何 on 12-6-16.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "PostOfficeViewCell.h"

@implementation PostOfficeViewCell
@synthesize postCard;
@synthesize address;
@synthesize paymentStatus;
@synthesize paymentDescribe;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (PostOfficeViewCell *)getInstance
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PostOfficeViewCell" owner:nil options:nil] objectAtIndex:0];
}

- (void)configCellWithIndex:(int)index 
                    address:(NSString *)_address
              paymentStatus:(NSString *)_paymentStatus
{
    NSString *picSaveStr = [NSString stringWithFormat:@"frontPic%d.png",index];//定义图片文件名
    NSString *str = [NSString stringWithFormat:@"%@",FD_IMAGE_PATH(picSaveStr)];
    self.postCard.image = [UIImage imageWithContentsOfFile:str];
    self.address.text = _address;
    
    if (_paymentStatus.intValue == 1)
    {
        self.paymentStatus.image = [UIImage imageNamed:@"paymentView3.png"];
    }
    else
    {
        self.paymentStatus.image = [UIImage imageNamed:@"paymentView2.png"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [postCard release];
    [address release];
    [paymentStatus release];
    [paymentDescribe release];
    
    [super dealloc];
}
@end
