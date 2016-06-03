//
//  FlickrPhotosViewController.h
//  FTripp
//
//
//  Authors: Krishna Teja Medavarapu, Sri Charan Gummadi, Kiran Jujjavarapu
//

#import <UIKit/UIKit.h>

@interface FlickrPhotosViewController : UICollectionViewController

-(void) fetchPhotos;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *camera; //camera property
- (IBAction)takePhoto:(UIBarButtonItem *)sender; //camera's action.

@end
