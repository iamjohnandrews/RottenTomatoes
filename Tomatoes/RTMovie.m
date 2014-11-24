//
//  RTMovie.m
//  Tomatoes
//
//  Created by Matt Greenwell on 1/4/14.
//  Copyright (c) 2014 Matt Greenwell. All rights reserved.
//

#import "RTMovie.h"

NSString * const kIDKey = @"id";
NSString * const kTitleKey = @"title";
NSString * const kYearKey = @"year";
NSString * const kReleaseDatesKey = @"release_dates";
NSString * const kCastKey = @"abridged_cast";
NSString * const kCastNameKey = @"name";
NSString * const kCriticScoreKeyPath = @"ratings.critics_score";
NSString * const kThumbnailKeyPath = @"posters.thumbnail";

@implementation RTMovie

+ (RTMovie *)movieFromJSON:(NSDictionary *)json {
    RTMovie *movie = nil;
    
    if (json != nil) {
        movie = [[RTMovie alloc] init];
        movie.movieID = json[kIDKey];
        movie.title = json[kTitleKey];
        movie.year = json[kYearKey];
        movie.releaseDates = [self releaseDateStringsFromReleaseDatesJSON:json[kReleaseDatesKey]];
        movie.cast = [self castFromCastJSON:json[kCastKey]];
        movie.criticScore = [[json valueForKeyPath:kCriticScoreKeyPath] integerValue];
        movie.thumbnailURL = [NSURL URLWithString:[json valueForKeyPath:kThumbnailKeyPath]];
    }
    return movie;
}

+ (NSArray *)releaseDateStringsFromReleaseDatesJSON:(NSDictionary *)json {
    NSMutableArray *releaseDateStrings = nil;
    
    NSArray *releaseTypes = [json allKeys];
    
    if (releaseTypes != nil) {
        releaseDateStrings = [NSMutableArray arrayWithCapacity:[releaseTypes count]];
        for (NSString *releaseType in releaseTypes) {
            NSString *releaseDate = json[releaseType];
            NSString *releaseDateString = [NSString stringWithFormat:@"%@ - %@",releaseDate,releaseType];
            
            [releaseDateStrings addObject:releaseDateString];
        }
    }
    return releaseDateStrings;
}

+ (NSArray *)castFromCastJSON:(NSArray *)json {
    //@TODO: Move this into cast objects.
    NSMutableArray *cast = nil;
    
    if (json != nil) {
        cast = [NSMutableArray arrayWithCapacity:[json count]];
        for (NSDictionary *castMember in json) {
            NSString *castName = castMember[kCastNameKey];
            [cast addObject:castName];
        }
    }
    return cast;
}

#pragma mark - NSCoding Conformance

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.movieID forKey:@"movieID"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.year forKey:@"year"];
    [aCoder encodeObject:self.releaseDates forKey:@"releaseDates"];
    [aCoder encodeObject:self.cast forKey:@"cast"];
    [aCoder encodeInteger:self.criticScore forKey:@"criticScore"];
    [aCoder encodeObject:self.thumbnailURL forKey:@"thumbnailURL"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _movieID = [aDecoder decodeObjectForKey:@"movieID"];
        _title = [aDecoder decodeObjectForKey:@"title"];
        _year = [aDecoder decodeObjectForKey:@"year"];
        _releaseDates = [aDecoder decodeObjectForKey:@"releaseDates"];
        _cast = [aDecoder decodeObjectForKey:@"cast"];
        _criticScore = [aDecoder decodeIntegerForKey:@"criticScore"];
        _thumbnailURL = [aDecoder decodeObjectForKey:@"thumbnailURL"];
    }
    return self;
}

@end
