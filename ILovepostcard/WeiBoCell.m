//
//  WeiBoCell.m
//  ILovepostcard
//
//  Created by 振东 何 on 12-6-19.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "WeiBoCell.h"

@implementation WeiBoCell
@synthesize portraitImag;
@synthesize titleLbl;
@synthesize weiboSwitch;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (WeiBoCell *)getInstance{
    return [[[NSBundle mainBundle] loadNibNamed:@"WeiBoCell" owner:nil options:nil] objectAtIndex:0];
}

- (void)configCellWithImage:(UIImage *)image title:(NSString *)title state:(BOOL)state{
    self.portraitImag.image = image;
    self.titleLbl.text = title;
    self.weiboSwitch.on = state;
    self.weiboSwitch.tag = SWITCHTAG;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [titleLbl release];
    [portraitImag release];

    [weiboSwitch release];
    [super dealloc];
}
@end
