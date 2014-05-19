//
//  SADView.h
//  SADView
//
//  Created by Neo Apostol on 11/15/13.
//  Copyright (c) 2013 Vladimir Bondarev. All rights reserved.
//

static NSString* const LANGUAGE_RU = @"ru";
static NSString* const LANGUAGE_EN = @"en";

static NSString* const PLACE_ID_DEFAULT = @"default";

/**************************************************************************/

typedef enum
{
    INTERNAL_ERROR=1,
    RECEIVEAD_ERROR,
    SHOWAD_ERROR
} SADVIEW_ERROR;
/**************************************************************************/

@protocol SADWebViewDelegate <NSObject>
@required
-(void)onReceivedAd;
@optional
-(void)onShowedAd;
-(void)onError:(SADVIEW_ERROR)error;
-(void)onAdClicked;
-(void)noAdFound;
@end
/**************************************************************************/

@interface SADWebView : UIWebView

-(id)initWithId:(NSString*)applicationId;
-(void)loadAd:(NSString*)lang;
-(void)loadAd:(NSString*)lang andPlaceId:(NSString*)placeId;

@property(nonatomic, weak) id<SADWebViewDelegate> sadDelegate;
@property(nonatomic, assign, readonly) NSInteger height;
@property(nonatomic, copy, readonly) NSString* applicationId;
@property(nonatomic, assign, readonly) BOOL isLoaded;

@end
