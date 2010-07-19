//
//  ArchiveViewController.m
//  KATG Big
//
//  Created by Doug Russell on 7/10/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "ArchiveTableViewController.h"
#import "Show.h"
#import "ArchiveTableViewCell.h"
#import "UIViewController+Nib.h"

@implementation ArchiveTableViewController
@synthesize shows = _shows;

#pragma mark -
#pragma mark View lifecycle
#pragma mark -
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	model	=	[DataModel sharedDataModel];
	[model addDelegate:self];
	
	[model shows];
}
- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated 
{
    [super viewDidDisappear:animated];
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
	[super viewDidUnload];
	[model removeDelegate:self];
}
- (void)dealloc 
{
	[_shows release];
    [super dealloc];
}
#pragma mark -
#pragma mark Table view data source
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return self.shows.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString	*	CellIdentifier	=	@"ArchiveTableViewCell";
    static NSString	*	CellNibName		=	@"ArchiveTableViewCelliPhone";
	// Load Nib
    ArchiveTableViewCell	*	cell	=
	(ArchiveTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell	=	(ArchiveTableViewCell *)[ArchiveTableViewCell 
											 loadFromNibName:CellNibName
											 owner:self];
    }
	// Set Title
	cell.showTitleLabel.text	=	[(Show *)[self.shows objectAtIndex:indexPath.row] Title];
	// Set Show Type Icon (Audio or TV)
	if ([[(Show *)[self.shows objectAtIndex:indexPath.row] TV] boolValue])
		cell.showTypeImageView.image	=	[UIImage imageNamed:@"TVShow"];
	else 
		cell.showTypeImageView.image	=	[UIImage imageNamed:@"AudioShow"];
	// Set Notes Icon
	if ([[(Show *)[self.shows objectAtIndex:indexPath.row] HasNotes] boolValue])
		cell.showNotesImageView.image	=	[UIImage imageNamed:@"HasNotes"];
	else
		cell.showNotesImageView.image	=	nil;
	// Set Pictures Icon
	if ([[(Show *)[self.shows objectAtIndex:indexPath.row] PictureCount] intValue] > 0)
		cell.showPicsImageView.image	=	[UIImage imageNamed:@"HasPics"];
	else
		cell.showPicsImageView.image	=	nil;
	
	return cell;
}
#pragma mark -
#pragma mark Table view delegate
#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	UIViewController	*	viewController	=	[[UIViewController alloc] init];
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}
#pragma mark -
#pragma mark Data Model Delgates
#pragma mark -
- (void)shows:(NSArray *)shows
{
	self.shows = shows;
	[self.tableView reloadData];
}

@end
