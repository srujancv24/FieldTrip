//
//  MapViewController.m
//  FTripp
//
//
//  Authors: Krishna Teja Medavarapu, Sri Charan Gummadi, Kiran Jujjavarapu
//

#import "MapViewController.h"
#import "MapModel.h"


@interface MapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView; //Map view
@property MapModel *model; //map view controller's model
@property(nonatomic, retain) CLLocationManager *locationManager; //delegate object

@end

@implementation MapViewController

CLLocationManager *locationManager;

//map view setter.
- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    self.mapView.delegate = self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    

    
    self.mapView.showsUserLocation = YES;
    [self.mapView setMapType:MKMapTypeStandard];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];

    self.navigationItem.title=@"Points Of Interest";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//map view delegate function
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    for (CLCircularRegion *region in self.locationManager.monitoredRegions) {
        [self.locationManager stopMonitoringForRegion:region];
    }
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    CLCircularRegion *currentregion = [[CLCircularRegion alloc]initWithCenter:center
                                                        radius:3218.69
                                                    identifier:@"region"];
    [self.locationManager startMonitoringForRegion:currentregion];
}

//map view's delegate function
-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLCircularRegion *)region {

    [self.mapView removeAnnotations:self.mapView.annotations];
}
//Tells the delegate that a new region is being monitored.
-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLCircularRegion *)region {
    for(int i=0;i < [self.model.getlats count];i++)
    {
        CLLocationCoordinate2D testcoordinate = CLLocationCoordinate2DMake([[self.model.getlats objectAtIndex:i] doubleValue],[[self.model.getlongs objectAtIndex:i] doubleValue]);
         NSLog(@"lat: %f,long: %f, title:%@",testcoordinate.latitude,testcoordinate.longitude,[[self.model getTitles] objectAtIndex:i]);
        if([region containsCoordinate:testcoordinate])
        {
            MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
            point.coordinate = CLLocationCoordinate2DMake(testcoordinate.latitude, testcoordinate.longitude);
            point.title = [[self.model getTitles] objectAtIndex:i];
            [self.mapView addAnnotation:point];
        }
    }
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}


@end
