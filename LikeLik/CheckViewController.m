//
//  CheckViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 22.03.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "CheckViewController.h"
#import "ZBarReaderViewController.h"
#import "UIViewController+KNSemiModal.h"

#import "AppDelegate.h"
#import "SubText.h"

#import <mach/mach_time.h>
mach_timebase_info_data_t info1;

NSDictionary *dictforCheck;
static BOOL foreignversion = NO;
@interface CheckViewController ()

@end

@implementation CheckViewController
@synthesize resultImage,resultText;
@synthesize PlaceCategory,PlaceName,PlaceCity,QRString;
@synthesize label1;
@synthesize alreadyuse,color;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIGestureRecognizer *tap = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.delegate = self;
    
    self.activate.titleLabel.font = [AppDelegate OpenSansBoldwithSize:40];
    self.cancel.titleLabel.font = [AppDelegate OpenSansBoldwithSize:40];
    if ([AppDelegate isiPhone5])
        alreadyuse = [[UILabel alloc] initWithFrame:CGRectMake(self.CheckView.center.x/2-9, self.gradientunderbutton.frame.origin.y-60.0, 150.0, 90.0)];
    else
        alreadyuse = [[UILabel alloc] initWithFrame:CGRectMake(self.CheckView.center.x/2-9, 300.0, 150.0, 90.0)];
    //[alreadyuse sizeToFit];
  //  alreadyuse.numberOfLines = 0;
    alreadyuse.text = AMLocalizedString(@"Check LikeLik\nused", nil);
    alreadyuse.textAlignment = NSTextAlignmentCenter;
    alreadyuse.numberOfLines = 2;
    alreadyuse.font = [AppDelegate OpenSansBoldwithSize:40];
    alreadyuse.hidden = YES;
    alreadyuse.backgroundColor =[UIColor clearColor];
    [self.CheckView addSubview:alreadyuse];
    
    UILabel *Title = [[UILabel alloc] initWithFrame:CGRectMake(6.0, 12.0, 280.0, 50.0)];
    Title.text = @"123";
    Title.textAlignment = NSTextAlignmentCenter;
    Title.font = [AppDelegate OpenSansRegular:40];
    Title.backgroundColor = [UIColor clearColor];
    
    
    [self.activate setTitle:AMLocalizedString(@"Use check", nil) forState:UIControlStateNormal];
    [self.cancel setTitle:AMLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    self.ExclusiveOffer.hidden = NO;
    self.ExclusiveOffer.font = [AppDelegate OpenSansSemiBold:30];
    self.ExclusiveOffer.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:100];
    self.ExclusiveOffer.text = AMLocalizedString(@"The exclusive LikeLik check offer includes", nil);
    
    
    //    self.forEnglish.hidden = NO;
    //    self.forEnglish.font = [AppDelegate OpenSansSemiBold:26];
    //    self.forEnglish.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:100];
    //    //self.forEnglish.text = @"Display text in English";
    
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @1};
    [self.foreignLanguage setAttributedTitle:[[NSAttributedString alloc] initWithString:AMLocalizedString(@"Display text in the local language", nil) attributes:underlineAttribute] forState:UIControlStateNormal];
    self.foreignLanguage.titleLabel.font = [AppDelegate OpenSansRegular:26];
    self.foreignLanguage.titleLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:100];
    self.foreignLanguage.hidden =NO;
    
    
    
    
     
    
    label1 = [[SubText alloc] initWithFrame:CGRectMake(0.0, 0.0, 252.0, 159.0)];
    label1.font = [AppDelegate OpenSansRegular:26];
    label1.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:100];
    label1.backgroundColor =  [UIColor clearColor];
    label1.editable = NO;
    
    
    
    
    
    [self.Offer addSubview:label1];
    self.fistbackground.hidden = YES;
    self.alreadyuse.hidden = YES;
    
}
-(void)viewDidAppear:(BOOL)animated{
    //    nslog(@"%@",self.PlaceName);

    self.Label.font = [AppDelegate OpenSansRegular:40];
    self.Label.text = self.PlaceName;
    self.Label.hidden = NO;
    self.Label.shadowColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
    self.Label.shadowOffset = CGSizeMake(0.0, -0.5);
    self.ribbonimage.image = [InterfaceFunctions Ribbon:self.PlaceCategory].image;
    self.ribbonimage.hidden = NO;
    self.check_background.image = [InterfaceFunctions check_background];
    [self.activate setBackgroundImage:[InterfaceFunctions usecheckbutton:self.PlaceCategory andTag:@""].image forState:UIControlStateNormal];
    [self.activate setBackgroundImage:[InterfaceFunctions usecheckbutton:self.PlaceCategory andTag:@"_selected"].image forState:UIControlStateHighlighted];
    
    
    
    dictforCheck = [ExternalFunctions getCheckDictionariesOfPlace:self.PlaceName InCategory:self.PlaceCategory InCity:self.PlaceCity];
    label1.text = [dictforCheck objectForKey:@"main"];
    CGSize textViewSize = [label1.text sizeWithFont:label1.font constrainedToSize:CGSizeMake(label1.frame.size.width, 500.0) lineBreakMode:NSLineBreakByWordWrapping];
    label1.contentInset = UIEdgeInsetsMake(-6, -8, 0, 0);
    
    label1.frame = CGRectMake(0.0,label1.frame.origin.y, 252.0, textViewSize.height+50.0);
    
}

-(void)viewDidDisappear:(BOOL)animated{
}

-(IBAction)tap:(id)sender{
    //    nslog(@"%@",sender);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showQR:(id)sender{
    //    nslog(@"Show");
   // self.Offer.hidden = YES;
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
   
        [reader takePicture];
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
        //[TestFlight passCheckpoint:@"Open Camera"];
    [self presentViewController:reader animated:YES completion:^{}];
}

-(IBAction)CloseCheck:(id)sender{
    self.activate.hidden = NO;
    self.cancel.titleLabel.text = AMLocalizedString(@"Back", nil);
    self.gradientunderbutton.frame = CGRectMake(20.0, 395.0,280.0 , 35);
    self.foreignLanguage.hidden = NO;
    self.Offer.hidden = NO;
    self.ExclusiveOffer.hidden = NO;
    self.fistbackground.hidden = YES;
    self.alreadyuse.hidden = YES;
    UIViewController *parent = [self.view containingViewController];
    if ([parent respondsToSelector:@selector(dismissSemiModalView)])
    {
        [self dismissSemiModalView];
    }
}

-(IBAction)foreignLanguage:(id)sender{
    //    nslog(@"Okay");
    if (foreignversion == NO) {
        label1.text = [dictforCheck objectForKey:@"secondary"];
    }
    else{
        label1.text = [dictforCheck objectForKey:@"main"];
    }
    
    CGSize textViewSize = [label1.text sizeWithFont:label1.font constrainedToSize:CGSizeMake(label1.frame.size.width, 500.0) lineBreakMode:NSLineBreakByWordWrapping];
    label1.contentInset = UIEdgeInsetsMake(-6, -8, 0, 0);
    
    label1.frame = CGRectMake(0.0,label1.frame.origin.y, 252.0, textViewSize.height);
 
    foreignversion = !foreignversion;
    
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    

    //[TestFlight passCheckpoint:@"Recognize QR"];

    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
    resultText.text = symbol.data;
    [self UnlockwithText:symbol.data];
    // EXAMPLE: do something useful with the barcode image
    resultImage.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    mach_timebase_info ( & info1 );
    
    // подождем 5 секунд
    const uint64_t start = mach_absolute_time ();
    while ( (mach_absolute_time () - start) * info1.numer / info1.denom < 2500000000 )
    {}
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)UnlockwithText:(NSString *)string{
    //    nslog(@"string = %@  placename = %@",string, PlaceName);
    
    
    
    if ([ExternalFunctions isTheRightQRCodeOfPlace:PlaceName InCategory:PlaceCategory InCity:PlaceCity WithCode:string]) {

        self.activate.hidden = YES;
        [self.cancel setTitle:AMLocalizedString(@"Back", nil) forState:UIControlStateNormal];
        [self.cancel.titleLabel sizeToFit];
        self.cancel.hidden = NO;
        self.activate.hidden = YES;

        self.foreignLanguage.hidden = YES;
        self.Offer.hidden = YES;
        self.ExclusiveOffer.hidden = YES;
        if ([AppDelegate isiPhone5])
            self.gradientunderbutton.frame = CGRectMake(20.0, self.cancel.frame.origin.y-16.0, 280.0, 35.0);
        else
            [self.gradientunderbutton setFrame:CGRectMake(20.0, 320.0, 50.0, 35.0)];

        self.fistbackground.hidden = NO;
        self.alreadyuse.hidden = NO;
        
    }
    else{
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.userInteractionEnabled = NO;
        
        HUD.mode = MBProgressHUDModeCustomView;
        
        HUD.removeFromSuperViewOnHide = YES;
        HUD.customView = [InterfaceFunctions LabelHUDwithString:AMLocalizedString(@"Invalid QR-code or location", nil)];
        HUD.delegate = self;
        [HUD show:YES];
        [HUD hide:YES afterDelay:4];
        
    }
}

- (void)viewDidUnload {
    [self setCheck_bg:nil];
    [self setActivate:nil];
    [self setCancel:nil];
    [self setExclusiveOffer:nil];
    [super viewDidUnload];
}
@end
