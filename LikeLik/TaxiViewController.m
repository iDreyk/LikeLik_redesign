//
//  TaxiViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 23.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "TaxiViewController.h"
#import "AppDelegate.h"
#import "SubText.h"

static BOOL infoViewIsOpen = NO;
@interface TaxiViewController ()

@end

@implementation TaxiViewController

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
    
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:self.TaxiName AndColor:[InterfaceFunctions corporateIdentity]];
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    
    
    for (UIView * view in self.view.subviews) {
        UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesture:)];
        recognizer.delegate = self;
        [view addGestureRecognizer:recognizer];
        
        // TODO: Add a custom gesture recognizer too
        
    }
    
    
    self.TaxiInfo.backgroundColor = [UIColor redColor];//[AppDelegate color1withFlag:5];
    
    
    self.LabelonScroll.text = self.TaxiName;
    
    
    self.LabelonScroll.textColor = [UIColor whiteColor];
    self.LabelonScroll.font = [AppDelegate OpenSansSemiBold:60];
    
    self.Taxilabel.text = self.TaxiName;
    self.TaxiText.text = self.TaxiAbout;
    self.TelLabel.text = self.Telephone;
    self.WebLabel.text = self.Web;
    
    
    self.TelLabel.font = [AppDelegate OpenSansRegular:28];
    self.WebLabel.font = [AppDelegate OpenSansRegular:28];
    self.Taxilabel.font = [AppDelegate OpenSansSemiBold:32];
    self.TaxiText.font = [AppDelegate OpenSansRegular:28];
    
    self.TelLabel.textColor = [UIColor whiteColor];
    self.WebLabel.textColor = [UIColor whiteColor];
    self.Taxilabel.textColor = [UIColor whiteColor];
    self.TaxiText.textColor = [UIColor whiteColor];
    
    
    self.TaxiText.backgroundColor  =[UIColor clearColor];
    self.TaxiText.scrollEnabled = YES;
    self.TaxiText.editable = NO;
    

    
    
    NSInteger numberOfViews = [self.Photo count];
    for (int i = 0; i < numberOfViews; i++) {
        CGFloat xOrigin = i * self.view.frame.size.width;
        UIImageView *awesomeView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0, self.view.frame.size.width, self.view.frame.size.height)];
        awesomeView.backgroundColor = [UIColor colorWithRed:0.5/i green:0.5 blue:0.5 alpha:1];
        awesomeView.image = [UIImage imageWithContentsOfFile:[self.Photo objectAtIndex:i]];
        if ([UIImage imageWithContentsOfFile:[[NSString alloc] initWithFormat:@"%@",[self.Photo objectAtIndex:i]]].size.height == 640.0) {
            awesomeView.frame = CGRectMake(xOrigin, self.view.center.y/2, self.view.frame.size.width, [UIImage imageWithContentsOfFile:[[NSString alloc] initWithFormat:@"%@",[self.Photo objectAtIndex:i]]].size.height/4);
        }
        [_ScrollView addSubview:awesomeView];
    }
    UIView *awesomeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0, 512.0)];
    awesomeView.backgroundColor = [UIColor colorWithRed:0.5/2 green:0.5 blue:0.5 alpha:1];
    
    
    self.view.backgroundColor = [UIColor blackColor];
    _ScrollView.pagingEnabled = YES;
    _ScrollView.showsHorizontalScrollIndicator = NO;
    _ScrollView.showsVerticalScrollIndicator = NO;
    _ScrollView.contentSize = CGSizeMake(self.view.frame.size.width * numberOfViews, 400.0);
 
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    singleTap.numberOfTapsRequired = 1;
    [self.ScrollView addGestureRecognizer:singleTap];

    [_ScrollView setBackgroundColor:[UIColor blackColor]];
    
    UILabel *Red_line = [[UILabel alloc] initWithFrame:CGRectMake(14.0, 10.0, 250.0, 50.0)];
    Red_line.text =  self.TaxiName;
    Red_line.font =[AppDelegate OpenSansSemiBold:28];
    Red_line.textColor = [UIColor whiteColor];
    Red_line.numberOfLines = 10;
    Red_line.backgroundColor =  [UIColor clearColor];
    Red_line.numberOfLines = 0;
    [Red_line sizeToFit];
    CGSize size1 =Red_line.frame.size;
    size1.width=292.0;
    Red_line.frame = CGRectMake(Red_line.frame.origin.x, Red_line.frame.origin.y, size1.width, size1.height);
    [Red_line sizeThatFits:size1];
    
    SubText *label = [[SubText alloc] initWithFrame:CGRectMake(14.0, Red_line.frame.origin.y+Red_line.frame.size.height, 292.0, 50.0)];
    
    label.text = self.TaxiAbout;
    label.font = [AppDelegate OpenSansRegular:28];
    label.textColor = [UIColor whiteColor];
    //label.numberOfLines = 10;
    label.backgroundColor =  [UIColor clearColor];
    //label.numberOfLines = 0;
    //  label.backgroundColor =  [UIColor clearColor];
    label.editable = NO;
    
    
    CGSize textViewSize = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, 500.0) lineBreakMode:NSLineBreakByWordWrapping];
    label.contentInset = UIEdgeInsetsMake(-6, -8, 0, 0);
    if ([AppDelegate isiPhone5]) {
        label.frame = CGRectMake(14.0,label.frame.origin.y, 292.0, textViewSize.height+35);
    }
    else{
        label.frame = CGRectMake(14.0,label.frame.origin.y, 292.0, textViewSize.height+50);
    }
    [label setScrollEnabled:NO];
    
    
    UIButton *tel = [UIButton buttonWithType:UIButtonTypeCustom];
    [tel setFrame:CGRectMake(35.0, label.frame.origin.y+label.frame.size.height, 250.0, 32.0)];
    [tel setTitle:self.Telephone forState:UIControlStateNormal];
    [tel setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [tel setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [tel sizeToFit];
    [tel.titleLabel setFont:[AppDelegate OpenSansRegular:28]];
    [tel addTarget:self action:@selector(launchPhoneWithNumber:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *_actb1 = [[UIImageView alloc] initWithFrame:CGRectMake(250,16, 9, 14)];
        _actb1.image=[UIImage imageNamed:@"actb_white"];
    
    [tel addSubview:_actb1];
    
    size1 =tel.frame.size;
    size1.width=271.0;
    tel.frame = CGRectMake(tel.frame.origin.x,tel.frame.origin.y, size1.width, size1.height*2);
    
    
    UIImageView *Phone = [[UIImageView alloc] initWithFrame:CGRectMake(14.0, label.frame.origin.y+label.frame.size.height, 14.0, 16.0)];
    Phone.backgroundColor =  [UIColor clearColor];
    Phone.image = [UIImage imageNamed:@"ico_tel.png"];

    
    CGPoint center = tel.center;
    center.x = Phone.center.x;
    Phone.center = center;//tel.center;
    [tel setTitleEdgeInsets:UIEdgeInsetsMake(12.0, 0.0, 0.0, 0.0)];
    
    UIImageView * line2 = [[UIImageView alloc] initWithFrame:CGRectMake(14.0, tel.frame.origin.y+tel.frame.size.height, 292.0, 1.0)];
    line2.backgroundColor =  [UIColor clearColor];
    line2.image = [UIImage imageNamed:@"separator_line.png"];
    
    
    UIButton *web = [UIButton buttonWithType:UIButtonTypeCustom];
    [web setFrame:CGRectMake(35.0,tel.frame.origin.y+tel.frame.size.height, 250.0, 32.0)];
    [web setTitle:self.Web forState:UIControlStateNormal];
    [web setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [web setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [web sizeToFit];
    
    [web.titleLabel setFont:[AppDelegate OpenSansRegular:28]];//[UIFont boldSystemFontOfSize:20]];
    [web addTarget:self action:@selector(webPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *_actb = [[UIImageView alloc] initWithFrame:CGRectMake(250,16, 9, 14)];
    _actb.image=[UIImage imageNamed:@"actb_white"];
    
    
    [web addSubview:_actb];
    
    size1 =web.frame.size;
    size1.width=271.0;
    web.frame = CGRectMake(web.frame.origin.x,web.frame.origin.y, size1.width, size1.height*2);
    
    
    UIImageView *earth = [[UIImageView alloc] initWithFrame:CGRectMake(14.0, tel.frame.origin.y+tel.frame.size.height, 16.0, 16.0)];
    earth.backgroundColor =  [UIColor clearColor];
    earth.image = [UIImage imageNamed:@"ico_earth.png"];
    center = web.center;
    center.x = earth.center.x;
    earth.center = center;
    [web setTitleEdgeInsets:UIEdgeInsetsMake(12.0, 0.0, 0.0, 0.0)];
    
    [_infoScroll setBackgroundColor:self.color];
    
    [_infoScroll addSubview:Red_line];
    
    [_infoScroll addSubview:label];
    
    [_infoScroll addSubview:tel];
    [_infoScroll addSubview:Phone];
    [_infoScroll addSubview:line2];
    
    [_infoScroll addSubview:web];
    [_infoScroll addSubview:earth];
    
	// Do any additional setup after loading the view.
}


-(void)viewDidAppear:(BOOL)animated{
//#warning info!info
}

-(void)gesture:(UIGestureRecognizer *)gestureRecognizer{
    //    nslog(@"like!");
    [self tapDetected:gestureRecognizer];
}

-(BOOL)launchPhoneWithNumber:(UIButton *)sender {
   

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:AMLocalizedString(@"Call", nil)
                                                             delegate:self
                                                    cancelButtonTitle:AMLocalizedString(@"Cancel", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles: sender.titleLabel.text, nil];
    
    [actionSheet showFromRect:CGRectMake(0.0, 0.0, 320.0, 300.) inView:[[self navigationController] navigationBar] animated:YES];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    return YES;
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if ([actionSheet.title isEqualToString:AMLocalizedString(@"Call", nil)]) {
        
        if (buttonIndex == 0){
            

            NSString *tel =[actionSheet buttonTitleAtIndex:0];
            NSString* launchUrl = [NSString stringWithFormat:@"tel:%@",tel];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
        }
    }
    
    if ([actionSheet.title isEqualToString:AMLocalizedString(@"Web", nil)]) {
        if (buttonIndex == 0){
            
            NSURL *address =[[NSURL alloc] initWithString:[actionSheet buttonTitleAtIndex:0]];
            [[UIApplication sharedApplication] openURL:address];

        }
    }
}

-(void)webPressed:(UIButton *)sender{
    NSString *url = [NSString stringWithFormat:@"http://%@",sender.titleLabel.text];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:AMLocalizedString(@"Web", nil)
                                                             delegate:self
                                                    cancelButtonTitle:AMLocalizedString(@"Cancel", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles: url, nil];
    
    [actionSheet showFromRect:CGRectMake(0.0, 0.0, 320.0, 300.) inView:[[self navigationController] navigationBar] animated:YES];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    

}

- (IBAction)tapDetected:(UIGestureRecognizer *)sender {
    
    
    if (infoViewIsOpen == NO) {
        [UIView animateWithDuration:0.6 animations:^{
            CGRect Frame = self.TaxiCard.frame;
            Frame.origin.y = 15.0;
            if ([AppDelegate isiPhone5])
                [self.TaxiCard setFrame:CGRectMake(0.0, 163.0,self.TaxiCard.frame.size.width, self.TaxiCard.frame.size.height)];
            else
                [self.TaxiCard setFrame:CGRectMake(0.0, 65.0,self.TaxiCard.frame.size.width, self.TaxiCard.frame.size.height)];
        }];
        infoViewIsOpen = YES;
    }
    else{
        [UIView animateWithDuration:0.6 animations:^{
            if ([AppDelegate isiPhone5])
                [self.TaxiCard setFrame:CGRectMake(0.0, 450.0, self.TaxiCard.frame.size.width, self.TaxiCard.frame.size.height)];
            else
                [self.TaxiCard setFrame:CGRectMake(0.0, 363,self.TaxiCard.frame.size.width, self.TaxiCard.frame.size.height)];
        }];
        
        infoViewIsOpen = NO;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

-(void)viewDidDisappear:(BOOL)animated{
    infoViewIsOpen = NO;
}

- (void)viewDidUnload {

    [self setScrollView:nil];
    [self setTaxiInfo:nil];
    [self setLabelonScroll:nil];
    [super viewDidUnload];
}
@end
