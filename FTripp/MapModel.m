//
//  MapModel.m
//  FTripp
//
//
//  Authors: Krishna Teja Medavarapu, Sri Charan Gummadi, Kiran Jujjavarapu
//

#import "MapModel.h"
#include<sqlite3.h>


@interface MapModel()

//@property (strong,nonatomic,readonly) NSMutableArray *mapImages; //holds map images
@property (strong,nonatomic) NSString *docsDirectory;
@property (strong,nonatomic,readonly) NSString *myDB; //Data Base
@property (strong,nonatomic,readonly) NSMutableArray *placesList; //List of Places
@property (strong,nonatomic,readonly) NSMutableArray *descList; //list of place's description
@property (strong,nonatomic,readonly) NSMutableArray *latsList; //list of latitude values
@property (strong,nonatomic,readonly) NSMutableArray *longsList; //List of longitude values.
@property (strong,nonatomic,readonly) NSMutableArray *typeList; //List of Type of places.

@end

@implementation MapModel

@synthesize latsList = _latsList;

//Intializes the model
- (id) init
{
    if(self = [super init])
    {
        _myDB=@"places.db";
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.docsDirectory=[paths objectAtIndex:0];
        NSLog(@"%@",self.docsDirectory);
        
        [self copyDatabaseIntoDocumentsDirectory];
        
        NSString *p=[self.docsDirectory stringByAppendingPathComponent:_myDB];
        const char *dbPath=[p UTF8String];
        
        static sqlite3 *database=nil;
        NSString *placeN;
        NSString *descN;
        NSString *latsN;
        NSString *longsN;
        NSString *typesN;
        
        if(sqlite3_open(dbPath, &database)== SQLITE_OK)
        {
            NSString *query=[NSString stringWithFormat:@"select name,description,latitude,longitude,type from places_around_syracuse",nil];
            
            const char *query_stmt=[query UTF8String];
            sqlite3_stmt *compiledStatement;
            
            if(sqlite3_prepare_v2(database, query_stmt, -1, &compiledStatement, NULL) == SQLITE_OK)
            {
                _placesList=[[NSMutableArray alloc]init];
                _descList=[[NSMutableArray alloc]init];
                _latsList = [[NSMutableArray alloc]init];
                _longsList = [[NSMutableArray alloc]init];
                _typeList = [[NSMutableArray alloc]init];
                while(sqlite3_step(compiledStatement)==SQLITE_ROW)
                {
                    placeN=[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(compiledStatement, 0)];
                    [_placesList addObject:placeN];
                    descN=[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(compiledStatement, 1)];
                    [_descList addObject:descN];
                    latsN=[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(compiledStatement, 2)];
                    [_latsList addObject:latsN];
                    longsN=[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(compiledStatement, 3)];
                    [_longsList addObject:longsN];
                    typesN=[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(compiledStatement, 4)];
                    [_typeList addObject:typesN];
                    
                }
                sqlite3_finalize(compiledStatement);
            }
            NSLog(@"Database returned error %d: %s",sqlite3_errcode(database),sqlite3_errmsg(database));
            sqlite3_close(database);
        }
        
    }
    return self;
}

// Copies Database into documents directory.
-(void)copyDatabaseIntoDocumentsDirectory
{
    NSString *destPath=[self.docsDirectory stringByAppendingPathComponent:_myDB];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:destPath]) {
        // The database file does not exist in the documents directory, so copy it from the main bundle now.
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:_myDB];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destPath error:&error];
        
        // Check if any error occurred during copying and display it.
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    
}
//returns latitude list.
-(NSMutableArray *) getlats
{
    return _latsList;
}
//returns longitude list
-(NSMutableArray *) getlongs
{
    return self.longsList;
}
//returns place list.
-(NSMutableArray *) getTitles
{
    return _placesList;
}
//returns descriptiom
-(NSMutableArray *) getDescription
{
    return _descList;
}
//returns type list.
-(NSMutableArray *) getTypes
{
    return _typeList;
}

@end


