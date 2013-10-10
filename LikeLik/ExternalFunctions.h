//
//  ExternalFunctions.h
//  TabBar
//
//  Created by Андрей Шелудченко on 18.02.13.
//  Copyright (c) 2013 LikeLik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ExternalFunctions : NSObject<CLLocationManagerDelegate>

+ (void) addCityToDownloaded : (NSString *) city;               //  зафиксировать скачанность каталога

//  удаление каталога
+ (void) deleteCityCatalogue : (NSString *) city;


+ (NSString *) getLocalizedString : (NSString *) string;

+ (NSDictionary *) cityCatalogueForCity : (NSString *) city;


+ (NSArray *) arrayOfDictionatySort : (NSArray *) placesArray;

+ (NSString *) getAboutText;

+ (NSString *) getTermsOfUseText;

+ (NSString *) getPracticalInfoForCity : (NSString *) city;


+ (NSDictionary *) selectedPalceInCity: (NSString *) city category : (NSString *) category withName : (NSString *) placeName;

+ (NSArray *) getAllPlacesInCity:(NSString *) city;

+ (void) getReady;

+ (NSArray *) getArrayOfPlaceDictionariesInCategoryForAllPlaces : (NSString *) category InCity : (NSString *) city;

+ (CLLocation *) getMyLocationOrTheLocationOfCityCenter : (NSString *)city;

+ (NSString *) getIphoneString;






//
//  работа со скачиванием
//
//  проверка на скаченность
+ (BOOL) isDownloaded : (NSString *) city;

+ (void) unzipFileAt : (NSString *) filePath ToDestination : (NSString *) fileDestination;

//
//  такси
//
//  получить данные по такси
+ (NSArray *) getTaxiInformationInCity : (NSString *) city;


//
//  локальные уведомления
//
//  получить место по CLRegion
+ (NSDictionary *) getPlaceByCLRegion: (CLRegion *) region;
//  получить все ригионы вокруг меня
+ (NSArray *) getAllRegionsAroundMyLocation : (CLLocation *) location;

//
//  карта города
//
//  координаты города
+ (CLLocation *) getCenterCoordinatesOfCity: (NSString *) city;


//
//  city Info
//
//  карта метро города
+ (NSArray *) getMetroMapInCity : (NSString *) city;

//
//  favourites
//
//  добавить в favourites
+ (BOOL) addToFavouritesPlace: (NSString *) placeName InCategory : (NSString *) category InCity : (NSString *) city;
//  вывести список мест который в favourites
+ (NSArray *) getAllFavouritePlacesInCity : (NSString *) city;
//  удаление места из favorites
+ (BOOL) removeFromFavoritesPlace: (NSString *) placeName InCategory : (NSString *) category InCity : (NSString *) city;
//  проверка на добавленность
+ (BOOL) isFavorite : (NSString *) placeName InCity : (NSString *) city InCategory : (NSString *) category;

//
//  использование чека LikElik
//
//  проверка на совпадение
+ (BOOL) isTheRightQRCodeOfPlace: (NSString *) placeName InCategory : (NSString *) category InCity : (NSString *) city WithCode : (NSString *) code;
//  проверка использован ли чек
+ (BOOL) isCheckUsedInPlace: (NSString *) placeName InCategory : (NSString *) category InCity : (NSString *) city;
//  данные чека LikeLik
+ (NSDictionary *) getCheckDictionariesOfPlace : (NSString *) placeName InCategory : (NSString *) category InCity : (NSString *) city;


//
//  "плашки" города
//
//  узкая заставка города
+ (NSString *) smallPictureOfCity : (NSString *) city;
//  широкая заставка города
+ (NSString *) larkePictureOfCity : (NSString *) city;




//
//  Vis_tour
//
//  картинки
+ (NSArray *) getVisualTourImagesFromCity : (NSString *) city;

//
//Around_menu_2
//
//  new function
+ (NSArray *) getPlacesAroundMyLocationInCity : (NSString *) city;

//
//  CATALOGS_1
//
+ (NSArray*)getCities:(UITabBarItem *)item andTag:(int)presise;

+ (NSArray *) getFeaturedCities: (int) presise;

+ (NSArray *) getDownloadedCities: (int) presise;

+ (NSArray *) getAllCities: (int) presise;

+ (NSArray *) getSpecialCities: (int) presise;




//
//  side Functions
//
+ (NSDictionary *) allPlacesInCityWithCloseToLocation : (CLLocation *) location;

+ (BOOL) isInArray: (NSArray *) array : (NSString *) example;

+ (NSString *) docDir;

+ (NSString *) getLanguage;



+ (BOOL) addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

//
//  Downloading
//

+ (void) startDownloadingCatalogueOfCity : (NSString *) cityName;
@end
