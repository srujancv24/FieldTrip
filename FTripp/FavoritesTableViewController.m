//
//  FavoritesTableViewController.m
//  FTripp
//
//
//  Authors: Krishna Teja Medavarapu, Sri Charan Gummadi, Kiran Jujjavarapu
//

#import "FavoritesTableViewController.h"

@interface FavoritesTableViewController ()
@property (strong,nonatomic) NSString *docsDirectory;

@end

NSString *favDB=@"places.db";
NSMutableArray *favsList;

@implementation FavoritesTableViewController

@synthesize favorites;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title=@"FTripp";
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.docsDirectory=[paths objectAtIndex:0];
    NSLog(@"%@",self.docsDirectory);
    
    [self copyDatabaseIntoDocumentsDirectory];
    
    NSString *p=[self.docsDirectory stringByAppendingPathComponent:favDB];
    const char *dbPath=[p UTF8String];
    
    
    static sqlite3 *database=nil;
    NSString *placeN;
    
    
    if(sqlite3_open(dbPath, &database)== SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"select name from places_around_syracuse where favorites=1",nil];
        
        
        const char *query_stmt=[query UTF8String];
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, query_stmt, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            favsList=[[NSMutableArray alloc]init];
            while(sqlite3_step(compiledStatement)==SQLITE_ROW)
            {
                NSLog(@"got row");
                placeN=[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(compiledStatement, 0)];
                [favsList addObject:placeN];
                [self.favorites addObject:placeN];
                
            }
            sqlite3_finalize(compiledStatement);
        }
        NSLog(@"Database returned error %d: %s",sqlite3_errcode(database),sqlite3_errmsg(database));
        sqlite3_close(database);
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [self viewDidLoad];
    [self.tableView reloadData];
}
//Copies databease into documents directory.
-(void)copyDatabaseIntoDocumentsDirectory
{
    NSString *destPath=[self.docsDirectory stringByAppendingPathComponent:favDB];
    NSLog(@"database path: %@",destPath);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:destPath]) {
        // The database file does not exist in the documents directory, so copy it from the main bundle now.
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:favDB];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destPath error:&error];
        
        // Check if any error occurred during copying and display it.
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//returns number of section in table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//Number of rows in a section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [favsList count];
}

//Delegate method for favorite controller.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favCell" forIndexPath:indexPath];
    
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"favCell"];
    }
    NSInteger row=[indexPath row];
    cell.textLabel.text=[favsList objectAtIndex:row];
    return cell;
}
@end
