//
//  ChooseAddressView.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-31.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "ChooseAddressView.h"

@interface ChooseAddressView ()

@end

@implementation ChooseAddressView

@synthesize postcodeTxtView;
@synthesize adressTextView,nameTextView;
@synthesize cancelBtn;
@synthesize confirmBtn;
@synthesize provinceBtn,cityBtn,countyBtn;

#pragma mark - goBack - 返回按钮
-(IBAction)goBack
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - View lifecycle - 系统函数
- (void)dealloc 
{
    
    [provinceArray release];
    [cityArray release];
    [countyArray release];
    [postcodeArray release];
    [dataArray release];
    [currentTxtView release];
    [adressTextView release];
    [nameTextView release];
    [provinceBtn release];
    [cityBtn release];
    [countyBtn release];
    [cancelBtn release];
    [confirmBtn release];
    [postcodeTxtView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self initData];
        
//        provinceList = [[SeachList alloc] initWithStyle:UITableViewStylePlain];
//        provinceList.delegate = self;
//        [provinceList.view setFrame:CGRectMake(160, 240, 152, 88)];
//        provinceList.tableView.hidden = YES;
//        [provinceList setTagList:PROVINCE_LIST];
//        [self.view addSubview:provinceList.view];
//        
//        cityList = [[SeachList alloc] initWithStyle:UITableViewStylePlain];
//        cityList.delegate = self;
//        [cityList.view setFrame:CGRectMake(160, 240, 152, 88)];
//        cityList.tableView.hidden = YES;
//        [cityList setTagList:CITY_LIST];
//
//        [self.view addSubview:cityList.view];
//        
//        countyList = [[SeachList alloc] initWithStyle:UITableViewStylePlain];
//        countyList.delegate = self;
//        [countyList.view setFrame:CGRectMake(160, 240, 52, 31)];
//        countyList.tableView.hidden = YES;
//        [countyList setTagList:COUNTY_LIST];
//
//        [self.view addSubview:countyList.view];
//        
//        postcodeList = [[SeachList alloc] initWithStyle:UITableViewStylePlain];
//        postcodeList.delegate = self;
//        [postcodeList.view setFrame:CGRectMake(160, 240, 52, 31)];
//        postcodeList.tableView.hidden = YES;
//        [postcodeList setTagList:POSTCODE_LIST];
//
//        [self.view addSubview:postcodeList.view];

    }
    return self;
}

- (void)initData
{
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSLog(@"%@",delegate.dataArray);
    dataArray = [[NSMutableArray alloc] initWithArray:delegate.dataArray]; 
    NSLog(@"%@",dataArray);

    if (provinceArray != nil)
    {
        [provinceArray removeAllObjects];
    }
    
    if (cityArray != nil)
    {
        [cityArray removeAllObjects];
    }
    
    if (countyArray != nil)
    {
        [countyArray removeAllObjects];
    }
    
    if (postcodeArray != nil)
    {
        [postcodeArray removeAllObjects];
    }
    
        
    provinceArray = [[NSMutableArray alloc] init];
    cityArray = [[NSMutableArray alloc] init];
    countyArray = [[NSMutableArray alloc] init];
    postcodeArray = [[NSMutableArray alloc] init];
    
    
    
    NSMutableSet *provinceSet = [NSMutableSet set];
    NSMutableSet *cityceSet = [NSMutableSet set];
    NSMutableSet *countySet = [NSMutableSet set];
    NSMutableSet *postcodeSet = [NSMutableSet set];

    for (int i = 0; i < [dataArray count]; i++)
    {
        DataItem *di = [dataArray objectAtIndex:i];
        if (di.province == nil)
        {
            di.province = [NSString stringWithFormat:@""];
        }
        [provinceSet addObject:di.province];
        [cityceSet addObject:di.city];
        [countySet addObject:di.county];
        [postcodeSet addObject:di.postcode];
        [di release];
    }
    
    for (NSString *provinceStr in provinceSet) 
    {
        [provinceArray addObject:provinceStr];
    }
    
    for (NSString *cityStr in cityceSet) 
    {
        [cityArray addObject:cityceSet];
    }
    
    for (NSString *countyStr in countySet) 
    {
        [countyArray addObject:countyStr];
    }
    
    for (NSString *postcodeStr in postcodeSet) 
    {
        [postcodeArray addObject:postcodeStr];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performSelector:@selector(getCustomFont)];//寻找字体
    [self.adressTextView setFont:[UIFont fontWithName:@"FZJLJW--GB1-0" size:25]];
}

- (void)viewDidUnload
{
    [self setAdressTextView:nil];
    [self setCancelBtn:nil];
    [self setConfirmBtn:nil];
    [self setPostcodeTxtView:nil];
    [super viewDidUnload];
}


#pragma mark - Picker

- (void)provinceWasSelected:(NSNumber *)selectedIndex element:(id)element
{
    NSInteger i = [selectedIndex intValue];
    [provinceBtn setTitle:[NSString stringWithString:[provinceArray objectAtIndex:i]] forState:UIControlStateNormal];

}

- (void)cityWasSelected:(NSNumber *)selectedIndex element:(id)element
{
    NSInteger i = [selectedIndex intValue];

    [cityBtn setTitle:[NSString stringWithString:[cityArray objectAtIndex:i]] forState:UIControlStateNormal];
}

- (void)countyWasSelected:(NSNumber *)selectedIndex element:(id)element
{
    NSInteger i = [selectedIndex intValue];
    
    [countyBtn setTitle:[NSString stringWithString:[countyArray objectAtIndex:i]] forState:UIControlStateNormal];
    
    
}

- (void)actionPickerCancelled:(id)sender 
{
    
}

#pragma mark - TextView
- (void)textViewDidBeginEditing:(UITextView *)textView
{    
    if (textView == postcodeTxtView)
    {
        CGRect rect = CGRectMake(0.0f, -200.0f, self.view.frame.size.width, self.view.frame.size.height);
        self.view.frame = rect;
        moveheight = -200;
    }
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (moveheight == -200)
    {
        CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        self.view.frame = rect;
        moveheight = 0;
    }
}

- (IBAction)backgroundTap:(id)sender
{    
    [adressTextView resignFirstResponder];
    [postcodeTxtView resignFirstResponder];
    [nameTextView resignFirstResponder];
    
    if (moveheight == -200)
    {
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];    
        CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        self.view.frame = rect;
        [UIView commitAnimations];
        moveheight = 0;
    }
}



#pragma mark -
- (IBAction)clickedProvince:(id)sender
{
    if (provincePicker != nil)
    {
        [provincePicker release];
    }

    provincePicker = [[ActionSheetStringPicker alloc] initWithTitle:@"省" rows:provinceArray initialSelection:0 target:self successAction:@selector(provinceWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
    provincePicker.hideCancel = YES;
    [provincePicker showActionSheetPicker:CGRectMake(0, 0, 320, 240)];

//    [provinceList updateData:provinceArray];
//    
//    provinceList.tableView.hidden = NO;
//    [self.view bringSubviewToFront:provinceList.tableView];
}

- (IBAction)clickedCity:(id)sender
{
    if (cityPicker != nil)
    {
        [cityPicker release];
    }
    
    if (provinceBtn.titleLabel.text != nil && [provinceBtn.titleLabel.text isEqualToString:@""] == NO)
    {
        [cityArray removeAllObjects];
        NSMutableSet *provinceSet = [NSMutableSet set];
        
        for (int i = 0; i < [dataArray count]; i++)
        {
            DataItem *di = [dataArray objectAtIndex:i];
            if ([di.province isEqualToString:provinceBtn.titleLabel.text])
            {
                [provinceSet addObject:di.city];
                
            }
        }
        
        for (NSString *provincestring in provinceSet) 
        {
            [cityArray addObject:provincestring];
        }
    
        cityPicker = [[ActionSheetStringPicker alloc] initWithTitle:@"省" rows:cityArray initialSelection:0 target:self successAction:@selector(cityWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
        cityPicker.hideCancel = YES;
        [cityPicker showActionSheetPicker:CGRectMake(0, 0, 320, 240)];
    
    }
    
//    
//    [cityList updateData:cityArray];
//    
//    cityList.tableView.hidden = NO;
//    [self.view bringSubviewToFront:cityList.tableView];

}

- (IBAction)clickedCounty:(id)sender
{
    if (countPicker != nil)
    {
        [countPicker release];
    }
    if (cityBtn.titleLabel.text != nil && [cityBtn.titleLabel.text isEqualToString:@""] == NO)
    {
        [countyArray removeAllObjects];
        NSMutableSet *provinceSet = [NSMutableSet set];
        
        for (int i = 0; i < [dataArray count]; i++)
        {
            DataItem *di = [dataArray objectAtIndex:i];
            if ([di.city isEqualToString:cityBtn.titleLabel.text])
            {
                [provinceSet addObject:di.county];
                
            }
        }
        
        for (NSString *provincestring in provinceSet) 
        {
            [countyArray addObject:provincestring];
        }
        
        countPicker = [[ActionSheetStringPicker alloc] initWithTitle:@"区县" rows:countyArray initialSelection:0 target:self successAction:@selector(countyWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
        countPicker.hideCancel = YES;
        [countPicker showActionSheetPicker:CGRectMake(0, 0, 320, 240)];
        
    }
    

//    [countyList updateData:countyArray];
//    
//    countyList.tableView.hidden = NO;
//    [self.view bringSubviewToFront:countyList.tableView];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark PassValue protocol
- (void)passValue:(NSString *)value
{

}

- (void)selected:(NSNumber *)index displayLabel:(NSString *)v
{
    NSInteger i = [index intValue];
    switch (i)
    {
        case PROVINCE_LIST:
        {
        }
            break;
        case CITY_LIST:
        {
        }
            break;
        case COUNTY_LIST:
        {
        }
            break;
        default:
            break;
    }


}

-(void)getCustomFont
{
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
        [fontNames release];
    }
    [familyNames release];
}




@end
