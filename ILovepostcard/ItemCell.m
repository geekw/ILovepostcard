//
//  ItemCell.m
//  ILovepostcard
//
//  Created by wang piepie on 12-6-3.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "ItemCell.h"

@implementation ItemCell

@synthesize title,imgButton,loveCount;

-(void)dealloc
{
    [super dealloc];
    title = nil;[title release];
    imgButton = nil;[imgButton release];
    loveCount = nil;[loveCount release];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
