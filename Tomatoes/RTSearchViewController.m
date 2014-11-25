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


@interface RTSearchViewController ()
@property (strong, nonatomic) NSArray *movieListArray;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation RTSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self displaySpinner];
    self.moviePosterCollectionView.delegate = self;
    self.moviePosterCollectionView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [RTRottenTomatoesClient sharedInstance];
    
    RTRottenTomatoesClient *rtNetworking = [[RTRottenTomatoesClient alloc] init];
    
    [rtNetworking searchMoviesWithQuery:@"action" success:^(NSArray *movies) {
        NSLog(@"movies =%@", movies);
        self.movieListArray = [[NSArray alloc] initWithArray:movies];
        [self.moviePosterCollectionView reloadData];
        [self.spinner stopAnimating];
    } failure:^(NSError *error) {
        NSLog(@"error =%@", [error localizedDescription]);
    }];
}

- (void)displaySpinner
{
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
}

#pragma mark - SearchBar Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}

#pragma mark - CollectionView Delegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Got Touched");
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

@end
