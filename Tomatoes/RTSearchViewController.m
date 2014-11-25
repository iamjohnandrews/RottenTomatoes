//
//  RTViewController.m
//  Tomatoes
//
//  Created by Matt Greenwell on 1/3/14.
//  Copyright (c) 2014 Matt Greenwell. All rights reserved.
//

#import "RTSearchViewController.h"
#import "RTRottenTomatoesClient.h"
#import "RTMoviePosterCollectionViewCell.h"
#import "RTMovie.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "RTMovieDetailViewController.h"


@interface RTSearchViewController ()
@property (strong, nonatomic) NSArray *movieListArray;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) RTRottenTomatoesClient *rtNetworking;
@property (strong, nonatomic) RTMovie *userSelectedMovie;
@property (strong, nonatomic) NSArray *favoriteMoviesArray;
@end

@implementation RTSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self displaySpinner];
    self.moviePosterCollectionView.delegate = self;
    self.moviePosterCollectionView.dataSource = self;
    self.searchBar.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [RTRottenTomatoesClient sharedInstance];
    
    self.rtNetworking = [[RTRottenTomatoesClient alloc] init];
    
    [self getMoviesFor:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"favoriteMovies"];
    self.favoriteMoviesArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (self.favoriteMoviesArray) {
        UIBarButtonItem *userFavoritesButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                             target:self
                                                                                             action:@selector(userFavoritesButtonTapped)];
        self.navigationItem.rightBarButtonItem = userFavoritesButton;
    }
}

- (void)userFavoritesButtonTapped
{
    self.movieListArray = self.favoriteMoviesArray;
    [self.moviePosterCollectionView reloadData];
}

- (void)getMoviesFor:(NSString *)searchTerm
{
    [self.rtNetworking searchMoviesWithQuery:searchTerm success:^(NSArray *movies) {
        NSLog(@"movies =%@", movies);
        self.movieListArray = [[NSArray alloc] initWithArray:movies];
        [self.moviePosterCollectionView reloadData];
        [self.spinner stopAnimating];
    } failure:^(NSError *error) {
        NSLog(@"error =%@, %@", [error localizedDescription], [error description]);
        [self.spinner stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Houston, we have a problem."
                                                        message:@"Sorry, but we are unable to find your movie. Please try again."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)displaySpinner
{
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
    
    self.spinner.center = CGPointMake(self.view.center.x, self.view.frame.origin.y + self.navigationController.navigationBar.frame.size.height + self.searchBar.frame.size.height + 50.0f);
    self.spinner.hidesWhenStopped = YES;
}

#pragma mark - SearchBar Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self displaySpinner];
    [self getMoviesFor:searchBar.text];
}

#pragma mark - CollectionView Delegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Got Touched");
    self.userSelectedMovie = self.movieListArray[indexPath.row];
    [self performSegueWithIdentifier:@"SearchToMovieDetailsSegue" sender:self];
}

#pragma mark - CollectionView DataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.movieListArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RTMoviePosterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"moviePosterCell" forIndexPath:indexPath];
    RTMovie *movieDetails = self.movieListArray[indexPath.row];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:movieDetails.thumbnailURL];
    [cell.moviePosterThumbnail setImageWithURLRequest:request
                                     placeholderImage:nil
                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                  cell.moviePosterThumbnail.image = image;
                                              }
                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                  NSLog(@"WTF error =%@ %@", [error localizedDescription], [error description]);
                                              }];


    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SearchToMovieDetailsSegue"]) {
        RTMovieDetailViewController *movieDetailsVC = segue.destinationViewController;
        movieDetailsVC.movie = self.userSelectedMovie;
    }
}

@end
