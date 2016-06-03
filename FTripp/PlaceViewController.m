//
//  PlaceViewController.m
//  FTripp
//
//
//  Authors: Krishna Teja Medavarapu, Sri Charan Gummadi, Kiran Jujjavarapu
//

#import "PlaceViewController.h"


@interface PlaceViewController ()<UIDocumentInteractionControllerDelegate>

@property (nonatomic,strong) UIButton *favButton; //Button for places.

@property (strong,nonatomic) NSString *docsDirectory; //
@property (strong,nonatomic) NSString *sharetext; //text to be shared through whatapp

@end

NSString *plmyDB=@"places.db";
NSInteger favN;

@implementation PlaceViewController

@synthesize description=_description;
@synthesize isFavorites;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.share setBackgroundImage:[UIImage imageNamed:@"whatsapp-share-button.png"] forState:UIControlStateNormal];
    self.title=_placeName;
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.docsDirectory=[paths objectAtIndex:0];
    
    [self copyDatabaseIntoDocumentsDirectory];
    
    NSString *p=[self.docsDirectory stringByAppendingPathComponent:plmyDB];
    const char *dbPath=[p UTF8String];
    static sqlite3 *database=nil;
    

    
    NSString *type;
    NSInteger favInt=0;
    if(sqlite3_open(dbPath, &database)==SQLITE_OK)
    {
        NSString *query=@"select favorites from places_around_syracuse where name='";
        NSString *s=[NSString stringWithFormat:@"%@%@%@",query,_placeName,@"';"];
        const char *sqlStatement=[s cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL)==SQLITE_OK)
        {
            while (sqlite3_step(compiledStatement)==SQLITE_ROW) {
                type=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(compiledStatement, 0)];
                favN=[type integerValue];
            }
            sqlite3_finalize(compiledStatement);
        }
        sqlite3_close(database);
    }
    
    
    
    _favButton =[ UIButton buttonWithType:UIButtonTypeCustom];
    [_favButton setFrame:CGRectMake(0.0f, 0.0f, 39.0f, 28.0f)];
    [_favButton addTarget:self action:@selector(favButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    if(favN==favInt)
        [_favButton setImage:[UIImage imageNamed:@"favorites_icon.png"] forState:UIControlStateNormal];
    else
        [_favButton setImage:[UIImage imageNamed:@"favorite_selected.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *favBarButton=[[UIBarButtonItem alloc] initWithCustomView:_favButton];
    self.navigationItem.rightBarButtonItem=favBarButton;
    

    NSString *bundleRoot=[[NSBundle mainBundle] bundlePath];

    NSFileManager *fm=[NSFileManager defaultManager];
    NSArray *dirContents=[fm contentsOfDirectoryAtPath:bundleRoot error:nil];
    NSPredicate *fltr=[NSPredicate predicateWithFormat:@"self ENDSWITH '.jpg'"];
    NSArray *onlyPNGs=[dirContents filteredArrayUsingPredicate:fltr];
    NSString *imageName;

    for(NSString *tname in onlyPNGs)
    {
    NSArray *strarray=[tname componentsSeparatedByString:@".jpg"];
    NSString *tempName=[strarray objectAtIndex:0];

    if([tempName isEqualToString:_placeName])
    {
        imageName=tname;
        break;
    }
    }
    [self.placeImage setImage:[UIImage imageNamed:imageName]];
    self.description.text=self.descText;
    [self.description sizeToFit];
    _sharetext = self.descText;
    

    self.placeImage.userInteractionEnabled=YES;
    

}

//get contents from the data base
-(void)copyDatabaseIntoDocumentsDirectory
{
    NSString *destPath=[self.docsDirectory stringByAppendingPathComponent:plmyDB];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:destPath]) {
        // The database file does not exist in the documents directory, so copy it from the main bundle now.
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:plmyDB];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destPath error:&error];
        
        // Check if any error occurred during copying and display it.
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    
}


// when user clicks favorite button.
-(void)favButtonPressed
{
    NSString *query;
    NSInteger favInt=0;
    if(favN==favInt)
    {
        //setimage
        //set query
        [_favButton setImage:[UIImage imageNamed:@"favorite_selected.png"] forState:UIControlStateNormal];
        query=[NSString stringWithFormat:@"update places_around_syracuse set favorites=1 where name=?",nil];
    }
    else
    {
        [_favButton setImage:[UIImage imageNamed:@"favorites_icon.png"] forState:UIControlStateNormal];
        query=[NSString stringWithFormat:@"update places_around_syracuse set favorites=0 where name=?",nil];
    }
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.docsDirectory=[paths objectAtIndex:0];
    
    [self copyDatabaseIntoDocumentsDirectory];
    
    NSString *p=[self.docsDirectory stringByAppendingPathComponent:plmyDB];
    const char *dbPath=[p UTF8String];
    static sqlite3 *database=nil;
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_open(dbPath, &database)== SQLITE_OK)
    {
        
        const char *query_stmt=[query UTF8String];
        if(sqlite3_prepare_v2(database, query_stmt, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text(compiledStatement, 1, [_placeName UTF8String], -1, SQLITE_TRANSIENT);
        }
        else
            NSLog(@"Database returned error %d: %s",sqlite3_errcode(database),sqlite3_errmsg(database));
    }
    char *errmsg;
    sqlite3_exec(database, "COMMIT", NULL, NULL, &errmsg);
    if(SQLITE_DONE != sqlite3_step(compiledStatement))
    {
        NSLog(@"Error while updating. %s",sqlite3_errmsg(database));
    }
    sqlite3_finalize(compiledStatement);
    sqlite3_close(database);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//share button's click function
- (IBAction)sharebutton:(id)sender {
    
    NSString *newCountryString =[_sharetext stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *baseURl = [NSString stringWithFormat:@"whatsapp://send?text=%@",newCountryString];
    
    NSURL *whatsappURL = [NSURL URLWithString:baseURl];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
}
@end
