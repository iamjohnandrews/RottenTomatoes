//
//  RTMovieDetailViewController.m
//  Tomatoes
//
//  Created by Matt Greenwell on 1/5/14.
//  Copyright (c) 2014 Matt Greenwell. All rights reserved.
// Rotten tomoatoes key fx6jwcz6zkenn5jfrw993cbr

#import "RTMovieDetailViewController.h"
#import "RTFavoritesSaver.h"
#import "UIImageView+AFNetworking.h"

@interface RTMovieDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *castLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@end

@implementation RTMovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *favoriteButton;
    favoriteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                   target:self
                                                                   action:@selector(addTapped)];
    self.navigationItem.rightBarButtonItem = favoriteButton;
    
    if (self.movie != nil) {
        [self configureViewWithMovie:self.movie];
    }
    
}

- (void)setMovie:(RTMovie *)movie {
    _movie = movie;
    [self configureViewWithMovie:movie];
}

- (void)configureViewWithMovie:(RTMovie *)movie {
    self.titleLabel.text = [NSString stringWithFormat:@"%@ (%@)",movie.title,movie.year];
    self.releaseDateLabel.text = [self releaseDateDisplayStringWithReleaseDates:movie.releaseDates];
    self.ratingLabel.text = [self ratingDisplayStringWithRating:movie.criticScore];
    self.castLabel.text = [self castDisplayStringFromCast:movie.cast];
    [self.posterImageView setImageWithURL:movie.thumbnailURL];
}

- (void)addTapped {
    // @TODO: Add to Favorites!
    if ([RTFavoritesSaver checkIfMovieIsAlreadyFavorited:self.movie.movieID]) {
        [self displayAlertMessage:@"You already saved this movie."];
    } else {
        [RTFavoritesSaver saveMovie:self.movie];
        [self displayAlertMessage:@"Movie saved to favorites."];
    }
}


- (void)displayAlertMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
                                                    message:@"Feel free to find other movies to add to your favorites."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Helpers

- (NSString *)releaseDateDisplayStringWithReleaseDates:(NSArray *)releaseDates {
    NSMutableString *dateString = [NSMutableString string];
    
    for (NSString *releaseDate in releaseDates) {
        [dateString appendFormat:@"%@\n",releaseDate];
    }
    
    NSString *localizedFormat = NSLocalizedString(@"Movie_Detail_Cast_Format", @"");
    NSString *displayString = [NSString stringWithFormat:localizedFormat,dateString];
    
    return displayString;
}

- (NSString *)ratingDisplayStringWithRating:(NSInteger)rating {
    NSString *localizedFormat = NSLocalizedString(@"Movie_Detail_Rating_Format", @"");
    NSString *displayString = [NSString stringWithFormat:localizedFormat,rating];
    
    return displayString;
}

- (NSString *)castDisplayStringFromCast:(NSArray *)cast {
    NSMutableString *castList = [NSMutableString string];
    
    for (NSString *castMember in cast) {
        [castList appendFormat:@"%@\n",castMember];
    }
    
    NSString *localizedFormat = NSLocalizedString(@"Movie_Detail_Cast_Format", @"");
    NSString *displayString = [NSString stringWithFormat:localizedFormat,castList];
    
    return displayString;
}

@end
