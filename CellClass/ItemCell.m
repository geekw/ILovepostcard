//
//  ItemCell.m
//  ILovepostcard
//
//  Created by wang piepie on 12-6-3.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "ItemCell.h"

@implementation ItemCell
@synthesize btn;
@synthesize titleLbl;
@synthesize heartNumLbl;
@synthesize whichListInt;

-(void)dealloc
{
    whichListInt = nil;
    [btn release];
    [titleLbl release];
    [heartNumLbl release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        return [[[NSBundle mainBundle] loadNibNamed:@"ItemCell" owner:nil options:nil] objectAtIndex:0]; 
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (ItemCell *)getInstance
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ItemCell" owner:nil options:nil] objectAtIndex:0]; 
}

- (void)configWithTitle:(NSString *)title 
               btnImage:(UIImage *)image
               heartNum:(NSString *)heartNum
               tagValue:(NSInteger)tagInt
            listInteger:(NSInteger)listInt
{
    self.titleLbl.text = [NSString stringWithFormat:@"%@",title];
    self.btn.tag = tagInt;
    [self.btn setBackgroundImage:image forState:UIControlStateNormal];
    self.heartNumLbl.text = [NSString stringWithFormat:@"%@",heartNum];
    self.whichListInt = [NSString stringWithFormat:@"%d",listInt];
    [self.btn addTarget:self 
                 action:@selector(goToActivityDetailView:) 
       forControlEvents:UIControlEventTouchUpInside];
}


-(void)goToActivityDetailView:(UIButton *)sender
{
    NSString *tagStr = [NSString stringWithFormat:@"%d",sender.tag];
    NSMutableDictionary *tmpDict = [[NSMutableDictionary dictionary] retain];
    [tmpDict setObject:tagStr forKey:@"tagStr"];
    [tmpDict setObject:self.whichListInt forKey:@"whichListInt"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goToActivityDetailView" object:tmpDict];
    [tmpDict release];
}

@end
