//
//  FlickrPhotosViewController.m
//  FTripp
//
//
//  Authors: Krishna Teja Medavarapu, Sri Charan Gummadi, Kiran Jujjavarapu
//

#import "FlickrPhotosViewController.h"
#import "PhotoModel.h"
#include "FlickrFetcher.h"
#include "ImageViewController.h"

@interface FlickrPhotosViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property PhotoModel *model; //Flickr view controller model
@property (nonatomic, strong) UIImage *image; //Image property


@end

@implementation FlickrPhotosViewController

static NSString * const reuseIdentifier = @"Cell";



- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [[PhotoModel alloc ]init];
    self.navigationItem.title=@"Flickr Photos";
    [self fetchPhotos];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}
// Fetches photos from Flickr API.
-(void) fetchPhotos
{
    NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
    
    NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        // convert it to a Property List (NSArray and NSDictionary)
    NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                            options:0
                                                                              error:NULL];
        // get the NSArray of photo NSDictionarys out of the results
    NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
    self.model.photos = photos;
}
//Delegate Method for Collection View
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"Photo" sender:[self.collectionView cellForItemAtIndexPath:indexPath]];
}

#pragma mark - Navigation

//To display full size photo.
- (void)prepareImageViewController:(ImageViewController *)ivc toDisplayPhoto:(NSDictionary *)photo
{
    ivc.imageURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
    ivc.title = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller

    if ([sender isKindOfClass:[UICollectionViewCell class]]) {
        // find out which row in which section we're seguing from
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        if (indexPath) {
            // found it ... are we doing the Display Photo segue?
            if ([segue.identifier isEqualToString:@"Photo"]) {
                // yes ... is the destination an ImageViewController?
                if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]) {
                    // yes ... then we know how to prepare for that segue!
                    
                    [self prepareImageViewController:segue.destinationViewController
                                      toDisplayPhoto:self.model.photos[indexPath.item]];
                }
            }
        }
    }
    
}



//returns number of sections in collections view.
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//Returns of items in each section.
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
}
//Delegate method of collection view.
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    // get the photo out of our Model
    NSDictionary *photo = self.model.photos[indexPath.item];
    NSURL *imageURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatSquare];
    
    UIImageView *flickrImageView = (UIImageView *)[cell viewWithTag:75];

    UIImage * timg = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    flickrImageView.frame = CGRectMake(0, 0, timg.size.width, timg.size.height);
    cell.backgroundView = [[UIImageView alloc] initWithImage:timg];
       return cell;
}
// Capture a photo.
- (IBAction)takePhoto:(UIBarButtonItem *)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePicker setAllowsEditing:YES];
        
    }
}
// On selecting the captured image.
-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImageWriteToSavedPhotosAlbum(image,
                                   self,
                                   nil,
                                   nil);
}

@end
