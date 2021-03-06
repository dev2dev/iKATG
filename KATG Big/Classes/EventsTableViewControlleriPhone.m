//
//  EventsTableViewControlleriPhone.m
//  KATG Big
//
//  Created by Doug Russell on 6/9/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "EventsTableViewControlleriPhone.h"
#import "EventTableCellView.h"
#import "EventsDetailViewControlleriPhone.h"
#import <QuartzCore/QuartzCore.h>
#import "Event.h"
#import "UIViewController+Nib.h"

@implementation EventsTableViewControlleriPhone
@synthesize eventsList, adView;

#pragma mark -
#pragma mark View lifecycle
#pragma mark -
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	model	=	[DataModel sharedDataModel];
	[model addDelegate:self];
	
	[model eventsNoPoll];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark -
#pragma mark Memory management
#pragma mark -
- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload 
{
    [model removeDelegate:self];
	self.eventsList	=	nil;
	self.adView		=	nil;
}
- (void)dealloc 
{
	[eventsList release];
	[adView release];
    [super dealloc];
}
#pragma mark -
#pragma mark Table View
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return eventsList.count;
}
// Customize the appearance of table view cells.
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if (self.adView == nil)
	{
		self.adView									=	[[[ADBannerView alloc] 
														  initWithFrame:CGRectZero] autorelease];
		self.adView.requiredContentSizeIdentifiers	=	[NSSet setWithObject:ADBannerContentSizeIdentifier320x50];
		self.adView.currentContentSizeIdentifier	=	ADBannerContentSizeIdentifier320x50;
		self.adView.delegate						=	self;
	}
	return self.adView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString	*	CellIdentifier	=	@"EventTableCell";
    static NSString	*	CellNibName		=	@"EventTableCellView";
	
    EventTableCellView *cell = (EventTableCellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell	=	(EventTableCellView *)[EventTableCellView loadFromNibName:CellNibName 
																   owner:self];
    }
	
    [[cell eventTitleLabel] setText:[[eventsList objectAtIndex:indexPath.row] Title]];
	[[cell eventDayLabel] setText:[[eventsList objectAtIndex:indexPath.row] Day]];
	[[cell eventDateLabel] setText:[[eventsList objectAtIndex:indexPath.row] Date]];
	[[cell eventTimeLabel] setText:[[eventsList objectAtIndex:indexPath.row] Time]];
	
	if ([[[eventsList objectAtIndex:indexPath.row] ShowType] boolValue])
		[[cell eventTypeImageView] setImage:[UIImage imageNamed:@"LiveShowIconTrans"]];
	else
		[[cell eventTypeImageView] setImage:[UIImage imageNamed:@"EventIconTrans"]];
	
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	EventsDetailViewControlleriPhone *viewController = 
	[[EventsDetailViewControlleriPhone alloc] initWithNibName:@"EventsDetailView" 
													   bundle:nil];
	[viewController setEvent:[eventsList objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:viewController 
										 animated:YES];
	[viewController release];
}
- (void)reloadTableView
{
	if ([NSThread isMainThread])
	{
		[self.tableView reloadData];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(reloadTableView) 
							   withObject:nil 
							waitUntilDone:NO];
	}
}
#pragma mark -
#pragma mark DataModel
#pragma mark -
- (void)events:(NSArray *)events
{
	if (events && events.count > 0)
	{
		[self setEventsList:events];
		[self reloadTableView];
	}
}



@end

