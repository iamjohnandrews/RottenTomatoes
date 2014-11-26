//
//  RTFavoritesSaver.m
//  Tomatoes
//
//  Created by John Andrews on 11/25/14.
//  Copyright (c) 2014 Matt Greenwell. All rights reserved.
//

#import "RTFavoritesSaver.h"
#import "RTMovie.h"

@interface RTFavoritesSaver ()
@property (strong, nonatomic) NSFileManager *fileManager;
@property (strong, nonatomic) NSString *allFavoritesPath;
@property (strong, nonatomic) NSString *favoritesDirectory;

@end

@implementation RTFavoritesSaver

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fileManager = [NSFileManager defaultManager];
        self.allFavoritesPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        self.favoritesDirectory = [self.allFavoritesPath stringByAppendingString:@"/movieFavorites"];
    }
    return self;
}

- (BOOL)checkIfMovieIsAlreadyFavorited:(NSString *)movieID
{
    NSString *movieFilePath = [[self.allFavoritesPath stringByAppendingString:@"/movieFavorites/"] stringByAppendingString:movieID];
    BOOL movieExists = [self.fileManager fileExistsAtPath:movieFilePath];
  
    return movieExists;
}

- (void)saveMovie:(RTMovie *)movie
{
    if (![self.fileManager fileExistsAtPath:self.favoritesDirectory]) {
        [self.fileManager createDirectoryAtPath:self.favoritesDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *moviePath = [self.favoritesDirectory stringByAppendingPathComponent:movie.movieID];
    
    [NSKeyedArchiver archiveRootObject:movie toFile:moviePath];
}

- (NSArray *)fetchAllMovieFavorites
{
    NSMutableArray *favoitesArray = [NSMutableArray array];

    NSURL *favoritesURL = [NSURL URLWithString:self.favoritesDirectory];
    NSArray *contents = [self.fileManager contentsOfDirectoryAtURL:favoritesURL
                                   includingPropertiesForKeys:@[]
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        error:nil];
    for (NSURL *movieFile in contents) {
        RTMovie *movieDetails = [NSKeyedUnarchiver unarchiveObjectWithFile:movieFile.path]; 
        [favoitesArray addObject:movieDetails];
    }
    
    return favoitesArray;
}


@end
