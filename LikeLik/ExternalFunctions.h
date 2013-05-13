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



+ (NSString *) getLocalizedString : (NSString *) string;

+ (NSDictionary *) cityCatalogueForCity : (NSString *) city;


+ (NSArray *) arrayOfDictionatySort : (NSArray *) placesArray;

+ (NSString *) getAboutText;

+ (NSString *) getTermsOfUseText;

+ (NSString *) getPracticalInfoForCity : (NSString *) city;


+ (NSDictionary *) selectedPalceInCity: (NSString *) city category : (NSString *) category withName : (NSString *) placeName;

+ (NSDictionary *) placeDictionaryInCity : (NSString *) city InCategory : (NSString *) category withName : (NSString *) placeName;

+ (NSString *) placeInfoTextInCity: (NSString *) city InCategory : (NSString *) category WithName : (NSString *) placeName;

+ (NSString *) placeTelephoneTextInCity: (NSString *) city InCategory : (NSString *) category WithName : (NSString *) placeName;

+ (NSString *) placeWebSiteTextInCity: (NSString *) city InCategory : (NSString *) category WithName : (NSString *) placeName;

+ (NSString *) placeAddresTextInCity: (NSString *) city InCategory : (NSString *) category WithName : (NSString *) placeName;

+ (NSArray *) getImagesOfPlaceInCity:(NSString *)city InCategory:(NSString *) category WithPlaceName:(NSString *)place;

+ (NSArray *) getAllPlacesInCity:(NSString *) city;

+ (void) getReady;

+ (NSArray *) getArrayOfPlaceDictionariesInCategory : (NSString *) category InCity : (NSString *) city;

+ (CLLocation *) getMyLocationOrTheLocationOfCityCenter : (NSString *)city;

+ (NSString *) getIphoneString;






//
//  работа со скачиванием
//
//  проверка на скаченность
+ (BOOL) isDownloaded : (NSString *) city;

+ (void) downloadCatalogue : (NSString *) catalogueOfCity;

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
//  обнуление использованных чеков
+ (void) makeAllChecksUnused;

//
//  "плашки" города
//
//  узкая заставка города
+ (NSString *) smallPictureOfCity : (NSString *) city;
//  широкая заставка города
+ (NSString *) larkePictureOfCity : (NSString *) city;

//
//  Coordinate Functions
//
+ (CLLocation *) getPlaceCoordinatesInCity:(NSString *) city InCategory : (NSString *) categiry WithName : (NSString *) placeName;



//
//  Vis_tour
//
//  картинки
+ (NSArray *) getVisualTourImagesFromCity : (NSString *) city;
//  координаты
+ (NSArray *) getVisualTourImagesCoordinatesFromCity : (NSString *) city;


//
//  Category
//
+ (NSArray *) getDistrictsOfCategory : (NSString *) category inCity : (NSString *) city;

+ (NSArray *) getPlacesOfCategory : (NSString *) category inCity : (NSString *) city listOrMap : (NSString *) listormap;

//
//Explore by dist
//
+ (NSArray *) getDistrictsOfCity: (NSString *) city;


//
//Around_menu_2
//
//#warning функция неверная
+ (NSArray *) getPlacesAroundMe : (NSString *) cityName myLocation : (CLLocation *) Me category : (NSString *) category listOrMap : (NSString *) listormap;
//  new function
+ (NSArray *) getPlacesAroundMyLocationInCity : (NSString *) city;

//
//  CATALOGS_1
//
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


@end
