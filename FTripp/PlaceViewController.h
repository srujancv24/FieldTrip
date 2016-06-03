//
//  PlaceViewController.h
//  FTripp
//
//
//  Authors: Krishna Teja Medavarapu, Sri Charan Gummadi, Kiran Jujjavarapu
//

#import <UIKit/UIKit.h>
#import<sqlite3.h>

@interface PlaceViewController : UIViewController

@property (weak,nonatomic)NSString *placeName; //Name eof the place
@property (weak, nonatomic) IBOutlet UIImageView *placeImage; //image of the place

@property (weak, nonatomic) IBOutlet UILabel *description; //Description of place.
@property (weak,nonatomic) NSString *descText; // To store the description
- (IBAction)sharebutton:(id)sender; //share description through whatsapp

@property (weak, nonatomic) IBOutlet UIButton *share; // share button
@property (nonatomic,assign)  BOOL isFavorites; //Favorite condtion

@end
