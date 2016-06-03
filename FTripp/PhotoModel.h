//
//  PhotoModel.h
//  FTripp
//
//
//  Authors: Krishna Teja Medavarapu, Sri Charan Gummadi, Kiran Jujjavarapu
//

@import Foundation;

@interface PhotoModel : NSObject

@property (nonatomic, strong) NSArray *photos; // of Flickr photo NSDictionary


- (void)setPhotos:(NSArray *)photos; //hold the photos to be displayed

@end