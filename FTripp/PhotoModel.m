//
//  PhotoModel.m
//  FTripp
//
//
//  Authors: Krishna Teja Medavarapu, Sri Charan Gummadi, Kiran Jujjavarapu
//

#import <Foundation/Foundation.h>
#import "PhotoModel.h"

@interface PhotoModel()

@end


@implementation PhotoModel

//Intializes the model
- (id) init
{
    if(self = [super init])
    {
        
    }
    return self;
}
//setter method for photos
- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
}
@end

