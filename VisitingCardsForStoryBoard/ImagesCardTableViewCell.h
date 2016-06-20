//
//  TableViewCell.h
//  VisitingCardsForStoryBoard
//
//  Created by Serg on 18.05.16.
//  Copyright (c) 2016 Vitaliy Horodecky. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AversImageButtonDelegate <NSObject>

- (void) imagesCartTableViewCell:(int)tag;

@end

@interface ImagesCardTableViewCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UIImageView *aversImagesVisitingCard;
@property (weak, nonatomic) IBOutlet UIImageView *reversImagesVisitingCard;
@property (weak, nonatomic) IBOutlet UIButton *aversImageButton;
@property (weak, nonatomic) IBOutlet UIButton *reversImageButton;

@property (weak, nonatomic) id <AversImageButtonDelegate> delegate;

- (IBAction)touchButton:(id)sender;


@end

static NSString* const imageCardCellIdentifier = @"imageCardCell";