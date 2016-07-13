//
//  TableViewCell.h
//  VisitingCardsForStoryBoard
//
//  Created by Serg on 18.05.16.
//  Copyright (c) 2016 Vitaliy Horodecky. All rights reserved.
//

#define LEFT_IMAGE_BUTTON_TAG   2001
#define RIGHT_IMAGE_BUTTON_TAG    2002

#import <UIKit/UIKit.h>
#import "Utilite.h"


@protocol ImageButtonDelegate <NSObject>

- (void) imagesCartTableViewCell:(NSInteger)tag;

@end

@class Contact;

@interface ImagesCardTableViewCell : UITableViewCell

@property (nonatomic, strong) Contact *contact;
@property (nonatomic, assign) StatusViewType viewType;

@property (weak, nonatomic) IBOutlet UIImageView *aversImagesVisitingCard;
@property (weak, nonatomic) IBOutlet UIImageView *reversImagesVisitingCard;
@property (weak, nonatomic) IBOutlet UIButton *aversImageButton;
@property (weak, nonatomic) IBOutlet UIButton *reversImageButton;

@property (weak, nonatomic) id <ImageButtonDelegate> delegate;

- (IBAction)touchButton:(id)sender;

- (void) updateUIImage;

@end

static NSString* const imageCardCellIdentifier = @"imageCardCell";