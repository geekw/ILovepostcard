//
//  ChooseAddressView.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-31.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "ChooseAddressView.h"
#import "PromptView.h"

@interface ChooseAddressView ()

@end

@implementation ChooseAddressView

@synthesize postcodeTxtView;
@synthesize adressTextView,nameTextView;
@synthesize detailTxView;
@synthesize cancelBtn;
@synthesize confirmBtn;
@synthesize provinceBtn,cityBtn,countyBtn;
@synthesize addressStr;
@synthesize streetAddress;
@synthesize addressScrollView;
@synthesize senderNameTextView;
@synthesize provinceBtn_Sender;
@synthesize cityBtn_Sender;
@synthesize countryBtn_Sender;
@synthesize postcodeTextView_Sender;
@synthesize detailTextView_Sender;
@synthesize streetAddress_Sender;

#pragma mark - goBack - 返回按钮
-(IBAction)goBack:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle - 系统函数
- (void)dealloc 
{
    addressStr = nil;
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
    [detailTxView release];
    [streetAddress release];
    [addressScrollView release];
    [senderNameTextView release];
    [provinceBtn_Sender release];
    [cityBtn_Sender release];
    [countryBtn_Sender release];
    [postcodeTextView_Sender release];
    [detailTextView_Sender release];
    [streetAddress_Sender release];
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
    dataArray = [[NSMutableArray alloc] initWithArray:delegate.dataArray]; 

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
    cityArray   = [[NSMutableArray alloc] init];
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
//    [self performSelector:@selector(getCustomFont)];//寻找字体
//    [self.adressTextView setFont:[UIFont fontWithName:@"FZJLJW--GB1-0" size:25]];
    self.addressStr = nil;    
    self.addressScrollView.contentSize = CGSizeMake(320, 1000);
    self.addressScrollView.bounces = YES;
    self.addressScrollView.scrollEnabled = YES;
    self.addressScrollView.delegate = self;
    
    bool fromBack = [[NSUserDefaults standardUserDefaults] boolForKey:@"From_Back"];
    
    if (fromBack == YES)
    {
        self.addressScrollView.frame = CGRectMake(0, 0, 320, 700);
    }
    else
    {
        self.addressScrollView.frame = CGRectMake(0, -110, 320, 700);
        self.adressTextView.backgroundColor = [UIColor grayColor];
        self.adressTextView.userInteractionEnabled = NO;
    }
}

- (void)viewDidUnload
{
    [self setAdressTextView:nil];
    [self setCancelBtn:nil];
    [self setConfirmBtn:nil];
    [self setPostcodeTxtView:nil];
    [self setDetailTxView:nil];
    [self setStreetAddress:nil];
    [self setAddressScrollView:nil];
    [self setSenderNameTextView:nil];
    [self setProvinceBtn_Sender:nil];
    [self setCityBtn_Sender:nil];
    [self setCountryBtn_Sender:nil];
    [self setPostcodeTextView_Sender:nil];
    [self setDetailTextView_Sender:nil];
    [self setStreetAddress_Sender:nil];
    [super viewDidUnload];
}


#pragma mark - Picker

- (void)provinceWasSelected:(NSNumber *)selectedIndex 
                    element:(id)element
{
    //Todo
    // Clear city and county set

    NSInteger i = [selectedIndex intValue];
    
    provinceSelectedStr = nil;
    provinceSelectedStr = [NSString stringWithString:[provinceArray objectAtIndex:i]];
    
    [provinceBtn setTitle:[NSString stringWithString:provinceSelectedStr]
                 forState:UIControlStateNormal];

    [cityBtn setTitle:[NSString stringWithString:@"市"] forState:UIControlStateNormal];
    [countyBtn setTitle:[NSString stringWithString:@"区县"] forState:UIControlStateNormal];
    
    citySelectedStr = nil;
    countySelectedStr = nil;
    
    postcodeSelectedStr = nil;
    
    postcodeTxtView.text = nil;
    
    detailTxView.text = provinceSelectedStr;
    self.addressStr = [NSString stringWithFormat:@"%@~",provinceSelectedStr];
    
    //Todo
    //Query and refresh set
    [cityArray removeAllObjects];
    
    NSMutableSet *set = [NSMutableSet set];
    for (int i = 0; i < [dataArray count]; i++)
    {
        DataItem *di = [dataArray objectAtIndex:i];
        if ([di.province isEqualToString:provinceBtn.titleLabel.text])
        {
            [set addObject:di.city];
        }
    } 
    
    for (NSString *cityString in set) 
    {
        [cityArray addObject:cityString];
    }
}

- (void)cityWasSelected:(NSNumber *)selectedIndex element:(id)element
{
    NSInteger i = [selectedIndex intValue];

    citySelectedStr = [NSString stringWithString:[cityArray objectAtIndex:i]];
    
    [cityBtn setTitle:[NSString stringWithString:citySelectedStr]
             forState:UIControlStateNormal];
    
    [countyBtn setTitle:[NSString stringWithString:@"区县"]
               forState:UIControlStateNormal];
    
    detailTxView.text = [detailTxView.text stringByAppendingString:citySelectedStr];
    
    self.addressStr = [self.addressStr stringByAppendingFormat:@"%@~",citySelectedStr];

    [countyArray removeAllObjects];
    NSMutableSet *set = [NSMutableSet set];
    
    for (int i = 0; i < [dataArray count]; i++)
    {
        DataItem *di = [dataArray objectAtIndex:i];
        if ([di.city isEqualToString:cityBtn.titleLabel.text])
        {
            [countyArray addObject:di.county];
            [set addObject:di];
        }
    }
    
    if ([set count] == 1)
    {
        postcodeSelectedStr = ((DataItem *)[set anyObject]).postcode;
        postcodeTxtView.text = postcodeSelectedStr;

        countyBtn.enabled = NO;
    }
    else 
    {
        countyBtn.enabled = YES;
    }
    
}

- (void)countyWasSelected:(NSNumber *)selectedIndex element:(id)element
{
    NSInteger i = [selectedIndex intValue];
    
    [countyBtn setTitle:[NSString stringWithString:[countyArray objectAtIndex:i]] 
               forState:UIControlStateNormal];
    
    countySelectedStr = [NSString stringWithString:[countyArray objectAtIndex:i]];
    
    detailTxView.text = [detailTxView.text stringByAppendingString:countySelectedStr];
    
    self.addressStr   = [self.addressStr stringByAppendingFormat:@"%@~",countySelectedStr];
    
    for (int i = 0; i < [dataArray count]; i++)
    {
        DataItem *di = [dataArray objectAtIndex:i];
        if ([di.county isEqualToString:countyBtn.titleLabel.text]
            && [di.city isEqualToString:cityBtn.titleLabel.text])
        {
            postcodeTxtView.text = di.postcode;
            break;
        }
    }
}

- (void)actionPickerCancelled:(id)sender 
{
    
}

#pragma mark - TextView
- (void)textViewDidBeginEditing:(UITextView *)textView
{    
    if ((textView == postcodeTxtView || textView == detailTxView) && moveheight == 0)
    {
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];    
        CGRect rect = CGRectMake(0.0f, -200.0f, self.view.frame.size.width, self.view.frame.size.height);
        self.view.frame = rect;
        [UIView commitAnimations];
        moveheight = -200;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
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

- (IBAction)backgroundTap:(id)sender
{    
    [adressTextView resignFirstResponder];
    [postcodeTxtView resignFirstResponder];
    [nameTextView resignFirstResponder];
    [detailTxView resignFirstResponder];
    [streetAddress resignFirstResponder];
    
    [senderNameTextView resignFirstResponder];
    [postcodeTextView_Sender resignFirstResponder];
    [streetAddress_Sender resignFirstResponder];
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
    
    provincePicker = [[ActionSheetStringPicker alloc] initWithTitle:@"省" 
                                                               rows:provinceArray 
                                                   initialSelection:0 
                                                             target:self 
                                                      successAction:@selector(provinceWasSelected:element:) 
                                                       cancelAction:@selector(actionPickerCancelled:) 
                                                             origin:sender];
    provincePicker.hideCancel = NO;
    [provincePicker showActionSheetPicker:CGRectMake(0, 0, 320, 240)];
}

- (IBAction)clickedCity:(id)sender
{
    if (cityPicker != nil)
    {
        [cityPicker release];
    }
    
    if (provinceSelectedStr != nil && [provinceSelectedStr isEqualToString:@""] == NO)
    {
        
        cityPicker = [[ActionSheetStringPicker alloc] initWithTitle:@"市/区/直辖县" 
                                                               rows:cityArray 
                                                   initialSelection:0 
                                                             target:self 
                                                      successAction:@selector(cityWasSelected:element:) 
                                                       cancelAction:@selector(actionPickerCancelled:)
                                                             origin:sender];
        cityPicker.hideCancel = NO;
        [cityPicker showActionSheetPicker:CGRectMake(0, 0, 320, 240)];
    }

}

- (IBAction)clickedCounty:(id)sender
{
    if (countPicker != nil)
    {
        [countPicker release];
    }
    if (citySelectedStr != nil && [citySelectedStr isEqualToString:@""] == NO)
    {
        countPicker = [[ActionSheetStringPicker alloc] initWithTitle:@"区县" 
                                                                rows:countyArray
                                                    initialSelection:0 
                                                              target:self
                                                       successAction:@selector(countyWasSelected:element:) 
                                                        cancelAction:@selector(actionPickerCancelled:) 
                                                              origin:sender];
        countPicker.hideCancel = NO;
        [countPicker showActionSheetPicker:CGRectMake(0, 0, 320, 240)];
        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark PassValue protocol
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
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        [fontNames release];
    }
    [familyNames release];
}


#pragma mark -填写寄件人信息
- (IBAction)clickedProvince_Sender:(id)sender
{
    if (provincePicker != nil)
    {
        [provincePicker release];
    }
    
    provincePicker = [[ActionSheetStringPicker alloc] initWithTitle:@"省" 
                                                               rows:provinceArray 
                                                   initialSelection:0 
                                                             target:self 
                                                      successAction:@selector(provinceWasSelected_Sender:element:) 
                                                       cancelAction:@selector(actionPickerCancelled:) 
                                                             origin:sender];
    provincePicker.hideCancel = NO;
    [provincePicker showActionSheetPicker:CGRectMake(0, 0, 320, 240)];
}

- (IBAction)clickedCity_Sender:(id)sender
{
    if (cityPicker != nil)
    {
        [cityPicker release];
    }
    
    if (provinceSelectedStr != nil && [provinceSelectedStr isEqualToString:@""] == NO)
    {
        
        cityPicker = [[ActionSheetStringPicker alloc] initWithTitle:@"市/区/直辖县" 
                                                               rows:cityArray 
                                                   initialSelection:0 
                                                             target:self 
                                                      successAction:@selector(cityWasSelected_Sender:element:) 
                                                       cancelAction:@selector(actionPickerCancelled:)
                                                             origin:sender];
        cityPicker.hideCancel = NO;
        [cityPicker showActionSheetPicker:CGRectMake(0, 0, 320, 240)];
    }
    
}

- (IBAction)clickedCounty_Sender:(id)sender
{
    if (countPicker != nil)
    {
        [countPicker release];
    }
    if (citySelectedStr != nil && [citySelectedStr isEqualToString:@""] == NO)
    {
        countPicker = [[ActionSheetStringPicker alloc] initWithTitle:@"区县" 
                                                                rows:countyArray
                                                    initialSelection:0 
                                                              target:self
                                                       successAction:@selector(countyWasSelected_Sender:element:) 
                                                        cancelAction:@selector(actionPickerCancelled:) 
                                                              origin:sender];
        countPicker.hideCancel = NO;
        [countPicker showActionSheetPicker:CGRectMake(0, 0, 320, 240)];
    }
}


- (void)provinceWasSelected_Sender:(NSNumber *)selectedIndex 
                    element:(id)element
{
    //Todo
    // Clear city and county set
    
    NSInteger i = [selectedIndex intValue];
    
    provinceSelectedStr = nil;
    provinceSelectedStr = [NSString stringWithString:[provinceArray objectAtIndex:i]];
    
    [provinceBtn_Sender setTitle:[NSString stringWithString:provinceSelectedStr]
                 forState:UIControlStateNormal];
    
    [cityBtn_Sender setTitle:[NSString stringWithString:@"市"] forState:UIControlStateNormal];
    [countryBtn_Sender setTitle:[NSString stringWithString:@"区县"] forState:UIControlStateNormal];
    
    citySelectedStr = nil;
    countySelectedStr = nil;
    
    postcodeSelectedStr = nil;
    
    postcodeTextView_Sender.text = nil;
    
    detailTextView_Sender.text = provinceSelectedStr;
    
    [cityArray removeAllObjects];
    
    NSMutableSet *set = [NSMutableSet set];
    for (int i = 0; i < [dataArray count]; i++)
    {
        DataItem *di = [dataArray objectAtIndex:i];
        if ([di.province isEqualToString:provinceBtn_Sender.titleLabel.text])
        {
            [set addObject:di.city];
        }
    } 
    
    for (NSString *cityString in set) 
    {
        [cityArray addObject:cityString];
    }
}

- (void)cityWasSelected_Sender:(NSNumber *)selectedIndex
                element:(id)element
{
    NSInteger i = [selectedIndex intValue];
    
    citySelectedStr = [NSString stringWithString:[cityArray objectAtIndex:i]];
    
    [cityBtn_Sender setTitle:[NSString stringWithString:citySelectedStr]
             forState:UIControlStateNormal];
    
    [countryBtn_Sender setTitle:[NSString stringWithString:@"区县"]
               forState:UIControlStateNormal];
    
    detailTextView_Sender.text = [detailTextView_Sender.text stringByAppendingString:citySelectedStr];
    
    [countyArray removeAllObjects];
    NSMutableSet *set = [NSMutableSet set];
    
    for (int i = 0; i < [dataArray count]; i++)
    {
        DataItem *di = [dataArray objectAtIndex:i];
        if ([di.city isEqualToString:cityBtn_Sender.titleLabel.text])
        {
            [countyArray addObject:di.county];
            [set addObject:di];
        }
    }
    
    if ([set count] == 1)
    {
        postcodeSelectedStr = ((DataItem *)[set anyObject]).postcode;
        postcodeTextView_Sender.text = postcodeSelectedStr;
        
        countryBtn_Sender.enabled = NO;
    }
    else 
    {
        countryBtn_Sender.enabled = YES;
    }
    
}

- (void)countyWasSelected_Sender:(NSNumber *)selectedIndex 
                  element:(id)element
{
    NSInteger i = [selectedIndex intValue];
    
    [countryBtn_Sender setTitle:[NSString stringWithString:[countyArray objectAtIndex:i]] 
               forState:UIControlStateNormal];
    
    countySelectedStr = [NSString stringWithString:[countyArray objectAtIndex:i]];
    
    detailTextView_Sender.text = [detailTextView_Sender.text stringByAppendingString:countySelectedStr];
    
    for (int i = 0; i < [dataArray count]; i++)
    {
        DataItem *di = [dataArray objectAtIndex:i];
        if ([di.county isEqualToString:countryBtn_Sender.titleLabel.text]
            && [di.city isEqualToString:cityBtn_Sender.titleLabel.text])
        {
            postcodeTextView_Sender.text = di.postcode;
            break;
        }
    }
}


#pragma mark - FinishAdressInfo - 地址填写完成 
- (IBAction)finishAdressInfo 
{
    self.addressStr = [self.addressStr stringByAppendingFormat:@"%@",self.streetAddress.text];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.addressStr forKey:@"DETAILS_ADDRESS_URL"];//要上传服务器的收件人地址
    
    NSString *blessStr  = [NSString stringWithFormat:@"%@",adressTextView.text];//收件人祝福语
    NSString *nameStr = [NSString stringWithFormat:@"%@",nameTextView.text];//收件人姓名
    NSString *postcodeStr = [NSString stringWithFormat:@"%@",postcodeTxtView.text];//收件人邮编
    NSString *detailStr = [detailTxView.text stringByAppendingFormat:@"%@",self.streetAddress.text];//收件人详细地址
    
    [[NSUserDefaults standardUserDefaults] setObject:blessStr forKey:@"BLESS"];
    [[NSUserDefaults standardUserDefaults] setObject:nameStr forKey:@"RECEIVER_NAME"];
    [[NSUserDefaults standardUserDefaults] setObject:postcodeStr forKey:@"RECEIVER_POSTCODE"];
    [[NSUserDefaults standardUserDefaults] setObject:detailStr forKey:@"DETAILS_ADDRESS"];  
    
    
    NSString *senderNameStr = [NSString stringWithFormat:@"%@",self.senderNameTextView.text];//寄件人姓名
    NSString *postcodeStr_Sender = [NSString stringWithFormat:@"%@",self.postcodeTextView_Sender.text];//寄件人邮编
    NSString *detailStr_Sender = [detailTextView_Sender.text stringByAppendingFormat:@"%@",self.streetAddress_Sender.text];//寄件人详细地址
    
    [[NSUserDefaults standardUserDefaults] setObject:senderNameStr forKey:@"SENDER_NAME"];
    [[NSUserDefaults standardUserDefaults] setObject:postcodeStr_Sender forKey:@"SENDER_POSTCODE"];
    [[NSUserDefaults standardUserDefaults] setObject:detailStr_Sender forKey:@"SENDER_ADDRESS"];
        
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"From_Back"] == YES)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getAddress" object:nil];//通知填写地址
    }
    [self dismissModalViewControllerAnimated:YES];
}

@end
