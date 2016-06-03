//
//  FavoritesTableViewController.h
//  FTripp
//
//
//  Authors: Krishna Teja Medavarapu, Sri Charan Gummadi, Kiran Jujjavarapu
//

#import <UIKit/UIKit.h>
#import<sqlite3.h>

@interface FavoritesTableViewController : UITableViewController

@property (strong,nonatomic) NSMutableArray *favorites; //holds favorite places


@end
