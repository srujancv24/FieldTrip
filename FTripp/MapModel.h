//
//  MapModel.h
//  FTripp
//
//
//  Authors: Krishna Teja Medavarapu, Sri Charan Gummadi, Kiran Jujjavarapu
//

@import Foundation;

@interface MapModel : NSObject

-(NSMutableArray *) getTitles; //holds titles of places
-(NSMutableArray *) getDescription;// returns images to be displaed on map
-(NSMutableArray *) getlats; //holds latitude values.
-(NSMutableArray *) getlongs; //holds longitude values.
-(NSMutableArray *) getTypes; //holds type of place

@end
