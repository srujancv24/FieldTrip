//
//  FlickrFetcher.m
//  FTripp
//
//  source :stanford ios lectures
//  Authors: Krishna Teja Medavarapu, Sri Charan Gummadi, Kiran Jujjavarapu
//

#import "FlickrFetcher.h"
#import "FlickrAPIKey.h"

@implementation FlickrFetcher


//query for URL
+ (NSURL *)URLForQuery:(NSString *)query
{
    query = [NSString stringWithFormat:@"%@&format=json&nojsoncallback=1&api_key=%@", query, FlickrAPIKey];
    query = [query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [NSURL URLWithString:query];
}


// Url for the geo referenced photos
+ (NSURL *)URLforRecentGeoreferencedPhotos;
{
    return [self URLForQuery:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&license=1,2,4,7&has_geo=1&lat=43.0481&lon=-76.1474 &radius = 1000&extras=original_format,description,geo,date_upload,owner_name"]];
}

// Url of the photo with the specified format
+ (NSString *)urlStringForPhoto:(NSDictionary *)photo format:(FlickrPhotoFormat)format
{
    id farm = [photo objectForKey:@"farm"];
    id server = [photo objectForKey:@"server"];
    id photo_id = [photo objectForKey:@"id"];
    id secret = [photo objectForKey:@"secret"];
    if (format == FlickrPhotoFormatOriginal) secret = [photo objectForKey:@"originalsecret"];
    
    NSString *fileType = @"jpg";
    if (format == FlickrPhotoFormatOriginal) fileType = [photo objectForKey:@"originalformat"];
    
    if (!farm || !server || !photo_id || !secret) return nil;
    
    NSString *formatString = @"s";
    switch (format) {
        case FlickrPhotoFormatSquare:    formatString = @"s"; break;
        case FlickrPhotoFormatLarge:     formatString = @"b"; break;
        case FlickrPhotoFormatOriginal:  formatString = @"o"; break;
    }
    
    return [NSString stringWithFormat:@"https://farm%@.static.flickr.com/%@/%@_%@_%@.%@", farm, server, photo_id, secret, formatString, fileType];
}


// return the format of the photo
+ (NSURL *)URLforPhoto:(NSDictionary *)photo format:(FlickrPhotoFormat)format;
{
    return [NSURL URLWithString:[self urlStringForPhoto:photo format:format]];
}


//returns with information about the place
+ (NSURL *)URLforInformationAboutPlace:(id)flickrPlaceId
{
    return [self URLForQuery:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.places.getInfo&place_id=%@", flickrPlaceId]];
}

#define FLICKR_PLACE_NEIGHBORHOOD_NAME @"place.neighbourhood._content"
#define FLICKR_PLACE_NEIGHBORHOOD_PLACE_ID @"place.neighbourhood.place_id"
#define FLICKR_PLACE_LOCALITY_NAME @"place.locality._content"
#define FLICKR_PLACE_LOCALITY_PLACE_ID @"place.locality.place_id"
#define FLICKR_PLACE_REGION_NAME @"place.region._content"
#define FLICKR_PLACE_REGION_PLACE_ID @"place.region.place_id"
#define FLICKR_PLACE_COUNTY_NAME @"place.county._content"
#define FLICKR_PLACE_COUNTY_PLACE_ID @"place.county.place_id"
#define FLICKR_PLACE_COUNTRY_NAME @"place.country._content"
#define FLICKR_PLACE_COUNTRY_PLACE_ID @"place.country.place_id"
#define FLICKR_PLACE_REGION @"place.region"



// Extracts the name of the place
+ (NSString *)extractNameOfPlace:(id)placeId fromPlaceInformation:(NSDictionary *)place
{
    NSString *name = nil;
    
    if ([placeId isEqualToString:[place valueForKeyPath:FLICKR_PLACE_NEIGHBORHOOD_PLACE_ID]]) {
        name = [place valueForKeyPath:FLICKR_PLACE_NEIGHBORHOOD_NAME];
    } else if ([placeId isEqualToString:[place valueForKeyPath:FLICKR_PLACE_LOCALITY_PLACE_ID]]) {
        name = [place valueForKeyPath:FLICKR_PLACE_LOCALITY_NAME];
    } else if ([placeId isEqualToString:[place valueForKeyPath:FLICKR_PLACE_COUNTY_PLACE_ID]]) {
        name = [place valueForKeyPath:FLICKR_PLACE_COUNTY_NAME];
    } else if ([placeId isEqualToString:[place valueForKeyPath:FLICKR_PLACE_REGION_PLACE_ID]]) {
        name = [place valueForKeyPath:FLICKR_PLACE_REGION_NAME];
    } else if ([placeId isEqualToString:[place valueForKeyPath:FLICKR_PLACE_COUNTRY_PLACE_ID]]) {
        name = [place valueForKeyPath:FLICKR_PLACE_COUNTRY_NAME];
    }
    
    return name;
}

// Extracts region information
+ (NSString *)extractRegionNameFromPlaceInformation:(NSDictionary *)place
{
    return [place valueForKeyPath:FLICKR_PLACE_REGION_NAME];
}

@end
