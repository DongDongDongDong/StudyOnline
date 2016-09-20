//
//  AILocalPlayVC.m
//  studyOnline
//
//  Created by andylau on 16/3/11.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import "AILocalPlayVC.h"
#import "AIMoviePlayerView.h"

@interface AILocalPlayVC ()
@property (weak, nonatomic) IBOutlet UIImageView *movieImage;
@property (weak, nonatomic) IBOutlet AIMoviePlayerView *movieVIew;

@end

@implementation AILocalPlayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.movieUrl) {
        [self.movieVIew playWithURL:[[NSURL alloc]initFileURLWithPath:self.movieUrl]];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
}

- (IBAction)playMovie:(id)sender {
    if (self.movieUrl) {
        [self.movieVIew playWithURL:[[NSURL alloc]initFileURLWithPath:self.movieUrl]];
    }
}

- (IBAction)backButton:(id)sender {
    [self popoverPresentationController];
}

- (void)stopPlayback{
    [self.movieVIew stopPlayback];
}
@end
