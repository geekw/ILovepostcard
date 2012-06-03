//
//  ItemCell.h
//  ILovepostcard
//
//  Created by wang piepie on 12-6-3.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemCell : UITableViewCell
{
    IBOutlet UILabel *title;
    IBOutlet UILabel *loveCount;
    IBOutlet UIImageView *imageView;
}

@property(nonatomic,retain)UILabel *title;
@property(nonatomic,retain)UILabel *loveCount;
@property(nonatomic,retain)UIImageView *imageView;



@end
