//
//  ExternalFunctions.m
//  TabBar
//
//  Created by Андрей Шелудченко on 18.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "ExternalFunctions.h"
#import "SSZipArchive.h"

#define IS_IPHONE_5 ( [ [ UIScreen mainScreen ] bounds ].size.height == 568 )
#define closestPlacesCount 8
#define regionsCount 8
#define closestPlaceDistance 10000000.0
#define shopping @"Shopping"
#define entertainment @"Entertainment"
#define sport @"Health & Beauty"
#define restaurants @"Restaurants"
#define catalogue @"Catalogues"
#define likelikurl @"http://likelik.net/docs/"

#define range 10
#define rest @"Restaurants"
#define night @"NightLife"
#define shop @"Shopping"
#define cult @"Culture"
#define leisure @"Leisure"
#define beauty @"Beauty"
#define hotels @"Hotels"


@implementation ExternalFunctions


static CLLocation *Me;

+ (void) DownloadController : (NSString *) catalogueName{
    
    [self AFdownload : catalogueName];
    
}

+ (void) AFdownload : (NSString *) filename{
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@",likelikurl,filename];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:filename];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully downloaded file to %@", path);
        [self DownloadSucceeded:filename];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        NSLog(@"Error occured");
        [self DownloadError:error.description];
    }];
    
    [operation start];
    
    //Setup Upload block to return progress of file upload
    [operation setDownloadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToRead) { float progress = totalBytesWritten / (float)totalBytesExpectedToRead;
        NSLog(@"Download Percentage: %f %%", progress*100);
    }];
    
}

+ (void) DownloadSucceeded:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    [self unzipFileAt:path ToDestination:[paths objectAtIndex:0]];
    NSString *crapPath = [[self docDir]stringByAppendingPathComponent:@"__MACOSX"];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:crapPath error:nil];
}

+ (NSString *) DownloadError:(NSString *)error{
    NSLog(@"error = %@",error);
    return error;
}






+ (NSString *)docDir{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
}




+ (NSArray *)arrayOfDictionatySort : (NSMutableArray *) placesArray {
    
    NSSortDescriptor *aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Distance" ascending:YES];
    [placesArray sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
    
    return placesArray;
}

+ (NSString *)getAboutText {
    NSString *cataloguesPath = [[NSBundle mainBundle]pathForResource:@"appData" ofType:@"plist"];
    NSMutableDictionary *catalogues = [[NSMutableDictionary alloc]initWithContentsOfFile:cataloguesPath];
    NSString *language = [self getLanguage];
    NSString *aboutLanguage;
    
    if ([language isEqualToString:@"ru"]) {
        aboutLanguage = @"About_RU";
    }
    else if ([language isEqualToString:@"de"]){
        aboutLanguage = @"About_DE";
    }
    else
        aboutLanguage = @"About_EN";
    
    return [catalogues objectForKey:aboutLanguage];
}

+ (NSString *)getTermsOfUseText {
    NSString *cataloguesPath = [[NSBundle mainBundle]pathForResource:@"appData" ofType:@"plist"];
    NSMutableDictionary *catalogues = [[NSMutableDictionary alloc]initWithContentsOfFile:cataloguesPath];
    NSString *language = [self getLanguage];
    NSString *termsOfUseLanguage;
    
    if ([language isEqualToString:@"ru"]) {
        termsOfUseLanguage = @"termsofuse_RU";
    }
    else if ([language isEqualToString:@"de"]){
        termsOfUseLanguage = @"termsofuse_DE";
    }
    else
        termsOfUseLanguage = @"termofuse_EN";
    
    return [catalogues objectForKey:termsOfUseLanguage];
}

+ (NSString *)getPracticalInfoForCity:(NSString *) city{
    NSDictionary *cityCatalogue = [self cityCatalogueForCity:city];
    NSString *language = [self getLanguage];
    NSString *practicalInfoLanguage;
    
    if ([language isEqualToString:@"ru"]) {
        practicalInfoLanguage = @"About_RU";
    }
    else if ([language isEqualToString:@"de"]){
        practicalInfoLanguage = @"About_DE";
    }
    else
        practicalInfoLanguage = @"About_EN";

    return [cityCatalogue objectForKey:practicalInfoLanguage];
}

+ (NSString *) getLocalizedString : (NSString *) string{
    NSString *lang = [self getLanguage];
    if ([lang isEqualToString:@"de"]) {
        return [[NSString alloc] initWithFormat:@"%@_DE",string];
    }
    else if ([lang isEqualToString:@"ru"]) {
        return [[NSString alloc] initWithFormat:@"%@_RU",string];
    }
    else
        return [[NSString alloc] initWithFormat:@"%@_EN",string];
}

+ (NSString *) getIphoneString{
    if(IS_IPHONE_5 == 1){
        return @"5";
    }
    else
        return @"4";
}


+ (void) getReady {
    NSString *cataloguesPath = [[self docDir]stringByAppendingPathComponent:@"catalogue.plist"];
    [[NSFileManager defaultManager]copyItemAtPath:[[NSBundle mainBundle]pathForResource:@"catalogue" ofType:@"plist"] toPath:cataloguesPath error:nil];
    
    NSString *cataloguesPath1 = [[self docDir]stringByAppendingPathComponent:@"Moscow"];
    [[NSFileManager defaultManager]copyItemAtPath:[[NSBundle mainBundle]pathForResource:@"Moscow" ofType:@""] toPath:cataloguesPath1 error:nil];
    
    NSString *cataloguesPath2 = [[self docDir]stringByAppendingPathComponent:@"Vienna"];
    [[NSFileManager defaultManager]copyItemAtPath:[[NSBundle mainBundle]pathForResource:@"Vienna" ofType:@""] toPath:cataloguesPath2 error:nil];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *catalogueArray = [[NSArray alloc]initWithContentsOfFile:cataloguesPath];
    [defaults setObject:catalogueArray forKey:catalogue];
}

+ (CLLocation *) getMyLocationOrTheLocationOfCityCenter : (NSString *) city{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    Me = [locationManager location];
    if (Me == NULL) {
        NSDictionary *cityDict = [self cityCatalogueForCity:city];
        Me = [[CLLocation alloc] initWithLatitude:[[cityDict objectForKey:@"lat"] doubleValue] longitude:[[cityDict objectForKey:@"lon"] doubleValue]];
    }
    
    [locationManager stopUpdatingLocation];
    locationManager = nil;
    
    return Me;
}

+ (NSArray *) getArrayOfPlaceDictionariesInCategory : (NSString *) category InCity : (NSString *) city{
    NSDictionary *cityDict = [self cityCatalogueForCity:city];
    NSMutableDictionary *placeDict;
    NSArray *tempArrayOfPlacesIncategory = [[cityDict objectForKey:@"places"] objectForKey:category];
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSString *version = [self getIphoneString];
    double lat,lon;
    
    int placesCount = [tempArrayOfPlacesIncategory count];
    
    for (int i = 0; i < placesCount; i++) {
        placeDict = [[NSMutableDictionary alloc]init];
        
        lat = [[[tempArrayOfPlacesIncategory objectAtIndex:i] objectForKey:@"Lat"] doubleValue];
        lon = [[[tempArrayOfPlacesIncategory objectAtIndex:i] objectForKey:@"Lon"] doubleValue];
        CLLocation *currentPlace = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        CLLocation *location = [self getMyLocationOrTheLocationOfCityCenter:city];
        photos = [[NSMutableArray alloc] init];
        for (int j = 0; j < [[[[tempArrayOfPlacesIncategory objectAtIndex:i] objectForKey:@"Photo"] objectForKey:version] count]; j++) {
            [photos addObject:[[NSString alloc] initWithFormat:@"%@/%@/%@",[self docDir],[cityDict objectForKey:@"city_EN"],[[[[tempArrayOfPlacesIncategory objectAtIndex:i] objectForKey:@"Photo"] objectForKey:version] objectAtIndex:j]]];
        }
        
        double distance = [location distanceFromLocation:currentPlace];
        [placeDict setValue:[[tempArrayOfPlacesIncategory objectAtIndex:i] objectForKey:[self getLocalizedString:@"Name"]] forKey:@"Name"];
        [placeDict setValue:[[tempArrayOfPlacesIncategory objectAtIndex:i] objectForKey:[self getLocalizedString:@"About"]] forKey:@"About"];
        [placeDict setValue:[[tempArrayOfPlacesIncategory objectAtIndex:i] objectForKey:[self getLocalizedString:@"address"]] forKey:@"Address"];
        [placeDict setValue:[[tempArrayOfPlacesIncategory objectAtIndex:i] objectForKey:[self getLocalizedString:@"time"]] forKey:@"Time"];
        [placeDict setValue:[[tempArrayOfPlacesIncategory objectAtIndex:i] objectForKey:[self getLocalizedString:@"metro"]] forKey:@"Metro"];
        [placeDict setValue:[[tempArrayOfPlacesIncategory objectAtIndex:i] objectForKey:@"Telephone"] forKey:@"Telephone"];
        [placeDict setValue:[[tempArrayOfPlacesIncategory objectAtIndex:i] objectForKey:@"web"] forKey:@"Web"];
        [placeDict setValue:[NSNumber numberWithDouble:distance] forKey:@"Distance"];
        [placeDict setValue:currentPlace forKey:@"Location"];
        [placeDict setValue:category forKey:@"Category"];
        [placeDict setValue:photos forKey:@"Photo"];        
        [placeDict setValue:city forKey:@"City"];
        [placeDict setValue:[[tempArrayOfPlacesIncategory objectAtIndex:i] objectForKey:@"favourite"] forKey:@"Favorite"];
        
        [returnArray addObject:placeDict];
    }
    
    return [self arrayOfDictionatySort:returnArray];
}

+ (NSArray *) getAllPlacesInCity:(NSString *)city{
    NSMutableArray *arrayOfPlaces = [[NSMutableArray alloc] init];
    
    if ([self getArrayOfPlaceDictionariesInCategory:beauty InCity:city] != NULL) {
        [arrayOfPlaces addObjectsFromArray:[self getArrayOfPlaceDictionariesInCategory:beauty InCity:city]];
    }
    if ([self getArrayOfPlaceDictionariesInCategory:rest InCity:city] != NULL) {
        [arrayOfPlaces addObjectsFromArray:[self getArrayOfPlaceDictionariesInCategory:rest InCity:city]];
    }
    if ([self getArrayOfPlaceDictionariesInCategory:night InCity:city] != NULL) {
        [arrayOfPlaces addObjectsFromArray:[self getArrayOfPlaceDictionariesInCategory:night InCity:city]];
    }
    if ([self getArrayOfPlaceDictionariesInCategory:shop InCity:city] != NULL) {
        [arrayOfPlaces addObjectsFromArray:[self getArrayOfPlaceDictionariesInCategory:shop InCity:city]];
    }
    if ([self getArrayOfPlaceDictionariesInCategory:cult InCity:city] != NULL) {
        [arrayOfPlaces addObjectsFromArray:[self getArrayOfPlaceDictionariesInCategory:cult InCity:city]];
    }
    if ([self getArrayOfPlaceDictionariesInCategory:leisure InCity:city] != NULL) {
        [arrayOfPlaces addObjectsFromArray:[self getArrayOfPlaceDictionariesInCategory:leisure InCity:city]];
    }
    if ([self getArrayOfPlaceDictionariesInCategory:hotels InCity:city] != NULL) {
        [arrayOfPlaces addObjectsFromArray:[self getArrayOfPlaceDictionariesInCategory:hotels InCity:city]];
    }
    
    return [self arrayOfDictionatySort:arrayOfPlaces];
}




//
//  работа со скачиванием
//
//  проверка на скаченность
+ (BOOL) isDownloaded : (NSString *) city {
    NSDictionary *cityDict = [self cityCatalogueForCity:city];
    
    if ([[cityDict objectForKey:@"downloaded"] isEqualToString:@"1"]) {
        return YES;
    }
    else
        return NO;
}
//  добавить в скаченные
+ (void) addCityToDownloaded : (NSString *) city {
    NSString *cataloguesPath = [[self docDir]stringByAppendingPathComponent:@"catalogue.plist"];
    NSMutableArray *newCatalogues = [[NSMutableArray alloc]initWithContentsOfFile:cataloguesPath];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *catalogues = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:catalogue]];
    
    for (int i = 0; i<[catalogues count]; i++) {
        if ([[[catalogues objectAtIndex:i]objectForKey:@"city_RU"]isEqualToString:city] || [[[catalogues objectAtIndex:i]objectForKey:@"city_DE"]isEqualToString:city] || [[[catalogues objectAtIndex:i]objectForKey:@"city_EN"]isEqualToString:city]) {
            
            [[newCatalogues objectAtIndex:i] setValue:@"1" forKeyPath:@"downloaded"];
            
            [newCatalogues writeToFile:cataloguesPath atomically:YES];
            
            [defaults setObject:newCatalogues forKey:catalogue];

        }
    }
}
//  скачать каталог города
+ (void) downloadCatalogue:(NSString *)catalogueOfCity {
    NSLog(@"in download");
    // Create a URL Request and set the URL
    NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://likelik.net/docs/Archivetest.zip"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // Display the network activity indicator
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // Perform the request on a new thread so we don't block the UI
    dispatch_queue_t downloadQueue = dispatch_queue_create("Download queue", NULL);
    dispatch_sync(downloadQueue, ^{
        
        NSError* err = nil;
        NSHTTPURLResponse* rsp = nil;
        
        // Perform the request synchronously on this thread
        NSLog(@"Start download");
        NSData *rspData = [NSURLConnection sendSynchronousRequest:request returningResponse:&rsp error:&err];
        NSLog(@"%d",[rspData length]);
        NSLog(@"Downloaded");
        // Once a response is received, handle it on the main thread in case we do any UI updates
        dispatch_async(dispatch_get_main_queue(), ^{
            // Hide the network activity indicator
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            if (rspData == nil || (err != nil && [err code] != noErr)) {
                // If there was a no data received, or an error...
                NSLog(@"ОШИБКА!!!");
            } else {
                // Cache the file in the cache directory
                NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                NSString* path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Archive.zip"];
                NSString *crapPath = [[self docDir]stringByAppendingPathComponent:@"__MACOSX"];
                
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                [rspData writeToFile:path atomically:YES];
                
                NSString *cataloguesPath = [self docDir];
                
                //[[NSFileManager defaultManager] removeItemAtPath:cataloguesPath error:nil];
                [self unzipFileAt:path ToDestination:cataloguesPath];
                
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                [[NSFileManager defaultManager] removeItemAtPath:crapPath error:nil];
                // Do whatever else you want with the data...
                
                
            }
        });
    });
}

+ (void) unzipFileAt:(NSString *)filePath ToDestination:(NSString *)fileDestination{
    // Unzipping
    NSLog(@"Unzipping");
    NSString *zipPath = filePath;
    NSString *destinationPath = fileDestination;
    [SSZipArchive unzipFileAtPath:zipPath toDestination:destinationPath];
    NSLog(@"Unzipped");
}

//
//  такси
//
//  получить данные по такси
+ (NSArray *) getTaxiInformationInCity:(NSString *)city {
    NSDictionary *cityCatalogue = [self cityCatalogueForCity:city];
    NSArray *taxisArray = [[cityCatalogue objectForKey:@"transport"] objectForKey:@"taxi"];
    NSString *language = [self getLanguage];
    NSString *nameLang;
    NSString *aboutLang;
    NSMutableDictionary *taxiDict;
    NSMutableArray *arrayOfTaxiDicts = [[NSMutableArray alloc] init];
    NSMutableArray *newArray;
    
    if ([language isEqualToString:@"ru"]) {
        nameLang = @"Name_RU";
        aboutLang = @"About_RU";
    }
    else if ([language isEqualToString:@"de"]) {
        nameLang = @"Name_DE";
        aboutLang = @"About_DE";
    }
    else {
        nameLang = @"Name_EN";
        aboutLang = @"About_EN";
    }
    
    for (int i = 0; i < [taxisArray count]; i++) {
        taxiDict  = [[NSMutableDictionary alloc] init];
        [taxiDict setObject:[[taxisArray objectAtIndex:i] objectForKey:nameLang] forKey:@"name"];
        [taxiDict setObject:[[taxisArray objectAtIndex:i] objectForKey:aboutLang] forKey:@"about"];
        [taxiDict setObject:[[taxisArray objectAtIndex:i] objectForKey:@"Telephone"] forKey:@"telephone"];
        [taxiDict setObject:[[taxisArray objectAtIndex:i] objectForKey:@"web"] forKey:@"web"];
        newArray = [[NSMutableArray alloc] init];
        for (int j = 0; j < [[[taxisArray objectAtIndex:i] objectForKey:@"photo"] count]; j++) {
            [newArray addObject:[[NSString alloc]initWithFormat:@"%@/%@/%@",[self docDir],[[self cityCatalogueForCity:city] objectForKey:@"city_EN"],[[[taxisArray objectAtIndex:i] objectForKey:@"photo"] objectAtIndex:j]]];
        }
        
        [taxiDict setObject:newArray forKey:@"photo"];

        [arrayOfTaxiDicts addObject:taxiDict];
    }

    return arrayOfTaxiDicts;
}




//
//  локальные уведомления
//
//  полчить место по региону
+ (NSDictionary *) getPlaceByCLRegion:(CLRegion *)region{
    CLLocationCoordinate2D tempLocation = region.center;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:tempLocation.latitude longitude:tempLocation.longitude];
    NSString *city = [[self allPlacesInCityWithCloseToLocation:location] objectForKey:@"name"];
    NSArray *closestPlaces = [[self getAllPlacesInCity:city] subarrayWithRange:NSMakeRange(0, 3)];
    CLLocation *placeLocation;

    for (int i = 0; i < 3; i++) {
        placeLocation = [[closestPlaces objectAtIndex:i] objectForKey:@"Location"];
        if (
            [region.identifier isEqualToString:[[closestPlaces objectAtIndex:i] objectForKey:@"Name"]] &&
            region.center.longitude == placeLocation.coordinate.longitude &&
            region.center.latitude == placeLocation.coordinate.latitude
            ) {
            
            return [closestPlaces objectAtIndex:i];
        }
    }
    
    return NULL;
}
//  получить массив с регионами
+ (NSArray *) getAllRegionsAroundMyLocation : (CLLocation *) location{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    CLLocationCoordinate2D placeLatLong;
    CLRegion *place;
    CLLocation *location1;
    
    NSString *city = [[self allPlacesInCityWithCloseToLocation:location] objectForKey:@"name"];
    NSArray *arrayOfPlacesInCity = [[self getAllPlacesInCity:city] subarrayWithRange:NSMakeRange(0, regionsCount)];
    
    for (int i = 0; i < [arrayOfPlacesInCity count]; i++) {
        location1 = [[arrayOfPlacesInCity objectAtIndex:i] objectForKey:@"Location"];
        placeLatLong = location1.coordinate;
        
        place = [[CLRegion alloc]
                 initCircularRegionWithCenter:placeLatLong
                 radius:range
                 identifier:[[arrayOfPlacesInCity objectAtIndex:i] objectForKey:@"Name"]];
        
        [returnArray addObject:place];
    }
    
    return returnArray;
}

//
//  карта города
//
//  получить координаты города
+ (CLLocation *) getCenterCoordinatesOfCity:(NSString *)city {
    NSDictionary *cityDictionary = [self cityCatalogueForCity:city];
    CLLocation *coordinate = [[CLLocation alloc] initWithLatitude:[[cityDictionary objectForKey:@"lat"] doubleValue] longitude:[[cityDictionary objectForKey:@"lon"] doubleValue]];
    
    return coordinate;
}

//
//  city Info
//
//  карта метро города
+ (NSArray *) getMetroMapInCity:(NSString *)city{
    NSDictionary *cityDictionary = [self cityCatalogueForCity:city];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [[[cityDictionary objectForKey:@"transport"] objectForKey:@"metro"] count]; i++) {
        [array addObject:[[NSString alloc]initWithFormat:@"%@/%@/%@",[self docDir],[cityDictionary objectForKey:@"city_EN"],[[[cityDictionary objectForKey:@"transport"] objectForKey:@"metro"] objectAtIndex:i]]];
    }
    
    return array;
}


//
//  favourites
//
//  добавить в favourites
+ (BOOL) addToFavouritesPlace: (NSString *) placeName InCategory : (NSString *) category InCity : (NSString *) city{
    NSString *cataloguesPath = [[self docDir]stringByAppendingPathComponent:@"catalogue.plist"];
    NSMutableArray *newCatalogues = [[NSMutableArray alloc]initWithContentsOfFile:cataloguesPath];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *catalogues = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:catalogue]];
    
    for (int i = 0; i<[catalogues count]; i++) {
        if ([[[catalogues objectAtIndex:i]objectForKey:@"city_RU"]isEqualToString:city] || [[[catalogues objectAtIndex:i]objectForKey:@"city_DE"]isEqualToString:city] || [[[catalogues objectAtIndex:i]objectForKey:@"city_EN"]isEqualToString:city]) {
            for (int j = 0; j<[[[[catalogues objectAtIndex:i] objectForKey:@"places"] objectForKey:category] count]; j++) {
                if ([[[[[[catalogues objectAtIndex:i] objectForKey:@"places"] objectForKey:category] objectAtIndex:j]objectForKey:@"Name_RU"] isEqualToString:placeName] || [[[[[[catalogues objectAtIndex:i] objectForKey:@"places"] objectForKey:category] objectAtIndex:j]objectForKey:@"Name_EN"] isEqualToString:placeName] || [[[[[[catalogues objectAtIndex:i] objectForKey:@"places"] objectForKey:category] objectAtIndex:j]objectForKey:@"Name_DE"] isEqualToString:placeName]) {
                    if ( [[[[[[catalogues objectAtIndex:i] objectForKey:@"places"] objectForKey:category] objectAtIndex:j]objectForKey:@"favourite"] isEqualToString:@"1"]) {
                        return NO;
                    }
                    else
                    {
                        
                        [[[[[newCatalogues objectAtIndex:i] objectForKey:@"places"] objectForKey:category] objectAtIndex:j] setValue:@"1" forKeyPath:@"favourite"];
                        
                        [newCatalogues writeToFile:cataloguesPath atomically:YES];
                        
                        [defaults setObject:newCatalogues forKey:catalogue];
                        
                        return YES;
                    }
                }
            }
        }
    }
    return NO;
}
//  вывести список мест который в favourites
+ (NSArray *) getAllFavouritePlacesInCity : (NSString *) city{
    NSMutableArray *arrayOfFavouritePlaces = [[NSMutableArray alloc] init];
    NSArray *arrayofPlacesInCity;
    
    arrayofPlacesInCity = [self getAllPlacesInCity:city];
    
    for (int i = 0; i < [arrayofPlacesInCity count]; i++) {
        if ([[[arrayofPlacesInCity objectAtIndex:i] objectForKey:@"Favorite"] isEqualToString:@"1"]) {
            [arrayOfFavouritePlaces addObject:[arrayofPlacesInCity objectAtIndex:i]];
        }
    }
    
    return  arrayOfFavouritePlaces;
}
//  удаление места из favorites
+ (BOOL) removeFromFavoritesPlace:(NSString *)placeName InCategory:(NSString *)category InCity:(NSString *)city{
    NSString *cataloguesPath = [[self docDir]stringByAppendingPathComponent:@"catalogue.plist"];
    NSMutableArray *newCatalogues = [[NSMutableArray alloc]initWithContentsOfFile:cataloguesPath];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *catalogues = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:catalogue]];
    
    for (int i = 0; i<[catalogues count]; i++) {
        if ([[[catalogues objectAtIndex:i]objectForKey:@"city_RU"]isEqualToString:city] || [[[catalogues objectAtIndex:i]objectForKey:@"city_DE"]isEqualToString:city] || [[[catalogues objectAtIndex:i]objectForKey:@"city_EN"]isEqualToString:city]) {
            for (int j = 0; j<[[[[catalogues objectAtIndex:i] objectForKey:@"places"] objectForKey:category] count]; j++) {
                if ([[[[[[catalogues objectAtIndex:i] objectForKey:@"places"] objectForKey:category] objectAtIndex:j]objectForKey:@"Name_RU"] isEqualToString:placeName] || [[[[[[catalogues objectAtIndex:i] objectForKey:@"places"] objectForKey:category] objectAtIndex:j]objectForKey:@"Name_EN"] isEqualToString:placeName] || [[[[[[catalogues objectAtIndex:i] objectForKey:@"places"] objectForKey:category] objectAtIndex:j]objectForKey:@"Name_DE"] isEqualToString:placeName]) {
                    
                    [[[[[newCatalogues objectAtIndex:i] objectForKey:@"places"] objectForKey:category] objectAtIndex:j] setValue:@"" forKeyPath:@"favourite"];
                        
                    [newCatalogues writeToFile:cataloguesPath atomically:YES];
                    [defaults setObject:newCatalogues forKey:catalogue];
                        
                    return YES;
                }
            }
        }
    }
    return NO;
}
//  проверка на добавленность
+ (BOOL)isFavorite : (NSString *) placeName InCity : (NSString *) city InCategory:(NSString *)category{
    NSDictionary *placeDict = [self selectedPalceInCity:city category:category withName:placeName];
    
    if ([[placeDict objectForKey:@"favourite"] isEqualToString:@"1"]) {
        return YES;
    }
    else
        return NO;
}

//
//  использование чека LikElik
//
//  проверка на совпадение
+ (BOOL) isTheRightQRCodeOfPlace: (NSString *) placeName InCategory : (NSString *) category InCity : (NSString *) city WithCode : (NSString *) code {
    NSMutableDictionary *placeDictionary = [[NSMutableDictionary alloc]initWithDictionary:[self selectedPalceInCity:city category:category withName:placeName]];
    NSString *cataloguesPath = [[self docDir]stringByAppendingPathComponent:@"catalogues1.plist"];
    NSMutableArray *newCatalogues = [[NSMutableArray alloc]initWithContentsOfFile:cataloguesPath];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *catalogues = [defaults objectForKey:catalogue];
    NSString *placeCode = [placeDictionary objectForKey:@"uuid"];
    
    
    if ([placeCode isEqualToString:code]) {

        for (int i = 0; i<[catalogues count]; i++) {
            if ([[[catalogues objectAtIndex:i]objectForKey:@"city_RU"]isEqualToString:city] || [[[catalogues objectAtIndex:i]objectForKey:@"city_DE"]isEqualToString:city] || [[[catalogues objectAtIndex:i]objectForKey:@"city_EN"]isEqualToString:city]) {
                for (int j = 0; j<[[[[catalogues objectAtIndex:i] objectForKey:@"places"] objectForKey:category] count]; j++) {
                    if ([[[[[[catalogues objectAtIndex:i] objectForKey:@"places"] objectForKey:category] objectAtIndex:j]objectForKey:@"Name_RU"] isEqualToString:placeName] || [[[[[[catalogues objectAtIndex:i] objectForKey:@"places"] objectForKey:category] objectAtIndex:j]objectForKey:@"Name_EN"] isEqualToString:placeName] || [[[[[[catalogues objectAtIndex:i] objectForKey:@"places"] objectForKey:category] objectAtIndex:j]objectForKey:@"Name_DE"] isEqualToString:placeName]) {
                        
                        [[[[[newCatalogues objectAtIndex:i] objectForKey:@"places"] objectForKey:category] objectAtIndex:j] setValue:@"1" forKeyPath:@"CheckUsed"];

                        [newCatalogues writeToFile:cataloguesPath atomically:YES];
                        [defaults setObject:newCatalogues forKey:catalogue];
                    }
                }
            
            }
        }
        return YES;
    }
    else
        return NO;
}
//  использован ли чек
+ (BOOL) isCheckUsedInPlace:(NSString *)placeName InCategory:(NSString *)category InCity:(NSString *)city {
    NSDictionary *placeDictionary = [self selectedPalceInCity:city category:category withName:placeName];
    if ([[placeDictionary objectForKey:@"CheckUsed"] isEqualToString:@"1"]) {
        return YES;
    }
    else
        return NO;
}
//  информация с чек LikeLik
+ (NSDictionary *) getCheckDictionariesOfPlace:(NSString *)placeName InCategory:(NSString *)category InCity:(NSString *)city {
    NSDictionary *placeDictionary = [self selectedPalceInCity:city category:category withName:placeName];
    NSDictionary *cityDictionary = [self cityCatalogueForCity:city];
    NSString *language1 = [self getLanguage];
    NSString *language2;
    NSString *checkLanguageFromSystem;
    NSString *checkLanguageFromCountry;
    NSString *mainDisplayTextString;
    NSString *secondaryDisplayTextString;
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc] init];
    
    language2 = [cityDictionary objectForKey:@"country"];
    
    if ([language2 isEqualToString:@"ru_RU"]) {
        language2 = @"ru";
    }
    else if ([language2 isEqualToString:@"de_AT"]){
        language2 = @"de";
    }
    else
        language2 = @"en";
    
    if ([language1 isEqualToString:language2] && ![language1 isEqualToString:@"de"]) {
        checkLanguageFromSystem = @"ru";
        checkLanguageFromCountry = @"de";
    }
    else if ([language1 isEqualToString:language2] && [language1 isEqualToString:@"de"]){
        checkLanguageFromSystem = language1;
        checkLanguageFromCountry = @"ru";
    }
    else if (![language1 isEqualToString:language2]){
        checkLanguageFromSystem = @"de";
        checkLanguageFromCountry = @"ru";
    }
    
    if ([checkLanguageFromCountry isEqualToString:@"ru"]) {
        checkLanguageFromCountry = @"checkText_RU";
        mainDisplayTextString = @"Показать текст на местном яызке";
    }
    else if ([checkLanguageFromCountry isEqualToString:@"de"]) {
        checkLanguageFromCountry = @"checkText_DE";
        mainDisplayTextString = @"Text in der Landessprache zeigen";
    }
    else {
        checkLanguageFromCountry = @"checkText_EN";
        mainDisplayTextString = @"Display text in local language";
    }
    
    if ([checkLanguageFromSystem isEqualToString:@"ru"]) {
        checkLanguageFromSystem = @"checkText_RU";
        secondaryDisplayTextString = @"Показать текст на местном яызке";
    }
    else if ([checkLanguageFromSystem isEqualToString:@"de"]) {
        checkLanguageFromSystem = @"checkText_DE";
        secondaryDisplayTextString = @"Text in der Landessprache zeigen";
    }
    else {
        checkLanguageFromSystem = @"checkText_EN";
        secondaryDisplayTextString = @"Display text in local language";
    }
    
    [returnDictionary setObject:[placeDictionary objectForKey:checkLanguageFromSystem] forKey:@"main"];
    [returnDictionary setObject:[placeDictionary objectForKey:checkLanguageFromCountry] forKey:@"secondary"];
    [returnDictionary setObject:mainDisplayTextString forKey:@"mainDisplayButton"];
    [returnDictionary setObject:secondaryDisplayTextString forKey:@"secondaryDisplayButton"];
    
    return returnDictionary;
}
//  обнуление использованных чеков
+ (void) makeAllChecksUnused{
    NSString *cataloguesPath = [[self docDir]stringByAppendingPathComponent:@"catalogues1.plist"];
    NSMutableArray *newCatalogues = [[NSMutableArray alloc]initWithContentsOfFile:cataloguesPath];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *catalogues = [defaults objectForKey:catalogue];
    
    for (int i = 0; i < [catalogues count]; i++) {
        for (int j = 0; j < [[[[catalogues objectAtIndex:i] objectForKey:@"places"] objectForKey:shopping] count]; j++) {
            [[[[[newCatalogues objectAtIndex:i] objectForKey:@"places"] objectForKey:shopping] objectAtIndex:j] setObject:@"0" forKey:@"CheckUsed"];
        }
        for (int j = 0; j < [[[[catalogues objectAtIndex:i] objectForKey:@"places"] objectForKey:entertainment] count]; j++) {
            [[[[[newCatalogues objectAtIndex:i] objectForKey:@"places"] objectForKey:entertainment] objectAtIndex:j] setObject:@"0" forKey:@"CheckUsed"];
        }
        for (int j = 0; j < [[[[catalogues objectAtIndex:i] objectForKey:@"places"] objectForKey:sport] count]; j++) {
            [[[[[newCatalogues objectAtIndex:i] objectForKey:@"places"] objectForKey:sport] objectAtIndex:j] setObject:@"0" forKey:@"CheckUsed"];
        }
        for (int j = 0; j < [[[[catalogues objectAtIndex:i] objectForKey:@"places"] objectForKey:restaurants] count]; j++) {
            [[[[[newCatalogues objectAtIndex:i] objectForKey:@"places"] objectForKey:restaurants] objectAtIndex:j] setObject:@"0" forKey:@"CheckUsed"];
        }
    }
    
    [newCatalogues writeToFile:cataloguesPath atomically:YES];
    [defaults setObject:newCatalogues forKey:catalogue];
}

//
//  CLLocation functions
//
+ (CLLocation *) getPlaceCoordinatesInCity:(NSString *) city InCategory : (NSString *) category WithName : (NSString *) placeName{
    NSDictionary *place = [self selectedPalceInCity:city category:category withName:placeName];
    CLLocation *coordinate;
    
    coordinate = [[CLLocation alloc] initWithLatitude:[[place objectForKey:@"Lat"] doubleValue] longitude:[[place objectForKey:@"Lon"] doubleValue]];
    
    return coordinate;
}


//
//  "плашки" города
//
//  узкая заставка города
+ (NSString *) smallPictureOfCity : (NSString *) city{
    NSDictionary *City = [self cityCatalogueForCity:city];
    
    return [[NSString alloc]initWithFormat:@"%@/%@/%@",[self docDir],[City objectForKey:@"city_EN"],[[City objectForKey:@"photos"] objectForKey:@"small"]];
}
//  широкая заставка города
+ (NSString *) larkePictureOfCity : (NSString *) city{
    NSDictionary *City = [self cityCatalogueForCity:city];
    
    return [[NSString alloc]initWithFormat:@"%@/%@/%@",[self docDir],[City objectForKey:@"city_EN"],[[City objectForKey:@"photos"] objectForKey:@"large"]];
}

//
//  Place
//
//  всё вместе о месте
+ (NSDictionary *) placeDictionaryInCity:(NSString *)city InCategory:(NSString *)category withName:(NSString *)placeName{
    NSDictionary *placeDictionary = [self selectedPalceInCity:city category:category withName:placeName];
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc] init];
    NSString *language = [self getLanguage];
    NSString *infoLang;
    
    if ([language isEqualToString:@"ru"]) {
        infoLang = @"About_RU";
    }
    else if ([language isEqualToString:@"de"]){
        infoLang = @"About_DE";
    }
    else
        infoLang = @"About_EN";

    [returnDictionary setObject:[placeDictionary objectForKey:infoLang] forKey:@"about"];
    [returnDictionary setObject:[placeDictionary objectForKey:@"address"] forKey:@"address"];
    [returnDictionary setObject:[placeDictionary objectForKey:@"web"] forKey:@"web"];
    [returnDictionary setObject:[placeDictionary objectForKey:@"Telephone"] forKey:@"Telephone"];
    
    return returnDictionary;
}
// Информация о месте
+ (NSString *) placeInfoTextInCity:(NSString *)city InCategory:(NSString *)category WithName:(NSString *)placeName{
    NSString *language = [self getLanguage];
    NSString *aboutLanguage;
    
    if ([language isEqualToString:@"ru"]) {
        aboutLanguage = @"About_RU";
    }
    else if ([language isEqualToString:@"de"]){
        aboutLanguage = @"About_DE";
    }
    else
        aboutLanguage = @"About_EN";
    
    return [[self selectedPalceInCity:city category:category withName:placeName] objectForKey:aboutLanguage];
}
// Телефон места
+ (NSString *) placeTelephoneTextInCity:(NSString *)city InCategory:(NSString *)category WithName:(NSString *)placeName{
    return [[self selectedPalceInCity:city category:category withName:placeName] objectForKey:@"Telephone"];
}
// Сайт места
+ (NSString *) placeWebSiteTextInCity:(NSString *)city InCategory:(NSString *)category WithName:(NSString *)placeName{
    return [[self selectedPalceInCity:city category:category withName:placeName] objectForKey:@"web"];
}
// Адрес места
+ (NSString *) placeAddresTextInCity:(NSString *)city InCategory:(NSString *)category WithName:(NSString *)placeName{
    return [[self selectedPalceInCity:city category:category withName:placeName] objectForKey:@"address"];
}
// Картинки места
+ (NSArray *) getImagesOfPlaceInCity:(NSString *)city InCategory:(NSString *) category WithPlaceName:(NSString *)place{
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    NSString *photoPath;
    NSArray *photos;
    
    if(IS_IPHONE_5 == 1){
        photos = [[[self selectedPalceInCity:city category:category withName:place]objectForKey:@"Photo"] objectForKey:@"5"];
    }
    else
        photos = [[[self selectedPalceInCity:city category:category withName:place]objectForKey:@"Photo"] objectForKey:@"4"];
    
    for (int i = 0; i < [photos count]; i++) {
        photoPath = [[NSString alloc]initWithFormat:@"%@/%@/%@",[self docDir],[[self cityCatalogueForCity:city] objectForKey:@"city_EN"],[photos objectAtIndex:i]];
        [imageArray addObject:photoPath];
    }
    
    return imageArray;
}



//
//  Vis_tour
//
//  картинки города
+ (NSArray *) getVisualTourImagesFromCity:(NSString *)city{
    NSDictionary *cityDictionary = [self cityCatalogueForCity:city];
    NSArray *cityPictresArray;
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    if (IS_IPHONE_5==1) {
        cityPictresArray = [[cityDictionary objectForKey:@"photos"] objectForKey:@"5"];
    }
    else
        cityPictresArray = [[cityDictionary objectForKey:@"photos"] objectForKey:@"4"];
    
    for (int i = 0; i < [cityPictresArray count]; i++) {
        [returnArray addObject:[[NSString alloc] initWithFormat:@"%@/%@/%@",[self docDir],[[self cityCatalogueForCity:city] objectForKey:@"city_EN"],[cityPictresArray objectAtIndex:i]]];
    }
    
    return returnArray;
}
//  координаты картинок
+ (NSArray *) getVisualTourImagesCoordinatesFromCity:(NSString *)city{
    NSDictionary *cityDictionary = [self cityCatalogueForCity:city];
    NSArray *cityPictresCoordinatesArray;
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    CLLocation *pictureCoordinate;
    double lon, lat;
    
    cityPictresCoordinatesArray = [[cityDictionary objectForKey:@"photos"] objectForKey:@"coordinates"];
    
    for (int i = 0; i < [cityPictresCoordinatesArray count]; i++) {
        lon = [[[cityPictresCoordinatesArray objectAtIndex:i] objectForKey:@"Lon"] doubleValue];
        lat = [[[cityPictresCoordinatesArray objectAtIndex:i] objectForKey:@"Lat"] doubleValue];
        
        pictureCoordinate = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        [returnArray addObject:pictureCoordinate];
    }
    
    return returnArray;
}

//
//  Category
//

//
+ (NSArray *) getDistrictsOfCategory:(NSString *)category inCity:(NSString *)city{
    NSArray *placesArray = [[[self cityCatalogueForCity:city] objectForKey:@"places"] objectForKey:category];
    NSString *language = [self getLanguage];
    NSString *districtLanguage;
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    if ([language isEqualToString:@"ru"]) {
        districtLanguage = @"District_RU";
    }
    else if ([language isEqualToString:@"de"]){
        districtLanguage = @"District_DE";
    }
    else
        districtLanguage = @"District_EN";
    
    for (int i = 0; i < [placesArray count]; i++) {
        if (![self isInArray:returnArray :[[placesArray objectAtIndex:i] objectForKey:districtLanguage]]) {
            [returnArray addObject:[[placesArray objectAtIndex:i] objectForKey:districtLanguage]];
        }
    }
    
    return returnArray;
}
//  
+ (NSArray *) getPlacesOfCategory:(NSString *)category inCity:(NSString *)city listOrMap : (NSString *) listormap{
    NSArray *placesArrayInCategory = [[[self cityCatalogueForCity:city] objectForKey:@"places"] objectForKey:category];
    NSArray *districtArray = [self getDistrictsOfCategory:category inCity:city];
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    NSString *language = [self getLanguage];
    NSString *districtLanguage;
    NSString *placeNameLanguage;
    NSMutableDictionary *districtDictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *districtDictionary1 = [[NSMutableDictionary alloc] init];
    NSMutableArray *placeNames;
    NSMutableArray *placeCoordinates;
    NSMutableArray *returArray1 = [[NSMutableArray alloc] init];
    CLLocation *currentPlace;
    double lat, lon;
    
    if ([language isEqualToString:@"ru"]) {
        districtLanguage = @"District_RU";
        placeNameLanguage = @"Name_RU";
    }
    else if ([language isEqualToString:@"de"]){
        districtLanguage = @"District_DE";
        placeNameLanguage = @"Name_DE";
    }
    else{
        districtLanguage = @"District_EN";
        placeNameLanguage = @"Name_EN";
    }
    
    for (int i = 0; i < [districtArray count]; i++) {
        districtDictionary = [[NSMutableDictionary alloc] init];
        [districtDictionary setValue:[districtArray objectAtIndex:i] forKey:@"District"];
        districtDictionary1 = [[NSMutableDictionary alloc] init];
        [districtDictionary1 setValue:[districtArray objectAtIndex:i] forKey:@"District"];
        placeNames = [[NSMutableArray alloc] init];
        placeCoordinates = [[NSMutableArray alloc] init];
        
        for (int j = 0; j < [placesArrayInCategory count]; j++) {
            if ([[[placesArrayInCategory objectAtIndex:j] objectForKey:districtLanguage] isEqualToString:[districtArray objectAtIndex:i]]) {
                [placeNames addObject:[[placesArrayInCategory objectAtIndex:j] objectForKey:placeNameLanguage]];
                
                lat = [[[placesArrayInCategory objectAtIndex:j] objectForKey:@"Lat"] doubleValue];
                lon = [[[placesArrayInCategory objectAtIndex:j] objectForKey:@"Lon"] doubleValue];
                currentPlace = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
                
                [placeCoordinates addObject:currentPlace];
            }
        }
        
        [districtDictionary setValue:placeNames forKey:@"Places"];
        [districtDictionary1 setValue:placeCoordinates forKey:@"Coordinates"];
        
        [returnArray addObject:districtDictionary];
        [returArray1 addObject:districtDictionary1];
    }
    
    if ([listormap isEqualToString:@"list"]) {
        return returnArray;
    }
    else
        return returArray1;
}

//
//Explore by dist
//

//  список всех районов
+ (NSArray *) getDistrictsOfCity:(NSString *)city{
    NSDictionary *cityDictionary = [self cityCatalogueForCity:city];
    NSArray *districts = [cityDictionary objectForKey:@"districts"];
    NSString *language = [self getLanguage];
    NSString *districtLanguage;
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    if ([language isEqualToString:@"ru"]) {
        districtLanguage = @"name_RU";
    }
    else if ([language isEqualToString:@"de"]){
        districtLanguage = @"name_DE";
    }
    else
        districtLanguage = @"name_EN";
    
    for (int i = 0; i < [districts count]; i++) {
        [returnArray addObject:[[districts objectAtIndex:i] objectForKey:districtLanguage]];
    }
    
    return returnArray;
}
//
//Around_menu_2
//
//  new function
+ (NSArray *) getPlacesAroundMyLocationInCity : (NSString *) city{
    
    NSArray *arrayOfPlaces = [self arrayOfDictionatySort:[self getAllPlacesInCity:city]];
    
    return arrayOfPlaces;
}




//
//  CATALOGS_1
//

//Catalogs_1 - Специальная серия
+ (NSArray *) getSpecialCities:(int)presise{
    NSMutableArray *tmp1 = [[NSMutableArray alloc]init];
    NSMutableArray *tmp2 = [[NSMutableArray alloc]init];
    NSString *cityLanguage;
    NSString *language = [self getLanguage];
    
    if ([language isEqualToString:@"ru"]) {
        cityLanguage = @"city_RU";
    }
    else if ([language isEqualToString:@"de"]){
        cityLanguage = @"city_DE";
    }
    else
        cityLanguage = @"city_EN";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:@"0" forKey:@"Download"];
    NSMutableArray *catalogues = [defaults objectForKey:catalogue];
    
    for (int i = 0; i < [catalogues count]; i++) {
        if ([[[catalogues objectAtIndex:i]objectForKey:@"special"] isEqualToString:@"1"]) {
            [tmp1 addObject:[[catalogues objectAtIndex:i]objectForKey:cityLanguage]];
            [tmp2 addObject:[[NSString alloc]initWithFormat:@"%@/%@/%@",[self docDir],[[catalogues objectAtIndex:i] objectForKey:@"city_EN"],[[[catalogues objectAtIndex:i] objectForKey:@"photos"] objectForKey:@"large"]]];
        }
    }

    if (presise == 1) {
        return tmp1;
    }
    else
        return tmp2;    
}
//Catalogs_1 - Все каталоги
+ (NSArray *) getAllCities:(int)presise{
    NSMutableArray *tmp1 = [[NSMutableArray alloc]init];
    NSMutableArray *tmp2 = [[NSMutableArray alloc]init];
    NSString *cityLanguage;
    NSString *language = [self getLanguage];
    
    if ([language isEqualToString:@"ru"]) {
        cityLanguage = @"city_RU";
    }
    else if ([language isEqualToString:@"de"]){
        cityLanguage = @"city_DE";
    }
    else
        cityLanguage = @"city_EN";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *catalogues = [defaults objectForKey:catalogue];
    
    for (int i = 0; i < [catalogues count]; i++) {
        [tmp1 addObject:[[catalogues objectAtIndex:i]objectForKey:cityLanguage]];
        [tmp2 addObject:[[NSString alloc]initWithFormat:@"%@/%@/%@",[self docDir],[[catalogues objectAtIndex:i] objectForKey:@"city_EN"],[[[catalogues objectAtIndex:i] objectForKey:@"photos"] objectForKey:@"large"]]];
    }
    
    if (presise == 1) {
        return tmp1;
    }
    else
        return tmp2;
}
//Catalogs_1 - Скачанные каталоги
+ (NSArray *) getDownloadedCities:(int)presise{
    NSMutableArray *tmp1 = [[NSMutableArray alloc]init];
    NSMutableArray *tmp2 = [[NSMutableArray alloc]init];
    NSString *cityLanguage;
    NSString *language = [self getLanguage];
    
    
    if ([language isEqualToString:@"ru"]) {
        cityLanguage = @"city_RU";
    }
    else if ([language isEqualToString:@"de"]){
        cityLanguage = @"city_DE";
    }
    else
        cityLanguage = @"city_EN";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *catalogues = [defaults objectForKey:catalogue];
    
    for (int i = 0; i < [catalogues count]; i++) {
        if ([[[catalogues objectAtIndex:i]objectForKey:@"downloaded"] isEqualToString:@"1"]) {
            [tmp1 addObject:[[catalogues objectAtIndex:i]objectForKey:cityLanguage]];
            [tmp2 addObject:[[NSString alloc]initWithFormat:@"%@/%@/%@",[self docDir],[[catalogues objectAtIndex:i] objectForKey:@"city_EN"],[[[catalogues objectAtIndex:i] objectForKey:@"photos"] objectForKey:@"large"]]];
        }
    }    

    if (presise == 1) {
        return tmp1;
    }
    else
        return tmp2;
}
//Catalogs_1 - Подборка 
+ (NSArray *) getFeaturedCities : (int) presise{
    NSMutableArray *tmp1 = [[NSMutableArray alloc]init];
    NSMutableArray *tmp2 = [[NSMutableArray alloc]init];
    NSLocale *locale = [NSLocale currentLocale];
    NSString *country = [locale localeIdentifier];
    NSString *cityLanguage;
    NSString *language = [self getLanguage];
    
    if ([language isEqualToString:@"ru"]) {
        cityLanguage = @"city_RU";
    }
    else if ([language isEqualToString:@"de"]){
        cityLanguage = @"city_DE";
    }
    else
        cityLanguage = @"city_EN";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *catalogues = [defaults objectForKey:catalogue];
    
    for (int i = 0; i < [catalogues count]; i++) {
        if ([[[catalogues objectAtIndex:i]objectForKey:@"country"] isEqualToString:country]) {
            [tmp1 addObject:[[catalogues objectAtIndex:i]objectForKey:cityLanguage]];
            [tmp2 addObject:[[NSString alloc]initWithFormat:@"%@/%@/%@",[self docDir],[[catalogues objectAtIndex:i] objectForKey:@"city_EN"],[[[catalogues objectAtIndex:i] objectForKey:@"photos"] objectForKey:@"large"]]];
        }
    }
    
    if (presise == 1) {
        return tmp1;
    }
    else
        return tmp2;
}

//
//  side Functions
//
+ (NSDictionary *) allPlacesInCityWithCloseToLocation : (CLLocation *) location{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *catalogues = [defaults objectForKey:catalogue];
    
    NSMutableArray *arrayOfCities = [[NSMutableArray alloc] init];
    NSArray *returnArray;
    NSMutableDictionary *cityDictionary;
    NSString *cityName;
    CLLocation *cityCenter;
    double lat,lon;
    double distance;
    
    for (int i = 0; i < [catalogues count]; i++) {
        cityName = [[catalogues objectAtIndex:i] objectForKey:@"city_DE"];
        lat = [[[catalogues objectAtIndex:i] objectForKey:@"lat"] doubleValue];
        lon = [[[catalogues objectAtIndex:i] objectForKey:@"lon"] doubleValue];
        
        cityCenter = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        distance = [location distanceFromLocation:cityCenter];
        
        cityDictionary = [[NSMutableDictionary alloc] init];
        [cityDictionary setObject:cityName forKey:@"name"];
        [cityDictionary setObject:[NSNumber numberWithDouble:distance] forKey:@"Distance"];
        
        [arrayOfCities addObject:cityDictionary];
    }
    
    returnArray = [self arrayOfDictionatySort:arrayOfCities];
    
    return [returnArray objectAtIndex:0];
}

+ (NSString *) getLanguage {
    NSString *language;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[defaults objectForKey:@"Language"] isEqualToString:@"Русский"]) {
        language = @"ru";
    }
    else if ([[defaults objectForKey:@"Language"] isEqualToString:@"Deutsch"]) {
        language = @"de";
    }
    else
        language = @"en";
    
    return language;
}


+ (NSDictionary *)cityCatalogueForCity:(NSString *)city{
    NSDictionary *cityCatalogue;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *catalogues = [defaults objectForKey:catalogue];
    
    for (int i = 0; i < [catalogues count]; i++) {
        if ([[[catalogues objectAtIndex:i]objectForKey:@"city_RU"]isEqualToString:city] || [[[catalogues objectAtIndex:i]objectForKey:@"city_DE"]isEqualToString:city] || [[[catalogues objectAtIndex:i]objectForKey:@"city_EN"]isEqualToString:city]) {
            cityCatalogue = [catalogues objectAtIndex:i];
        }
    }
    
    return cityCatalogue;
}

+ (BOOL) isInArray: (NSArray *) array : (NSString *) example{
    
    for (int i = 0; i < [array count]; i++) {
        if ([[array objectAtIndex:i] isEqualToString:example]) {
            return YES;
        }
    }
    return NO;
}

+ (NSDictionary *) selectedPalceInCity:(NSString *)city category:(NSString *)category withName:(NSString *)placeName{
    NSDictionary *catalogues = [self cityCatalogueForCity:city];
    NSArray *selectedCategoryPlaces;
    NSDictionary *selectedPlace;
    NSString *language = [self getLanguage];
    NSString *nameLanguage;
    
    if ([language isEqualToString:@"ru"]) {
        nameLanguage = @"Name_RU";
    }
    else if ([language isEqualToString:@"de"]){
        nameLanguage = @"Name_DE";
    }
    else {
        nameLanguage = @"Name_EN";
    }
    
    selectedCategoryPlaces = [[catalogues objectForKey:@"places"] objectForKey:category];
    
    for (int i = 0; i < [selectedCategoryPlaces count]; i++) {
        if ([[[selectedCategoryPlaces objectAtIndex:i] objectForKey:nameLanguage] isEqualToString:placeName]) {
            selectedPlace = [selectedCategoryPlaces objectAtIndex:i];
        }
    }
    
    return selectedPlace;
}
@end
