//
//  ALTabBarView.m
//  ALCommon
//
//  Created by Andrew Little on 10-08-17.
//  Copyright (c) 2010 Little Apps - www.myroles.ca. All rights reserved.
//

#import "ALTabBarView.h"


@implementation ALTabBarView

@synthesize delegate;
@synthesize selectedButton;

- (void)dealloc {
    
    [selectedButton release];
    delegate = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
    }
    return self;
}

-(IBAction) touchButton:(id)sender {

    if( delegate != nil && [delegate respondsToSelector:@selector(tabWasSelected:)]) {
        
        
        if (selectedButton) {
            switch (selectedButton.tag) {
                case 0:
                    [selectedButton setBackgroundImage:[UIImage imageNamed:@"pinche.png"] forState:UIControlStateNormal];
                    break;
                case 1:
                    [selectedButton setBackgroundImage:[UIImage imageNamed:@"chat.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [selectedButton setBackgroundImage:[UIImage imageNamed:@"friends.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [selectedButton setBackgroundImage:[UIImage imageNamed:@"setup.png"] forState:UIControlStateNormal];
                    break;
            }
            
            [selectedButton release];
        }
        
        selectedButton = [((UIButton *)sender) retain];
        switch (selectedButton.tag) {
            case 0:
                [selectedButton setBackgroundImage:[UIImage imageNamed:@"pinche_selected.png"] forState:UIControlStateNormal];
                break;
            case 1:
                [selectedButton setBackgroundImage:[UIImage imageNamed:@"chat_selected.png"] forState:UIControlStateNormal];
                break;
            case 2:
                [selectedButton setBackgroundImage:[UIImage imageNamed:@"friends_selected.png"] forState:UIControlStateNormal];
                break;
            case 3:
                [selectedButton setBackgroundImage:[UIImage imageNamed:@"setup_selected.png"] forState:UIControlStateNormal];
                break;
        }
        
        
        [delegate tabWasSelected:selectedButton.tag];
    }
}


@end
