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
@synthesize authorizeBtn;

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
    self.authorizeBtn.tag = WEIBOBTNTAG;
    
    if (state) 
    {
        [self.authorizeBtn setImage:[UIImage imageNamed:@"authorize.png"] forState:UIControlStateNormal];
    }
    else 
    {
        [self.authorizeBtn setImage:[UIImage imageNamed:@"unauthorize.png"] forState:UIControlStateNormal];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [titleLbl release];
    [portraitImag release];
    [authorizeBtn release];

    [super dealloc];
}
@end
