//
//  EventsDetailViewController.h
//  KATG Big
//
//  Created by Doug Russell on 5/5/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsDetailViewController : UIViewController 
{
	UIWebView	 *webView;
	NSDictionary *event;
	
	UILabel		 *titleLabel;
	UILabel		 *dayLabel;
	UILabel		 *dateLabel;
	UILabel		 *timeLabel;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UILabel	 *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel	 *dayLabel;
@property (nonatomic, retain) IBOutlet UILabel	 *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel	 *timeLabel;
@property (nonatomic, retain) NSDictionary		 *event;

@end
