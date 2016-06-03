//
//  ImageViewController.m
//  FTripp
//
//
//  Authors: Krishna Teja Medavarapu, Sri Charan Gummadi, Kiran Jujjavarapu
//
#import "ImageViewController.h"

@interface ImageViewController ()


@property (nonatomic,strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ImageViewController

//Set teh URL of the image
-(void) setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self startDownloadingImage];
}


//image getter
- (UIImage *) image
{
    return self.imageView.image;
}
//image setter
-(void) setImage:(UIImage *)image
{
    
    self.imageView.image = image;
    [self.imageView sizeToFit];
    self.imageView.clipsToBounds = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageView];
}
// Download the image.
-(void)startDownloadingImage
{
    self.image = nil;
    if(self.imageURL){
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];

        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
            completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
                if (!error) {
                    if ([request.URL isEqual:self.imageURL]) {
                        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                        dispatch_async(dispatch_get_main_queue(), ^{ self.image = image; });
                    }
                }
            }];
        [task resume];
    }
}


@end
