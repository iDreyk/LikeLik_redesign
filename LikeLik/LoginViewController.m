//
//  LoginViewController.m
//  TabBar
//
//  Created by Vladimir Malov on 15.04.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

#import "SA_OAuthTwitterEngine.h"
#import "SCFacebook.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#define kOAuthConsumerKey				@"XGaxa31EoympFhxLZooQ"
#define kOAuthConsumerSecret			@"IbUE5lud22evmrtxjtU1vKvh6VDqRMSHHFJ73rtHI"
#define afterregister             @"l27h7RU2dzVfP12aoQssda"

#define RemoveNull(field) ([[self.FacebookUserInfo objectForKey:field] isKindOfClass:[NSNull class]]) ? @"" : [self.FacebookUserInfo objectForKey:field];

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize Password,Email;
@synthesize Parent;
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
    array = @[@"E-Mail",@"Password"];
    self.navigationItem.titleView = [InterfaceFunctions NavLabelwithTitle:AMLocalizedString(@"Login", nil) AndColor:[InterfaceFunctions NavBarColor]];
    self.navigationItem.backBarButtonItem = [InterfaceFunctions back_button];
    
    [self.LoginTable setBackgroundColor:[UIColor clearColor]];
    //self.LoginTable.backgroundView = [InterfaceFunctions backgroundView];
    self.view.backgroundColor = [InterfaceFunctions BackgroundColor];
    self.LoginTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.LoginTable.backgroundColor = [UIColor clearColor];
    
    UIButton *btn = [InterfaceFunctions done_button];
    [btn addTarget:self action:@selector(Done) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self.SNetworkLabel setText: AMLocalizedString(@"You can go with the social network", nil)];
    [self.SNetworkLabel setFont:[AppDelegate OpenSansRegular:28]];
 
    _vkontakte = [Vkontakte sharedInstance];
    _vkontakte.delegate = self;
    [self refreshButtonState];

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

-(void)viewDidDisappear:(BOOL)animated{
    if ([self.Parent isEqualToString:@"Place"] == YES) {
        self.navigationController.navigationBar.hidden = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:afterregister
                                                            object:self];
        
        NSLog(@"Back to Place");
    }
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
    self.VkontakteUserInfo = info;
    [self Send:@"VK"];
}

- (void)vkontakteDidFinishPostingToWall:(NSDictionary *)responce
{

}




 

-(void)textFieldDidChange:(UITextField *)sender{
    if ([Email.text length]>0 &&[Password.text length]>0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

-(void)Done{
    [Email resignFirstResponder];
    [Password resignFirstResponder];
    if ([self validateMail:Email.text] == YES) {
        if ([self validateMail:Email.text] == YES)
            [self Send:@"Self"];
        
        else{
            [self.HUDemailcheck show:YES];
            [self.HUDemailcheck hide:YES afterDelay:2];
        }
    }
}

- (BOOL)validateMail : (NSString *)string
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

    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = nil;//@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
 
    if ([indexPath row] == 0) {
        
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
    if ([indexPath row] == 1) {
        Password = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 200, 35)];
        [Password addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        Password.delegate = self;
        Password.autocorrectionType = UITextAutocorrectionTypeNo;
        Password.tag=[indexPath row];
        Password.placeholder = AMLocalizedString(@"Password", nil);
        Password.secureTextEntry = YES;
        [cell.contentView addSubview:Password];
        Password.text = @"";
        Password.returnKeyType = UIReturnKeyDone;
    }
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_grad.png"]];
    cell.textLabel.text = AMLocalizedString([array objectAtIndex:[indexPath row]], nil);
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
}



-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ( [Email.text length]>0 &&[Password.text length]>0 ) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:Email]) {
        [Email resignFirstResponder];
        [Password becomeFirstResponder];
    }
    
    if ([textField isEqual:Password]) {
        [Password resignFirstResponder];
        if ( [Email.text length]>0 &&[Password.text length]>0 ) {
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
        //  NSLog(@"123");
        [self loginPressed:sender];
    }
    if (sender.tag == 2) {
        // NSLog(@"123");
        self.Parent = @"Social";
        if (_engine) return;
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
        _engine.consumerKey = kOAuthConsumerKey;
        _engine.consumerSecret = kOAuthConsumerSecret;
        
        UIViewController			*controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        if (controller){
            
            [self presentViewController:controller animated:YES completion:^{[[UIApplication sharedApplication] endIgnoringInteractionEvents];}];
            
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
    return [[JSON objectForKey:@"Error"] objectForKey:@"message"];
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
        params = [NSDictionary dictionaryWithObjectsAndKeys:  Email.text,@"Email", Password.text ,@"Password",lat,@"Latitude",lon,@"Longitude",nil];
        NSLog(@"Self = %@",params);
    }
    
    if ([Way isEqualToString:@"TW"]) {
        NSString *name = [NSString stringWithFormat:@"%@",self.twitterName];
        NSString *tmp = [[[[[[NSUserDefaults standardUserDefaults] objectForKey: @"authData"] componentsSeparatedByString:@"user_id="]objectAtIndex:1] componentsSeparatedByString:@"&"]objectAtIndex:0];
        NSString *uid = [NSString stringWithFormat:@"%@",tmp];
        NSString *password = [NSString stringWithFormat:@"%@password",uid];
        params = [NSDictionary dictionaryWithObjectsAndKeys: name ,@"name", uid,@"twitter_id", password ,@"Password",nil];
        NSLog(@"Way = %@",params);
    }
    
    
    if ([Way isEqualToString:@"FB"]) {
        
        NSString *remnull= RemoveNull(@"uid");
        NSString *uid = [[NSString  alloc] initWithFormat:@"%@",remnull];
        NSString *password = [NSString stringWithFormat:@"%@password",uid];
        params = [NSDictionary dictionaryWithObjectsAndKeys:  uid,@"facebook_id", password ,@"Password",lat,@"Latitude",lon,@"Longitude",nil];
        NSLog(@"Fb = %@",params);
        
    }
    if ([Way isEqualToString:@"VK"]) {
        NSString *password = [NSString stringWithFormat:@"%@password",[self.VkontakteUserInfo objectForKey:@"uid"]];
        NSString *uid = [NSString stringWithFormat:@"%@",[self.VkontakteUserInfo objectForKey:@"uid"]];
        params = [NSDictionary dictionaryWithObjectsAndKeys: uid,@"vkontakte_id", password ,@"Password",lat,@"Latitude",lon,@"Longitude",nil];
        NSLog(@"VK = %@",params);
    }

    return params;
}

-(void)Send:(NSString *)RegistrationWay{
    NSURL *baseURL = [NSURL URLWithString:@"http://www.likelik.net"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [httpClient defaultValueForHeader:@"Accept"];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"/api/v1/users/login" parameters:[self POSTRequest:RegistrationWay]];
    
    
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
