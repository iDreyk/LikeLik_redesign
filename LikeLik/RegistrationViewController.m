//
//  RegistrationViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 20.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "RegistrationViewController.h"
#import "AppDelegate.h"

#import "SA_OAuthTwitterEngine.h"
#import "SCFacebook.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#define kOAuthConsumerKey				@"XGaxa31EoympFhxLZooQ"
#define kOAuthConsumerSecret			@"IbUE5lud22evmrtxjtU1vKvh6VDqRMSHHFJ73rtHI"
#define afterCall             @"l27h7RU2dzVfPoQQQQ"
#define afterFB             @"l27h7RU2dadsdafszVfPoQQQQ"
#define afterregister             @"l27h7RU2dzVfP12aoQssda"

#define RemoveNull(field) ([[self.FacebookUserInfo objectForKey:field] isKindOfClass:[NSNull class]]) ? @"" : [self.FacebookUserInfo objectForKey:field];
@interface RegistrationViewController ()

@end
//чтобы запушить
@implementation RegistrationViewController
@synthesize Login,Password,Email,Confirm,Switch,BirthDayPicker;
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
    
    array = @[@"Name",@"E-Mail",@"Password",@"Password"];
    self.lang = [[NSString alloc] init];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"Language"]);
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Language"] isEqualToString:@"Русский"])
        self.lang = @"ru";
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Language"] isEqualToString:@"English"])
        self.lang = @"en";
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Language"] isEqualToString:@"Deutsch"])
        self.lang = @"de";

    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"Registration", nil) AndColor:[InterfaceFunctions corporateIdentity]];
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    [self.RegistrationTable setBackgroundColor:[UIColor clearColor]];
    self.view.backgroundColor = [InterfaceFunctions BackgroundColor];
	// Do any additional setup after loading the view.
    self.RegistrationTable.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    UIButton *btn = [InterfaceFunctions done_button];
    [btn addTarget:self action:@selector(Done) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self.SurpriseText setText: AMLocalizedString(@"I want to receive gifts on my birthday", nil)];
    
    NSLocale * locale;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Language"] isEqualToString:@"Русский"])
        locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Language"] isEqualToString:@"English"])
        locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_EN"];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Language"] isEqualToString:@"Deutsch"])
        locale = [[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"];
    
    BirthDayPicker.locale = locale;
    BirthDayPicker.calendar = [locale objectForKey:NSLocaleCalendar];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    [BirthDayPicker addTarget:self
                   action:@selector(getDate:)
         forControlEvents:UIControlEventValueChanged];
    
    day = @"0";
    month = @"0";
    year = @"0";
    
    _vkontakte = [Vkontakte sharedInstance];
    _vkontakte.delegate = self;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(afterFacebook)
                                                 name:afterFB object:nil];
    
    
    self.HUDemailcheck = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.HUDemailcheck];
    self.HUDemailcheck.mode = MBProgressHUDModeCustomView;
    //self.HUDemailcheck.removeFromSuperViewOnHide = YES;
    self.HUDemailcheck.customView = [InterfaceFunctions LabelHUDwithString:AMLocalizedString(@"сheck e-mail please", nil)];
    self.HUDemailcheck.delegate = self;
    
    
    
    self.HUDpassword = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.HUDpassword];
    self.HUDpassword.userInteractionEnabled = NO;
    self.HUDpassword.mode = MBProgressHUDModeCustomView;
    //self.HUDpassword.removeFromSuperViewOnHide = YES;
    self.HUDpassword.customView = [InterfaceFunctions LabelHUDwithString:AMLocalizedString(@"passwords do not match", nil)];
    self.HUDpassword.delegate = self;
    
    
    self.HUDdone = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.HUDdone];
    self.HUDdone.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"74_74 Fist_for_HUD_colored"]];
    self.HUDdone.mode = MBProgressHUDModeCustomView;
    self.HUDdone.delegate = self;
    self.HUDdone.labelText = AMLocalizedString(@"Done", nil);

    self.HUDfade = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.HUDfade];
    self.HUDfade.userInteractionEnabled = NO;
    self.HUDfade.mode = MBProgressHUDAnimationFade;
   // self.HUDfade.removeFromSuperViewOnHide = YES;
    self.HUDfade.delegate = self;
    
    
    self.HUDerror = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.HUDerror];
    self.HUDerror.mode = MBProgressHUDModeCustomView;
   // self.HUDerror.removeFromSuperViewOnHide = YES;
    self.HUDerror.delegate = self;
    
}


- (void)getDate:(id)sender{
    
    NSDate *date = BirthDayPicker.date;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd"];

    day = [df stringFromDate:date];
    [df setDateFormat:@"MM"];
    month = [df stringFromDate:date];
    [df setDateFormat:@"YYYY"];
    year = [df stringFromDate:date];

    
}

-(void)textFieldDidChange:(UITextField *)sender{
    if ([Login.text length]>0 && [Email.text length]>0 &&[Password.text length]>0 && [Confirm.text length]>0  ) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

-(void)Done{
    [Password resignFirstResponder];
    [Login resignFirstResponder];
    [Email resignFirstResponder];
    [Confirm resignFirstResponder];

    if ([Password.text isEqualToString:Confirm.text]) {
        if ([self validateMail:Email.text] == YES)
            [self Send:@"Self"];

        else{
            [self.HUDemailcheck show:YES];
            [self.HUDemailcheck hide:YES afterDelay:2];
        }
    }
    else{
        [self.HUDpassword show:YES];
        [self.HUDpassword hide:YES afterDelay:2];
        
    }
}

- (BOOL)validateMail:(NSString *)string
{
    
    NSString *expression = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSTextCheckingResult *match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    
    if (match){
        return YES;
    }else{
        return NO;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 4;
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = nil;//@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    if ([indexPath row] == 0) {
        Login=[[UITextField alloc] initWithFrame:CGRectMake(100, 10, 200, 35)];
            [Login addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        Login.delegate = self;
        Login.autocorrectionType = UITextAutocorrectionTypeNo;
        Login.tag=[indexPath row];
        Login.placeholder = AMLocalizedString(@"Name", nil);
        [cell.contentView addSubview:Login];
        Login.returnKeyType = UIReturnKeyNext;
        Login.text = @"";
    }
    if ([indexPath row] == 1) {
        
        Email =[[UITextField alloc] initWithFrame:CGRectMake(100, 10, 200, 35)];
        
        [Email addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        Email.delegate = self;
        Email.autocorrectionType = UITextAutocorrectionTypeNo;
        Email.tag=[indexPath row];
                Email.placeholder = AMLocalizedString(@"E-mail", nil);
        Email.keyboardType = UIKeyboardTypeEmailAddress;
        [cell.contentView addSubview:Email];
        Email.returnKeyType = UIReturnKeyNext;
        Email.text = @"";
    }
    if ([indexPath row] == 2) {
        Password = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 200, 35)];
        [Password addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        Password.delegate = self;
        Password.autocorrectionType = UITextAutocorrectionTypeNo;
        Password.tag=[indexPath row];
                Password.placeholder = AMLocalizedString(@"Password", nil);
        Password.secureTextEntry = YES;
        [cell.contentView addSubview:Password];
        Password.text = @"";
        Password.returnKeyType = UIReturnKeyNext;
    }
    
    if ([indexPath row] == 3) {
        Confirm = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 200, 35)];
        Confirm.delegate = self;
        [Confirm addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        Confirm.autocorrectionType = UITextAutocorrectionTypeNo;
        Confirm.tag=[indexPath row];
        Confirm.placeholder = AMLocalizedString(@"Confirm", nil);
        Confirm.secureTextEntry = YES;
        [cell.contentView addSubview:Confirm];
        Confirm.text = @"";
        Confirm.returnKeyType = UIReturnKeyDone;
    }
    
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad.png"]];
    cell.textLabel.text = AMLocalizedString([array objectAtIndex:[indexPath row]], nil);
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    
   
    
    return cell;
}

-(void)afterFacebook{
    NSLog(@"yo!");
    self.navigationController.navigationBar.hidden= NO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 44.0;
    
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text = @"";
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.BirthDayPicker.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    
}

-(void)viewDidDisappear:(BOOL)animated{
    if ([self.Parent isEqualToString:@"Place"] == YES) {
        self.navigationController.navigationBar.hidden = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:afterregister
                                                            object:self];

        NSLog(@"Back to Place");
    }
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([Login.text length]>0 && [Email.text length]>0 &&[Password.text length]>0 && [Confirm.text length]>0  ) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:Login]) {
        [Login resignFirstResponder];
        [Email becomeFirstResponder];
    }
    if ([textField isEqual:Email]) {
        [Email resignFirstResponder];
        [Password becomeFirstResponder];
    }
    
    if ([textField isEqual:Password]) {
        [Password resignFirstResponder];
        [Confirm becomeFirstResponder];
    }
    
    if ([textField isEqual:Confirm]) {
        [Confirm resignFirstResponder];
        if ([Login.text length]>0 && [Email.text length]>0 &&[Password.text length]>0 && [Confirm.text length]>0  ) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [self Done];
        }
        else{
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }
   
    return YES;
}


- (void)getUserInfo
{
    loadingView.hidden = NO;
    
    [SCFacebook getUserFQL:FQL_USER_STANDARD callBack:^(BOOL success, id result) {
        if (success) {
            loadingView.hidden = YES;
            self.FacebookUserInfo = result;
            [self Send:@"FB"];

        }
        else{
            loadingView.hidden = YES;
            NSLog(@"not success");
        }

    }];
}


-(IBAction)switchtoPicker:(id)sender{
    if (Switch.on)
        self.BirthDayPicker.hidden = NO;
    else{
        self.BirthDayPicker.hidden = YES;
        day = @"0";
        month = @"0";
        year = @"0";
    }
    [self.Login resignFirstResponder];
    [self.Email resignFirstResponder];
    [self.Password resignFirstResponder];
    [self.Confirm resignFirstResponder];
    
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)refreshButtonState
{
    if (![_vkontakte isAuthorized])
    {
        [_loginB setTitle:@"Login"
                 forState:UIControlStateNormal];
        // [self hideControls:YES];
    }
    else
    {
        [_loginB setTitle:@"Logout"
                 forState:UIControlStateNormal];
        [_vkontakte getUserInfo];
        
    }
}


- (IBAction)loginPressed:(id)sender
{
    if (![_vkontakte isAuthorized])
    {
         NSLog(@"111");
        [_vkontakte authenticate];
    }
    else
    {
        [_vkontakte logout];
    }
}


#pragma mark - VkontakteDelegate

- (void)vkontakteDidFailedWithError:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)showVkontakteAuthController:(UIViewController *)controller
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        controller.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    self.Parent = @"social";
    [self presentViewController:controller animated:YES completion:^{}];
}

- (void)vkontakteAuthControllerDidCancelled
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)vkontakteDidFinishLogin:(Vkontakte *)vkontakte
{
    

    [self dismissViewControllerAnimated:YES completion:^{}];
    [self refreshButtonState];
}

- (void)vkontakteDidFinishLogOut:(Vkontakte *)vkontakte
{
    [self refreshButtonState];
}

- (void)vkontakteDidFinishGettinUserInfo:(NSDictionary *)info
{
    // NSLog(@"%@", info);
    
    self.VkontakteUserInfo = info;
    [self Send:@"VK"];

}

- (void)vkontakteDidFinishPostingToWall:(NSDictionary *)responce
{
    // NSLog(@"%@", responce);
}


-(IBAction)SocialClicked:(UIButton *)sender{
    if (sender.tag == 0) {
        // NSLog(@"Fb");
        loadingView.hidden = NO;
        
        [SCFacebook loginCallBack:^(BOOL success, id result) {
            loadingView.hidden = YES;
            if (success) {
                [self getUserInfo];
                
              
            }
            else{
                MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                HUD.mode = MBProgressHUDModeCustomView;
                HUD.removeFromSuperViewOnHide = YES;
                HUD.customView = [InterfaceFunctions LabelHUDwithString:AMLocalizedString(@"Something goes wrong", nil)];
                HUD.delegate = self;
                [HUD show:YES];
                [HUD hide:YES afterDelay:2];
            }
        }];
        
        
    }
    if (sender.tag == 1) {
        [self loginPressed:sender];
    }
    if (sender.tag == 2) {
        self.Parent = @"Social";
        if (_engine) return;
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
        _engine.consumerKey = kOAuthConsumerKey;
        _engine.consumerSecret = kOAuthConsumerSecret;
        UIViewController			*controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
        if (controller){
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            [self presentViewController:controller animated:YES completion:^{[[UIApplication sharedApplication] endIgnoringInteractionEvents];}];
            
        }
    }
}



#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
    
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//=============================================================================================================================
#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
    self.twitterName = username;
    [self Send:@"TW"];
    
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	 NSLog(@"Authentication Failed!");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	 NSLog(@"Authentication Canceled.");
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	// NSLog(@"Request %@ succeeded", requestIdentifier);
    
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	// NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}

#pragma mark myFunctions
-(NSString *)HUDStringLocalized:(id)JSON{
    NSLog(@"HUDStringLocalized: %@",JSON);
    if ([[[JSON objectForKey:@"Error"]objectForKey:@"message"] isEqual:[NSNull null]] || [[[JSON objectForKey:@"Error"]objectForKey:@"message"] length] == 0) {
        return AMLocalizedString(@"Something goes wrong", nil);
    }
    return [[JSON objectForKey:@"Error"]objectForKey:@"message"];
}


-(NSDictionary * )POSTRequest:(NSString *)Way{
    NSDictionary *params;
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    CLLocation *Me = [locationManager location];
    NSLog(@"Me = %@", Me);
    NSString *lat = [NSString stringWithFormat:@"%f",Me.coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%f",Me.coordinate.longitude];
    NSLog(@"%@ %@",lat,lon);
    
    if ([Way isEqualToString:@"Self"]) {
        NSString *Birth_date = [[NSString alloc] initWithFormat:@"%@-%@-%@",day,month,year];
       params = [NSDictionary dictionaryWithObjectsAndKeys: Login.text ,@"name", Email.text,@"Email", Password.text ,@"Password",Birth_date,@"Birth_date",lat,@"Latitude",lon,@"Longitude",nil];
        NSLog(@"SELF Body = %@",params);
    }
    
    if ([Way isEqualToString:@"TW"]) {
        NSString *name = [NSString stringWithFormat:@"%@",self.twitterName];
        NSString *tmp = [[[[[[NSUserDefaults standardUserDefaults] objectForKey: @"authData"] componentsSeparatedByString:@"user_id="]objectAtIndex:1] componentsSeparatedByString:@"&"]objectAtIndex:0];
        NSString *uid = [NSString stringWithFormat:@"%@",tmp];
        NSString *password = [NSString stringWithFormat:@"%@password",uid];
        params = [NSDictionary dictionaryWithObjectsAndKeys: name ,@"name", uid,@"twitter_id", password ,@"Password",lat,@"lat",lon,@"lon",nil];
    }
    
    
    if ([Way isEqualToString:@"FB"]) {
        NSString *name = RemoveNull(@"name");
        NSString *remnull= RemoveNull(@"uid");
        NSString *uid = [[NSString  alloc] initWithFormat:@"%@",remnull];
        NSString *password = [NSString stringWithFormat:@"%@password",uid];
        NSString *Bday = RemoveNull(@"birthday_date")
        
        params = [NSDictionary dictionaryWithObjectsAndKeys: name ,@"name", uid,@"facebook_id", password ,@"Password", Bday,@"birth_date",lat,@"lat",lon,@"lon",nil];
        NSLog(@"Facebook body = %@",params);
    }

    
    if ([Way isEqualToString:@"VK"]) {
        NSString *name = [NSString stringWithFormat:@"%@ %@",[self.VkontakteUserInfo objectForKey:@"first_name"],[self.VkontakteUserInfo objectForKey:@"last_name"]];
        NSString *password = [NSString stringWithFormat:@"%@password",[self.VkontakteUserInfo objectForKey:@"uid"]];
        NSString *uid = [NSString stringWithFormat:@"%@",[self.VkontakteUserInfo objectForKey:@"uid"]];
        params = [NSDictionary dictionaryWithObjectsAndKeys: name ,@"name", uid,@"vkontakte_id", password ,@"Password",[self.VkontakteUserInfo objectForKey:@"bdate"],@"Birth_date",lat,@"lat",lon,@"lon",nil];
    }
//    NSLog(@"%@",params);
    return params;
}

-(void)Send:(NSString *)RegistrationWay{
    NSURL *baseURL = [NSURL URLWithString:@"http://www.likelik.net"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [httpClient defaultValueForHeader:@"Accept"];
    NSString *params = [NSString stringWithFormat:@"/api/v1/users?lang=%@",_lang];
    NSLog(@"%@",params);
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:params parameters:[self POSTRequest:RegistrationWay]];
    
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"Registered"];
        [[NSUserDefaults standardUserDefaults] setObject:RegistrationWay forKey:@"RegistrationWay"];
        [self.HUDfade hide:YES];
        
        [self.HUDdone show:YES];
        [self.HUDdone hide:YES afterDelay:1];
        
        [self.navigationController popViewControllerAnimated:YES];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSString *answer = [self HUDStringLocalized:JSON];
        [self.HUDfade hide:YES];
        
        self.HUDerror.customView = [InterfaceFunctions LabelHUDwithString:answer];
        
        [self.HUDerror show:YES];
        [self.HUDerror hide:YES afterDelay:2];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
    }];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [self.HUDfade show:YES];
    [operation start];
}


@end
