//
//  VoiceMessageView.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-24.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "VoiceMessageView.h"

@implementation VoiceMessageView
@synthesize readQRView;
@synthesize goBackButton;
@synthesize voiceURLStr;
@synthesize strLabel;
@synthesize startScanQRButton;
@synthesize playVoiceView;


#pragma mark - GoBack - 返回按钮
- (IBAction)goBack
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - StartScanQR - 开始扫描二维码
- (IBAction)startScanQR
{
    [readQRView start];
    readQRView.hidden = NO;
}


#pragma mark - View lifecycle - 系统函数
-(void)cleanup
{
    voiceURLStr = nil;
    readQRView.readerDelegate = nil;
    [readQRView release];
    readQRView = nil;
}

-(void)dealloc
{
    [goBackButton release];
    [playVoiceView release];
    [self cleanup];
    [startScanQRButton release];
    [strLabel release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated
{
    readQRView.hidden = YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    voiceURLStr = nil;
    [ZBarReaderView class];
    readQRView.readerDelegate = self;
    [self.goBackButton setImage:[UIImage imageNamed:@"titlebtnbackclick.png"] 
                       forState:UIControlStateHighlighted];
    [super viewDidLoad];
    
}

-(void)viewDidAppear:(BOOL)animated
{
}

-(void)viewWillDisappear:(BOOL)animated
{
    [readQRView stop];
}

- (void)viewDidUnload
{
    [self setGoBackButton:nil];
    [self cleanup];
    [self setStartScanQRButton:nil];
    [self setStrLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) orient
                                 duration: (NSTimeInterval) duration
{
    // compensate for view rotation so camera preview is not rotated
    [readQRView willRotateToInterfaceOrientation: orient
                                        duration: duration];
}


-(void)readerView:(ZBarReaderView *)readerView 
   didReadSymbols:(ZBarSymbolSet *)symbols 
        fromImage:(UIImage *)image
{
    for(ZBarSymbol *sym in symbols) 
    {
        self.voiceURLStr = sym.data;
        if (self.voiceURLStr != nil) 
        {
            [[NSUserDefaults standardUserDefaults] setObject:self.voiceURLStr forKey:@"voiceURLStr"];
            [self performSelector:@selector(goToPlayVoiceView)];//进入播放录音界面
        }
    }
}

#pragma mark - GoToPlayVoiceView - 进入播放录音界面
-(void)goToPlayVoiceView
{
    PlayVoiceView *tmpPlayVoiceView =[[PlayVoiceView alloc] init];
    tmpPlayVoiceView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.playVoiceView = tmpPlayVoiceView;
    [self presentModalViewController:self.playVoiceView animated:YES];
    [tmpPlayVoiceView release];
}


@end
