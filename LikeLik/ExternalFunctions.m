//
//  ExternalFunctions.m
//  TabBar
//
//  Created by Андрей Шелудченко on 18.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import "ExternalFunctions.h"
#import "SSZipArchive.h"
#import "AFNetworking.h"

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

+ (NSString *) getInternationalCityNameByLocalizedCityName:(NSString *)cityName {
    NSDictionary *city = [self cityCatalogueForCity:cityName];
    return [city objectForKey:@"city_EN"];
}

+ (void) prepareForSearch {
    NSArray *cityCatalogues = [[NSUserDefaults standardUserDefaults] objectForKey:catalogue];
    NSArray *placesInCity;
    
    NSArray *arrayOfTags;
    NSMutableArray *arrayOfPlacesWithChosenTag = [[NSMutableArray alloc] init];
    NSMutableDictionary *dictionaryWithTagsAndPlacesInCity;
    NSString *cityName;
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    NSDictionary *place;
    
    for (int i = 0; i < [cityCatalogues count]; i++) {
        dictionaryWithTagsAndPlacesInCity = [[NSMutableDictionary alloc] init];
        arrayOfTags = [[NSArray alloc] init];
        cityName = [[cityCatalogues objectAtIndex:i] objectForKey:@"city_EN"];
        NSMutableSet *mergedSet = [NSMutableSet setWithArray:arrayOfTags];
        
        placesInCity = [self getAllPlacesInCity:cityName];
        for (int j = 0; j < [placesInCity count]; j++) {
            [mergedSet unionSet:[NSSet setWithArray:[[placesInCity objectAtIndex:j] objectForKey:@"Tags"]]];
        }
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES];
        arrayOfTags = [mergedSet sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
        
        for (int j = 0; j < [arrayOfTags count]; j++) {
            arrayOfPlacesWithChosenTag = [[NSMutableArray alloc] init];
            for (int k = 0; k < [placesInCity count]; k++) {
                if ([self isInArray:[[placesInCity objectAtIndex:k] objectForKey:@"Tags"] :[arrayOfTags objectAtIndex:j]]) {
                    tempDict = [[NSMutableDictionary alloc] init];
                    place = [placesInCity objectAtIndex:k];
                    [tempDict setValue:[place objectForKey:@"Name"] forKey:@"Name"];
                    [tempDict setValue:[place objectForKey:@"Category"] forKey:@"Category"];
                    [tempDict setValue:[place objectForKey:@"About"] forKey:@"About"];
                    [tempDict setValue:[place objectForKey:@"Web"] forKey:@"Web"];
                    CLLocation *location = [place objectForKey:@"Location"];
                    double lat,lon;
                    lat = location.coordinate.longitude;
                    lon = location.coordinate.latitude;
                    [tempDict setValue:[NSNumber numberWithDouble:lon] forKey:@"Longitude"];
                    [tempDict setValue:[NSNumber numberWithDouble:lat] forKey:@"Latitude"];
                    [tempDict setValue:[place objectForKey:@"Address"] forKey:@"Address"];
                    [tempDict setValue:[place objectForKey:@"Telephone"] forKey:@"Telephone"];
                    [tempDict setValue:[place objectForKey:@"Photo"] forKey:@"Photo"];
                    [arrayOfPlacesWithChosenTag addObject:tempDict];
                }
            }
            [dictionaryWithTagsAndPlacesInCity setValue:arrayOfPlacesWithChosenTag forKey:[arrayOfTags objectAtIndex:j]];
        }
        
        [[NSUserDefaults standardUserDefaults] setValue:dictionaryWithTagsAndPlacesInCity forKey:cityName];
    }
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
    NSString *aboutLanguage;
    
    aboutLanguage = [self getLocalizedString:@"About"];
    
    return [catalogues objectForKey:aboutLanguage];
}

+ (NSString *)getTermsOfUseText {
    NSString *cataloguesPath = [[NSBundle mainBundle]pathForResource:@"appData" ofType:@"plist"];
    NSMutableDictionary *catalogues = [[NSMutableDictionary alloc]initWithContentsOfFile:cataloguesPath];
    NSString *termsOfUseLanguage;
    
    termsOfUseLanguage = [self getLocalizedString:@"termsofuse"];
    
    return [catalogues objectForKey:termsOfUseLanguage];
}

+ (NSString *)getPracticalInfoForCity:(NSString *) city{
    NSDictionary *cityCatalogue = [self cityCatalogueForCity:city];
    NSString *practicalInfoLanguage;
    
    practicalInfoLanguage = [self getLocalizedString:@"About"];
 
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
    NSLog(@"get Ready");
    NSString *cataloguesPath = [[self docDir]stringByAppendingPathComponent:@"catalogue.plist"];
    [[NSFileManager defaultManager]copyItemAtPath:[[NSBundle mainBundle]pathForResource:@"catalogue" ofType:@"plist"] toPath:cataloguesPath error:nil];
    
    NSString *cataloguesPath1 = [[self docDir]stringByAppendingPathComponent:@"Moscow"];
    [[NSFileManager defaultManager]copyItemAtPath:[[NSBundle mainBundle]pathForResource:@"Moscow" ofType:@""] toPath:cataloguesPath1 error:nil];
    
    NSString *cataloguesPath2 = [[self docDir]stringByAppendingPathComponent:@"Vienna"];
    [[NSFileManager defaultManager]copyItemAtPath:[[NSBundle mainBundle]pathForResource:@"Vienna" ofType:@""] toPath:cataloguesPath2 error:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *catalogueArray = [[NSArray alloc]initWithContentsOfFile:cataloguesPath];
    [defaults setObject:catalogueArray forKey:catalogue];
    
    
    NSURL *documentsDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    [self addSkipBackupAttributeToItemAtURL:documentsDirectoryURL];
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

+ (NSArray *) getArrayOfPlaceDictionariesInCategoryForAllPlaces : (NSString *) category InCity : (NSString *) city{
    
    NSDictionary *cityDict = [self cityCatalogueForCity:city];
    NSString *cityNameInEnglish = [cityDict objectForKey:@"city_EN"];
    NSArray *photoNamesOfIPlace;
    NSString *docDirectory = [self docDir];
    CLLocation *location = [self getMyLocationOrTheLocationOfCityCenter:city];
    
    NSString *name = [self getLocalizedString:@"Name"];
    NSString *about = [self getLocalizedString:@"About"];
    NSString *address = [self getLocalizedString:@"address"];
    NSString *time = [self getLocalizedString:@"time"];
    NSString *metro = [self getLocalizedString:@"metro"];
    NSString *preview = [self getLocalizedString:@"Preview"];
    
    NSMutableDictionary *placeDict;
    NSArray *tempArrayOfPlacesIncategory = [[cityDict objectForKey:@"places"] objectForKey:category];
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSString *version = [self getIphoneString];
    double lat,lon;
    NSDictionary *placeAtIndexi;
    
    int placesCount = [tempArrayOfPlacesIncategory count];
    
    for (int i = 0; i < placesCount; i++) {
        placeDict = [[NSMutableDictionary alloc]init];
        placeAtIndexi = [tempArrayOfPlacesIncategory objectAtIndex:i];
        NSString *webSite;
        photoNamesOfIPlace = [[placeAtIndexi objectForKey:@"Photo"] objectForKey:version];
        
        lat = [[placeAtIndexi objectForKey:@"Lat"] doubleValue];
        lon = [[placeAtIndexi objectForKey:@"Lon"] doubleValue];
        CLLocation *currentPlace = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        photos = [[NSMutableArray alloc] init];
        for (int j = 0; j < [[[placeAtIndexi objectForKey:@"Photo"] objectForKey:version] count]; j++) {
            [photos addObject:[[NSString alloc] initWithFormat:@"%@/%@/%@",docDirectory,cityNameInEnglish,[photoNamesOfIPlace objectAtIndex:j]]];
        }
        
        double distance = [location distanceFromLocation:currentPlace];
        [placeDict setValue:[placeAtIndexi objectForKey:name] forKey:@"Name"];
        [placeDict setValue:[placeAtIndexi objectForKey:about] forKey:@"About"];
        [placeDict setValue:[placeAtIndexi objectForKey:address] forKey:@"Address"];
        [placeDict setValue:[placeAtIndexi objectForKey:time] forKey:@"Time"];
        [placeDict setValue:[placeAtIndexi objectForKey:metro] forKey:@"Metro"];
        [placeDict setValue:[placeAtIndexi objectForKey:preview] forKey:@"Preview"];
        [placeDict setValue:[placeAtIndexi objectForKey:@"Telephone"] forKey:@"Telephone"];
        webSite = [placeAtIndexi objectForKey:@"web"];
        
        if (webSite != NULL && [webSite length] > 7) {
            if (![[webSite substringToIndex:7] isEqualToString:@"http://"]) {
                [placeDict setValue:[[NSString alloc] initWithFormat:@"http://%@",webSite] forKey:@"Web"];
            }
            else
                [placeDict setValue: webSite forKey:@"Web"];
        }
        
        [placeDict setValue:[NSNumber numberWithDouble:distance] forKey:@"Distance"];
        [placeDict setValue:currentPlace forKey:@"Location"];
        [placeDict setValue:category forKey:@"Category"];
        [placeDict setValue:photos forKey:@"Photo"];
        [placeDict setValue:city forKey:@"City"];
        [placeDict setValue:[[NSString alloc] initWithFormat:@"%@/%@/%@",docDirectory,cityNameInEnglish,[[placeAtIndexi objectForKey:@"Photo"] objectForKey:@"thumb"]] forKey:@"thumb"];
        [placeDict setValue:[placeAtIndexi objectForKey:@"favourite"] forKey:@"Favorite"];
        [placeDict setValue:[placeAtIndexi objectForKey:@"tag"] forKey:@"Tags"];
        [placeDict setValue:[NSNumber numberWithDouble:lat] forKey:@"Latitude"];
        [placeDict setValue:[NSNumber numberWithDouble:lon] forKey:@"Longitude"];
        [placeDict setValue:[placeAtIndexi objectForKey:@"Name_EN"] forKey:@"Name_EN"];
        
        [returnArray addObject:placeDict];
    }
    
    return returnArray;
}

+ (NSArray *) getAllPlacesInCity:(NSString *)city{
    NSMutableArray *arrayOfPlaces = [[NSMutableArray alloc] init];
    
    NSArray *beautyArray = [self getArrayOfPlaceDictionariesInCategoryForAllPlaces:beauty InCity:city];
    NSArray *restArray = [self getArrayOfPlaceDictionariesInCategoryForAllPlaces:rest InCity:city];
    NSArray *nightArray = [self getArrayOfPlaceDictionariesInCategoryForAllPlaces:night InCity:city];
    NSArray *shopArray = [self getArrayOfPlaceDictionariesInCategoryForAllPlaces:shop InCity:city];
    NSArray *cultArray = [self getArrayOfPlaceDictionariesInCategoryForAllPlaces:cult InCity:city];
    NSArray *leisureArray = [self getArrayOfPlaceDictionariesInCategoryForAllPlaces:leisure InCity:city];
    NSArray *hotelsArray = [self getArrayOfPlaceDictionariesInCategoryForAllPlaces:hotels InCity:city];
    
    if (beautyArray != NULL) {
        [arrayOfPlaces addObjectsFromArray:beautyArray];
    }
    if (restArray != NULL) {
        [arrayOfPlaces addObjectsFromArray:restArray];
    }
    if (nightArray != NULL) {
        [arrayOfPlaces addObjectsFromArray:nightArray];
    }
    if (shopArray != NULL) {
        [arrayOfPlaces addObjectsFromArray:shopArray];
    }
    if (cultArray != NULL) {
        [arrayOfPlaces addObjectsFromArray:cultArray];
    }
    if (leisureArray != NULL) {
        [arrayOfPlaces addObjectsFromArray:leisureArray];
    }
    if (hotelsArray != NULL) {
        [arrayOfPlaces addObjectsFromArray:hotelsArray];
    }
    
    return [self arrayOfDictionatySort:arrayOfPlaces];
}

//  удаление каталога
+ (void) deleteCityCatalogue : (NSString *) city{
    NSString *documentsDirectoryPath = [self docDir];
    NSString *cityName = [self getInternationalCityNameByLocalizedCityName:city];
    NSString *cataloguesPath = [documentsDirectoryPath stringByAppendingPathComponent:@"catalogue.plist"];
    NSMutableArray *newCatalogues = [[NSMutableArray alloc]initWithContentsOfFile:cataloguesPath];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *catalogues = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:catalogue]];
    
    for (int i = 0; i<[catalogues count]; i++) {
        if ([[[catalogues objectAtIndex:i]objectForKey:@"city_RU"]isEqualToString:city] || [[[catalogues objectAtIndex:i]objectForKey:@"city_DE"]isEqualToString:city] || [[[catalogues objectAtIndex:i]objectForKey:@"city_EN"]isEqualToString:city]) {
            
            [[newCatalogues objectAtIndex:i] setValue:@"0" forKeyPath:@"downloaded"];
            
            [newCatalogues writeToFile:cataloguesPath atomically:YES];
            
            [defaults setObject:newCatalogues forKey:catalogue];
            
        }
    }
    
    [[NSFileManager defaultManager] removeItemAtPath:[documentsDirectoryPath stringByAppendingPathComponent:cityName] error:nil];
    [self getReady];
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
    NSString *cataloguesPath = [[self docDir] stringByAppendingPathComponent:@"catalogue.plist"];
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
    NSString *nameLang;
    NSString *aboutLang;
    NSMutableDictionary *taxiDict;
    NSMutableArray *arrayOfTaxiDicts = [[NSMutableArray alloc] init];
    NSMutableArray *newArray;
    
    nameLang = [self getLocalizedString:@"Name"];
    aboutLang = [self getLocalizedString:@"About"];
    
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
    NSString *cataloguesPath = [[self docDir]stringByAppendingPathComponent:@"catalogue.plist"];
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
//#warning Правильное определение языков

    checkLanguageFromCountry = language2;
    checkLanguageFromSystem = language1;
    
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
    
    [returnDictionary setValue:[placeDictionary objectForKey:checkLanguageFromSystem] forKey:@"main"];
    [returnDictionary setValue:[placeDictionary objectForKey:checkLanguageFromCountry] forKey:@"secondary"];
    [returnDictionary setValue:mainDisplayTextString forKey:@"mainDisplayButton"];
    [returnDictionary setValue:secondaryDisplayTextString forKey:@"secondaryDisplayButton"];
    
    return returnDictionary;
}


//  "плашки" города
//
//  узкая заставка города
+ (NSString *) smallPictureOfCity : (NSString *) city{
    NSDictionary *City = [self cityCatalogueForCity:city];
    
    return [[NSString alloc]initWithFormat:@"%@/%@",[[NSBundle mainBundle] pathForResource:[City objectForKey:@"city_EN"] ofType:@""],[[City objectForKey:@"photos"] objectForKey:@"small"]];
}
//  широкая заставка города
+ (NSString *) larkePictureOfCity : (NSString *) city{
    NSDictionary *City = [self cityCatalogueForCity:city];
    
    return [[NSString alloc]initWithFormat:@"%@/%@",[[NSBundle mainBundle] pathForResource:[City objectForKey:@"city_EN"] ofType:@""],[[City objectForKey:@"photos"] objectForKey:@"large"]];
}

//
//  Vis_tour
//
//  картинки города
+ (NSArray *) getVisualTourImagesFromCity:(NSString *)city{
    NSDictionary *cityDictionary = [self cityCatalogueForCity:city];
    NSArray *cityPictresArray;
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSString *path = [self docDir];
    NSString *cityEN = [[self cityCatalogueForCity:city] objectForKey:@"city_EN"];
    cityPictresArray = [[cityDictionary objectForKey:@"photos"] objectForKey:@"img"];
    CLLocation *location;
    double lat, lon;
    NSDictionary *tmpPlace;
    
    for (int i = 0; i < [cityPictresArray count]; i++) {
        dict = [[NSMutableDictionary alloc] init];
        tmpPlace = [cityPictresArray objectAtIndex:i];
        if (IS_IPHONE_5==1) {
            [dict setValue:[[NSString alloc] initWithFormat:@"%@/%@/%@",path,cityEN,[tmpPlace objectForKey:@"5"]] forKey:@"Picture"];
        }
        else
        {
            [dict setValue:[[NSString alloc] initWithFormat:@"%@/%@/%@",path,cityEN,[tmpPlace objectForKey:@"4"]] forKey:@"Picture"];
            
        }
        lat = [[tmpPlace objectForKey:@"Lat"] doubleValue];
        lon = [[tmpPlace objectForKey:@"Lon"] doubleValue];
        location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        
        
        [dict setValue:location forKey:@"Location"];
        [dict setValue:[tmpPlace objectForKey:[self getLocalizedString:@"name"]] forKey:@"Name"];
        [dict setValue:[tmpPlace objectForKey:[self getLocalizedString:@"about"]] forKey:@"About"];
        
        [returnArray addObject:dict];
    }
    
    return returnArray;
}

//
//Around_menu_2
//
//  new function
+ (NSArray *) getPlacesAroundMyLocationInCity : (NSString *) city{
    
    city = [[self cityCatalogueForCity:city] objectForKey:@"city_EN"];
    NSArray *returnArray = [self getAllPlacesInCity:city];
    
    return returnArray;
}

//
//  CATALOGS_1
//

//Catalogs_1 - Специальная серия
+ (NSArray *) getSpecialCities:(int)presise{
    NSMutableArray *tmp1 = [[NSMutableArray alloc]init];
    NSMutableArray *tmp2 = [[NSMutableArray alloc]init];
    NSString *cityLanguage;
    
    cityLanguage = [self getLocalizedString:@"city"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    [defaults setObject:@"0" forKey:@"Download"];
    NSMutableArray *catalogues = [defaults objectForKey:catalogue];
    
    for (int i = 0; i < [catalogues count]; i++) {
        if ([[[catalogues objectAtIndex:i]objectForKey:@"special"] isEqualToString:@"1"]) {
            [tmp1 addObject:[[catalogues objectAtIndex:i]objectForKey:cityLanguage]];
            [tmp2 addObject:[[NSString alloc]initWithFormat:@"%@/%@",[[NSBundle mainBundle] pathForResource:[[catalogues objectAtIndex:i] objectForKey:@"city_EN"] ofType:@""],[[[catalogues objectAtIndex:i] objectForKey:@"photos"] objectForKey:@"small"]]];
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
    
    cityLanguage = [self getLocalizedString:@"city"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *catalogues = [defaults objectForKey:catalogue];
    
    for (int i = 0; i < [catalogues count]; i++) {
        [tmp1 addObject:[[catalogues objectAtIndex:i]objectForKey:cityLanguage]];
        [tmp2 addObject:[UIImage imageWithContentsOfFile:[[NSString alloc]initWithFormat:@"%@/%@",[[NSBundle mainBundle] pathForResource:[[catalogues objectAtIndex:i] objectForKey:@"city_EN"] ofType:@""],[[[catalogues objectAtIndex:i] objectForKey:@"photos"] objectForKey:@"small"]]]];
    }
    
    NSArray *tmp = [self getSoonCitiesArray:presise];
    
    [tmp1 addObjectsFromArray:tmp];
    [tmp2 addObjectsFromArray:tmp];
    
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
    
    cityLanguage = [self getLocalizedString:@"city"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *catalogues = [defaults objectForKey:catalogue];
    
    for (int i = 0; i < [catalogues count]; i++) {
        if ([[[catalogues objectAtIndex:i]objectForKey:@"downloaded"] isEqualToString:@"1"]) {
            [tmp1 addObject:[[catalogues objectAtIndex:i]objectForKey:cityLanguage]];
            [tmp2 addObject:[UIImage imageWithContentsOfFile:[[NSString alloc]initWithFormat:@"%@/%@",[[NSBundle mainBundle] pathForResource:[[catalogues objectAtIndex:i] objectForKey:@"city_EN"] ofType:@""],[[[catalogues objectAtIndex:i] objectForKey:@"photos"] objectForKey:@"small"]]]];
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
    
    cityLanguage = [self getLocalizedString:@"city"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *catalogues = [defaults objectForKey:catalogue];
    
    for (int i = 0; i < [catalogues count]; i++) {
        if ([[[catalogues objectAtIndex:i]objectForKey:@"country"] isEqualToString:country]) {
            [tmp1 addObject:[[catalogues objectAtIndex:i]objectForKey:cityLanguage]];
            [tmp2 addObject:[UIImage imageWithContentsOfFile: [[NSString alloc]initWithFormat:@"%@/%@",[[NSBundle mainBundle] pathForResource:[[catalogues objectAtIndex:i] objectForKey:@"city_EN"] ofType:@""],[[[catalogues objectAtIndex:i] objectForKey:@"photos"] objectForKey:@"small"]]]];
        }
    }
    
    if (presise == 1) {
        return tmp1;
    }
    else
        return tmp2;
}
//  soon cities array
+ (NSArray *) getSoonCitiesArray : (int) presise {
    NSString *soonCitiesLocalized = [self getLocalizedString:@"soonCities"];
    NSString *cataloguesPath = [[NSBundle mainBundle]pathForResource:@"SoonCities" ofType:@"plist"];
    NSMutableArray *soonCitiesArray = [[NSMutableArray alloc]initWithContentsOfFile:cataloguesPath];
    NSString *name = [self getLocalizedString:@"name"];
    
    NSMutableArray *tmp1 = [[NSMutableArray alloc]init];
    NSMutableArray *tmp2 = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [soonCitiesArray count]; i++) {
        [tmp1 addObject:[[soonCitiesArray objectAtIndex:i]objectForKey:name]];
        [tmp2 addObject:[UIImage imageWithContentsOfFile:[[NSString alloc]initWithFormat:@"%@/%@",[[NSBundle mainBundle] pathForResource:soonCitiesLocalized ofType:@""],[[soonCitiesArray objectAtIndex:i] objectForKey:@"img"]]]];
        
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
    NSString *nameLanguage;
    
    nameLanguage = [self getLocalizedString:@"Name"];

    selectedCategoryPlaces = [[catalogues objectForKey:@"places"] objectForKey:category];
    
    for (int i = 0; i < [selectedCategoryPlaces count]; i++) {
        if ([[[selectedCategoryPlaces objectAtIndex:i] objectForKey:nameLanguage] isEqualToString:placeName]) {
            selectedPlace = [selectedCategoryPlaces objectAtIndex:i];
        }
    }
    
    return selectedPlace;
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}


@end
