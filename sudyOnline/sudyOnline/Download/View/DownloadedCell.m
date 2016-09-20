//
//  DownloadedCell.m
//  studyOnline
//
//  Created by andylau on 16/3/11.
//  Copyright © 2016年 andylau. All rights reserved.
//

#import "DownloadedCell.h"
#import "AILocalPlayVC.h"
#import "AIDownloadController.h"
@interface DownloadedCell ()
@property (weak, nonatomic) IBOutlet UILabel *movieName;

@end

@implementation DownloadedCell

- (void)setModel:(DownListModel *)model{
    _model = model;
    self.movieName.text = model.brandName;
}

- (IBAction)playMovie:(id)sender {

//    AILocalPlayVC *playVc = [[AILocalPlayVC alloc] init];

    AILocalPlayVC *playVc = [[AILocalPlayVC alloc] initWithNibName:@"AILocalPlayVC" bundle:nil];
//    id next = [self nextResponder];
//    while (next) {
//        next = [next nextResponder];
//        if ([next isKindOfClass:[AIDownloadController class]]) {
//            
//        }
//    }
    
    
//            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    
    AIDownloadController *downVC = [AIDownloadController shareDownloadManager];
    playVc.movieUrl = self.model.destinationUrl;
//    [downVC.navigationController pushViewController:playVc animated:YES];
    [downVC presentViewController:playVc animated:YES completion:nil];
}

@end
