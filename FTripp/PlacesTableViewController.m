//
//  PlacesTableViewController.m
//  FTripp
//
//
//  Authors: Krishna Teja Medavarapu, Sri Charan Gummadi, Kiran Jujjavarapu
//

#import "PlacesTableViewController.h"
#import "PlaceViewController.h"
#import "MapModel.h"

@interface PlacesTableViewController ()<CLLocationManagerDelegate>

@property(nonatomic, retain) CLLocationManager *locationManager; // Location Manager property.
@property MapModel *model; // model of the view controller

@end

NSString *myDB=@"places.db";
NSMutableArray *placesList; //List of places
NSMutableArray *descList; //List of place's description
NSMutableArray *favList; //List of favorites
NSMutableArray *typeList; // Category of place

@implementation PlacesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"Nearby Places";
    self.model = [[MapModel alloc ]init];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = 2;
    self.locationManager.delegate = self;
    if([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Location Manager's delegate method
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    
    CLLocation *loc = [locations lastObject];
    float latitude = loc.coordinate.latitude;
    float longitude = loc.coordinate.longitude;
    
    for (CLCircularRegion *region in self.locationManager.monitoredRegions) {
        [self.locationManager stopMonitoringForRegion:region];
    }
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude,longitude);
    CLCircularRegion *currentregion = [[CLCircularRegion alloc]initWithCenter:center
                                                                       radius:3218.69
                                                                   identifier:@"region"];
    [self.locationManager startMonitoringForRegion:currentregion];
}

//Tells the delegate that a new region is being monitored.
-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLCircularRegion *)region {
    placesList = [[NSMutableArray alloc]init];
    descList = [[NSMutableArray alloc]init];
    typeList = [[NSMutableArray alloc]init];
    
    for(int i=0;i < [self.model.getlats count];i++)
    {
        
        CLLocationCoordinate2D testcoordinate = CLLocationCoordinate2DMake([[self.model.getlats objectAtIndex:i] doubleValue],[[self.model.getlongs objectAtIndex:i] doubleValue]);
        if([region containsCoordinate:testcoordinate])
        {
            [placesList addObject:[[self.model getTitles] objectAtIndex:i]];
            [descList addObject:[[self.model getDescription] objectAtIndex:i]];
            [typeList addObject:[[self.model getTypes] objectAtIndex:i]];
        }
    }
    [self.tableView reloadData];
}


#pragma mark - Table view data source
//Section in a place table.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (placesList.count == 0) {
        //create a lable size to fit the Table View
        UILabel *messageLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                        self.tableView.bounds.size.width,
                                                                        self.tableView.bounds.size.height)];
        //set the message
        messageLbl.text = @"OOPS!No Nearby places";
        //center the text
        messageLbl.textAlignment = NSTextAlignmentCenter;
        //auto size the text
        [messageLbl sizeToFit];
        
        //set back to label view
        self.tableView.backgroundView = messageLbl;
        //no separator
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        return 0;
    }
    self.tableView.backgroundView = nil;
    return [placesList count];
}


//Number of rows in a section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


//Height between section of a table.
- (double)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    //this is the space
    return 5;
}


//Cell of the table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceCell" forIndexPath:indexPath];
    
    // Configure the cell...
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlaceCell"];
    }
    NSInteger row=[indexPath section];
    cell.textLabel.text=[placesList objectAtIndex:row];
    [typeList objectAtIndex:row];
    UIImage *timg =[UIImage imageNamed:[self getImageName:[typeList objectAtIndex:row]]];
    UILabel *tlab = [[UILabel alloc]init ];
    cell.imageView.image = timg;
    [cell.imageView addSubview:tlab];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


//Height of a row
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }
    else {
        return 40;
    }
}


//Returns the name of the image associated with a place.
- (NSString *)getImageName:(NSString *)type
{
    if([type  isEqual: @"Sights"])
    {
            return @"sights.jpg";
    }
    else if([type  isEqual: @"Museum"])
    {
        return @"museum.jpg";
    }
    else if([type  isEqual: @"Outdoor"])
    {
        return @"outdoor.png";
    }
    else if([type  isEqual: @"Games"])
    {
        return @"games.jpg";
    }
    else if([type  isEqual: @"Shopping"])
    {
        return @"shopping.jpg";
    }
    else if([type  isEqual: @"Nature & Parks"])
    {
        return @"Nature & Parks.png";
    }
    else{
        return @"grey-circle-.png";
    }
}

#pragma mark - Navigation

//In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    //Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"showPlace"])
    {
        NSIndexPath *indexPath=[self.tableView indexPathForSelectedRow];
        PlaceViewController *placeController=segue.destinationViewController;
        placeController.placeName=[placesList objectAtIndex:indexPath.section];
        placeController.descText=[descList objectAtIndex:indexPath.section];
        
        if([favList objectAtIndex:indexPath.section]==[NSNumber numberWithInt:0])
        {
            placeController.isFavorites=NO;
        }
        else
            placeController.isFavorites=YES;
    }
    
    
}
@end
