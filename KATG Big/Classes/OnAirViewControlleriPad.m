//
//  OnAirViewControlleriPad.m
//  KATG Big
//
//  Created by Doug Russell on 4/26/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//  http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//  

#import "OnAirViewControlleriPad.h"
#import "RoundedView.h"
#import <QuartzCore/QuartzCore.h>
#import "EventTableCellView.h"
#import "EventsDetailViewController.h"
#import "UIWebViewOpaque.h"
#import "OnAirViewLogging.h"

static NSString *const html = @"<html>\n<head id=\"Head1\">\n<title>\n\tKeith and The Girl - Chat room\n</title>\n<script type=\"text/javascript\" language=\"javascript\">\nfunction updateOrientation()\n{\n\tswitch(window.orientation)\n\t{\n\t\tcase 0:\n\t\tcase 180:\n\t\t\t\n\t\tbreak;\n\t\tcase -90:\n\t\tcase 90:\n\t\t\t\n\t\tbreak;\n\t}\n}\n</script>\n<meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 448\">\n</head>\n<body onorientationchange=\"updateOrientation();\">\n<style>\nbody {\n\t-webkit-text-size-adjust: auto;\n\tbackground-color: transparent;\n\tcolor: #222;\n\tpadding: 0px;\n\tfont-family: Helvetica; \n\tfont-size: 14pt;\n\tmargin: 0;\n\t#td_channel_container td\n\t{\n\t\tfont-family: Helvetica;\n\t\tfont-size: 12pt;\n\t}\n\t#toolbarid select\n\t{\n\t\tfont-size:12pt;\n\t}\n\t.button\n\t{\n\t\tmargin: 1px;\n\t\tvertical-align: middle;\n\t\tpadding: 0px;\n\t}\n\t.buttonover\n\t{\n\t\tborder: #0A246A 1px solid;\n\t\tbackground-color: #B6BDD2;\n\t\tpadding: 0px;\n\t\tmargin: 0px;\n\t\tvertical-align: middle;\n\t}\n\t.buttondown\n\t{\n\t\tborder-right: buttonhighlight 1px solid;\n\t\tborder-top: buttonshadow 1px solid;\n\t\tborder-left: buttonshadow 1px solid;\n\t\tborder-bottom: buttonhighlight 1px solid;\n\t\tmargin: 0px;\n\t\tvertical-align: middle;\n\t\tpadding: 0px;\n\t}\n\t.DebugList\n\t{\n\t}\n\t.MessageList\n\t{\n\t}\n\t.ContentPanel\n\t{\n\t\tbackground-color: White!important;\n\t}\n\t.RightPanel\n\t{\n\t\tbackground-color: White!important;\n\t}\n\t.InputBoxElement /*INPUT BOX*/\n\t{\n\t\tbackground-color:white !important;\n\t\tfont-size: 9pt;\n\t\tfont-family: Arial;\n\t\tpadding: 4px;\n\t}\n\t.MessageTabButton\n\t{\n\t\ttext-align: center;\n\t\tfont-family: Helvetica;\n\t\tfont-size: 11px;\n\t\tfont-weight: bold;\n\t\tcolor: #3E5684!important;\n\t\theight:27px;\n\t\tbackground-color: #f3f3f3!important;\n\t\tborder: 1px solid #BED6E0!important;\n\t\tbackground-image:url(Skins/normal/images/button2.gif)!important;\n\t}\n\t.ActiveMessageTabButton\n\t{\n\t\ttext-align: center;\n\t\tfont-family: Helvetica;\n\t\tfont-size: 11px;\n\t\tfont-weight: bold;\n\t\tcolor: #3E5684!important;\n\t\theight:27px;\n\t\tbackground-color: #EDF1FA!important;\n\t\tborder: 1px solid #BED6E0!important;\n\t\tbackground-image:url(Skins/normal/images/button.gif)!important;\n\t}\n\t.ConnectionButton\n\t{\n\t\ttext-align: center;\n\t\tfont: bold 9pt/1.3 verdana;\n\t\tcolor: #3E5684!important;\n\t\tbackground-color: #F3F3F3!important;\n\t\tborder: 1px solid #6885B9!important;\n\t\tbackground-image:url(Skins/normal/images/button.gif)!important;\n\t}\n\t.SendButton\n\t{\n\t\ttext-align: center;\n\t\tfont: bold 9pt/1.3 helevetica;\n\t\tcolor: #3E5684!important;\n\t\tbackground-color: #F3F3F3!important;\n\t\tborder: 1px solid #6885B9!important;\n\t\tbackground-image:url(Skins/normal/images/send.gif)!important;\n\t}\n\n\t.HtmlButton\n\t{\n\t\ttext-align: center;\n\t\tbackground-color: #eeeeee;\n\t\tborder:1px solid #999999;\n\t\tbackground-image:url(Skins/normal/images/HtmlButton.gif);\n\t\tfont-family: Tahoma, Arial, Helvetica;\n\t\tfont-size: 11px;\n\t\tfont-weight: bold;\n\t\theight:27px;\n\t\tcolor: #333333;\n\t}\n\t.WindowHeader\n\t{\n\t\ttext-align: center;\n\t\tbackground-color: #EDF1FA;\n\t\tbackground-image:url(Skins/normal/images/WindowHeader.gif);\n\t\tfont-family: Helvetica;\n\t\tfont-size: 11px;\n\t\tfont-weight: bold;\n\t\tcolor: #000000;\n\t\theight:17px;\n\t\tborder-bottom:1px solid #8d8d8d;\n\t}\n\t.ChannelTitle\n\t{\n\t\tpadding: 5px 0 0 5px;\n\t\tCOLOR: #4C6AA4;\t\n\t\tfont:normal 15px Helvetica;\n\t\tfont-weight: bold;\n\t}\n\t.NumberOnline\n\t{\n\t\tborder-bottom: #dddddd 3px solid;\n\t}\n\t/*Message Classes*/\n\t.Announcement\n\t{\n\t\tfont-weight: bold;\n\t\tcolor: #008200;\n\t\tfont-size: 13px;\n\t}\n\t.System\n\t{\n\t\tcolor: #008200;\n\t}\n\t.Msg\n\t{\n\t}\n\t.Info\n\t{\n\t}\n\t.Event\n\t{\n\t\tcolor: #008200;\n\t}\n\t.EmotionMessage\n\t{\n\t\tfont-weight:bold;\n\t\tcolor:#008200;\n\t}\n\t.UserMessage td\n\t{\n\t\tfont:bold 9pt Helvetica;\n\t\tfont-weight: bold;\n\t}\n\t.UserMessage\n\t{\n\t\tfont-weight: bold;\n\t}\n\t.WhisperUserMessage td\n\t{\n\t\tfont-weight: bold;\n\t\tcolor: Orange;\n\t}\n\t.Connection\n\t{\n\t\tcolor: #008200;\n\t}\n\t.Contact\n\t{\n\t\tcolor: #cc0000;\t\n\t}\n\t.User\n\t{\n\t\tcolor: #cc0000;\t\n\t}\n\t.You\n\t{\n\t\tcolor: Blue; /*font-style:italic;*/\n\t\tfont-weight: bold;\n\t}\n\t.Sender\n\t{\n\t}\n\t.Target\n\t{\n\t}\n\t.MessageList\n\t{\n\t\tpadding:2px;\n\t}\n\t.OperatorMessage td\n\t{\n\t\tcolor:Maroon;\n\t\tfont-weight:bold;\n\t}\n}\n</style>\n<script type=\"text/javascript\" language=\"javascript\">\n\tEmbed_Location = 'Lobby'\n\tEmbed_LocationId = '1'\n</script>\n<table style=\"width: 100%; height: 100%;\" >\n\t<tr>\n\t\t<td id=\"td_channel_container\">\n\t\t\t<div id=\"toolbarid\">\n\t\t\t\t<img title=\"Bold\" src='/Chat/ChatClient/images/bold.gif' class=\"button\" onclick=\"SetFontBold((this.className=(this.className=='button'?'buttondown':'button'))=='buttondown')\" />\n\t\t\t\t<img title=\"Italic\" src='/Chat/ChatClient/images/italic.gif' class=\"button\" onclick=\"SetFontItalic((this.className=(this.className=='button'?'buttondown':'button'))=='buttondown')\" />\n\t\t\t\t<img title=\"Underline\" src='/Chat/ChatClient/images/underline.gif' class=\"button\" onclick=\"SetFontUnderline((this.className=(this.className=='button'?'buttondown':'button'))=='buttondown')\" />\n\t\t\t\t<img title=\"Font Color\" src='/Chat/ChatClient/images/colourpick.gif' style=\"background-color: black\" class=\"button\" onmouseover=\"this.className='buttonover'\" onmouseout=\"this.className='button'\" onclick=\"ChatUI_ShowColorPanel(this)\" />\n\t\t\t\t<img title=\"Insert Emotions\" src='/Chat/ChatClient/images/emotion.gif' class=\"button\" onmouseover=\"this.className='buttonover'\" onmouseout=\"this.className='button'\" onclick=\"ChatUI_ShowEmotionPanel(this)\" />\n\t\t\t\t<img title=\"Control Panel\" src='/Chat/ChatClient/images/control_panel.gif' class=\"button\" onmouseover=\"this.className='buttonover'\" onmouseout=\"this.className='button'\" onclick=\"ChatUI_ShowControlPanel(this)\" />\n\t\t\t\t<img title=\"Sign Out\" src='/Chat/ChatClient/images/logoff.gif' class=\"button\" onmouseover=\"this.className='buttonover'\" onmouseout=\"this.className='button'\" onclick=\"ChatUI_QuitWithConfirm()\" />\n\t\t\t</div>\n\t\t</td>\n\t</tr>\n</table>\n<link rel=stylesheet href='/Chat/ChatClient/EmbedChannel.css' />\n<script src='/Chat/ChatClient/protoutil.js'></script>\n<script src='/Chat/ChatClient/settings.js.aspx'></script>\n<script src='/Chat/ChatClient/loadall.aspx'></script>\n<script>\n_SL_AddTranslater(GetString);\n_SL_SetContentFilter(ReplaceStrings);\n</script>\n<script src='/Chat/ChatClient/chat.rane.js.aspx'></script>\n<script src='/Chat/ChatClient/chat.rane.aspx'></script>\n<script src='/Chat/ChatClient/chatclient.js'></script>\n<script src='/Chat/ChatClient/chatui.js.aspx'></script>\n<script>\nvar clientid='bf31b4ab-3075-4228-a53e-fd07d054caba';\nvar toolbarArea=document.getElementById(\"toolbarid\");\nIsEmbed=true;\nif(typeof(Embed_Location)==\"undefined\")alert(\"Embed_Location not set !\");\nif(typeof(Embed_LocationId)==\"undefined\")alert(\"Embed_LocationId not set !\");\n</script>\n<script src='/Chat/ChatClient/EmbedChannel.js'></script>\n</body>\n</html>";
static NSString *const login = @"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n<html xmlns=\"http://www.w3.org/1999/xhtml\">\n\t<head>\n\t\t<style>\n\t\tbody {\n\t\t\tbackground-color: #A0BEAA;\n\t\t\tcolor: #222;\n\t\t\tpadding: 0px;\n\t\t\tfont-family: Helvetica; \n\t\t\tfont-size: 14px;\n\t\t\tmargin: 0;\n\t\t</style>\n\t\t<title>\n\t\t\tKeith and The Girl - Chat\n\t\t</title>\n\t</head>\n\t<body>\n\t\t<form name=\"form1\" method=\"post\" action=\"Chat-Login.aspx\" id=\"form1\">\n\t\t<div>\n\t\t\t<input type=\"hidden\" name=\"__VIEWSTATE\" id=\"__VIEWSTATE\" value=\"/wEPDwUKLTc5OTMzMDcwNGRkcLlfqCirqXv8EIUj6uUy+0NOPf4=\" />\n\t\t</div>\n\t\t<div>\n\t\t\t<input type=\"hidden\" name=\"__EVENTVALIDATION\" id=\"__EVENTVALIDATION\" value=\"/wEWBALhgMSLDQKPruq2CALyveCRDwKWrKCPD/QaK6bRO8dGjIGAkAaGAFzp5mX6\" />\n\t\t</div>\n\t\t<div align=\"center\">\n\t\t\t<div id=\"PanelLogin\">\n\t\t\t\t<table>\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<td valign=\"top\">\n\t\t\t\t\t\t\t<img id=\"ImageLogo\" src=\"%@\" width=\"160\" style=\"border-width:0px;-webkit-border-radius:10px;\" />\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td>\n\t\t\t\t\t\t\tTo connect to the chat room please use your\n\t\t\t\t\t\t\t<br />\n\t\t\t\t\t\t\tuser name and password from the\n\t\t\t\t\t\t\t<br />\n\t\t\t\t\t\t\t<em>Keith and The Girl Forums</em>.\n\t\t\t\t\t\t\t<br />\n\t\t\t\t\t\t\t<br />\n\t\t\t\t\t\t\tTo create a new account, <a href=\"/forums/register.php\" target=\"_parent\">click here</a>.\n\t\t\t\t\t\t\t<br />\n\t\t\t\t\t\t\tIf you've forgotten your password, <a href=\"/forums/login.php?do=lostpw\" target=\"_parent\">\n\t\t\t\t\t\t\t    click here</a>.<br />\n\t\t\t\t\t\t\t<table>\n\t\t\t\t\t\t\t\t<tr>\n\t\t\t\t\t\t\t\t\t<td style=\"width: 100px\" nowrap=\"noWrap\">\n\t\t\t\t\t\t\t\t\t\tUser name\n\t\t\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t\t\t<td style=\"width: 100px\">\n\t\t\t\t\t\t\t\t\t\t<input name=\"Username\" type=\"text\" id=\"Username\" />\n\t\t\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t\t</tr>\n\t\t\t\t\t\t\t\t<tr>\n\t\t\t\t\t\t\t\t\t<td style=\"width: 100px; height: 26px;\">\n\t\t\t\t\t\t\t\t\t\tPassword\n\t\t\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t\t\t<td style=\"width: 100px; height: 26px;\">\n\t\t\t\t\t\t\t\t\t\t<input name=\"password\" type=\"password\" id=\"password\" />\n\t\t\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t\t</tr>\n\t\t\t\t\t\t\t\t<tr>\n\t\t\t\t\t\t\t\t\t<td style=\"width: 100px; height: 26px\">\n\t\t\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t\t\t<td style=\"width: 100px; height: 26px\">\n\t\t\t\t\t\t\t\t\t\t<input type=\"submit\" name=\"ButtonLogin\" value=\"Login\" id=\"ButtonLogin\" />\n\t\t\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t\t</tr>\n\t\t\t\t\t\t\t</table>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t</tr>\n\t\t\t\t</table>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t</form>\n\t</body>\n</html>";

@interface OnAirViewControlleriPad (Private)
- (void)makeChat;
- (void)loadChatHTML;
- (void)registerKeyboardNotifications;
@end

@implementation OnAirViewControlleriPad
@synthesize chatContainerView, chatView, logout;
@synthesize tableView, eventsList;

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.tableView.rowHeight = 80;
	self.tableView.layer.cornerRadius = 15;
		
	[self makeChat];
	
	[self registerKeyboardNotifications];
}
- (void)viewDidAppear:(BOOL)animated
{
	
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[UIView beginAnimations:NULL context:NULL];
	[UIView setAnimationDuration:duration];
	if (toInterfaceOrientation == UIInterfaceOrientationPortrait ||
		toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		self.view.frame = CGRectMake(0, 0, 768, 955);
	}
	else {
		self.view.frame = CGRectMake(0, 0, 1024, 699);
	}
	[UIView commitAnimations];
	[self reloadTableView];
}
- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload 
{
    [super viewDidUnload];
}
- (void)dealloc 
{	
	[chatContainerView release];
	[chatView release];
	[logout release];
	[responseData release];
	
	[tableView release];
	[eventsList release];
	
	[nextLiveShowLabel release];
	
	[super dealloc];
}
#pragma mark -
#pragma mark Chat
#pragma mark -
- (void)makeChat
{
	[chatView decoration];
	responseData = nil;
	[self loadChatHTML];
}
- (void)loadChatHTML
{
//	NSString *boldPath = [[NSBundle mainBundle] pathForResource:@"bold" ofType:@"gif"];
//	boldPath = [boldPath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//	NSURL *boldURL = [NSURL fileURLWithPath:boldPath];
//	
//	NSString *italicPath = [[NSBundle mainBundle] pathForResource:@"italic" ofType:@"gif"];
//	italicPath = [italicPath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//	NSURL *italicURL = [NSURL fileURLWithPath:italicPath];
//	
//	NSString *underlinePath = [[NSBundle mainBundle] pathForResource:@"underline" ofType:@"gif"];
//	underlinePath = [underlinePath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//	NSURL *underlineURL = [NSURL fileURLWithPath:underlinePath];
	
	[chatView loadHTMLString:html 
					 baseURL:[NSURL URLWithString:@"http://www.keithandthegirl.com/chat/"]];
	
//	NSLog(@"%@", [NSString stringWithFormat:
//				  html, 
//				  [boldURL description]]);
}
- (void)loadLoginScreen
{
	NSString *logoPath = [[NSBundle mainBundle] pathForResource:@"BG" ofType:@"png"];
	logoPath = [logoPath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL *logoURL = [NSURL fileURLWithPath:logoPath];
	NSString *loginHTML = [NSString stringWithFormat:login, [logoURL description]];
	[chatView loadHTMLString:loginHTML baseURL:[NSURL URLWithString:@"http://www.keithandthegirl.com/chat/"]];
}
- (IBAction)logoutButtonPressed:(id)sender
{
	NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
	for (NSHTTPCookie *cookie in cookies)
	{
		[[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
	}
	[self loadChatHTML];
}
- (BOOL)webView:(UIWebView *)webView 
shouldStartLoadWithRequest:(NSURLRequest *)request 
 navigationType:(UIWebViewNavigationType)navigationType
{
#if LogWebViewRequests
	NSLog(@"\nRequest: %@\nHeaders: %@\nBody: %@", 
		  request, 
		  [request allHTTPHeaderFields], 
		  [[[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding] autorelease]);
#endif
	NSURL *loginURL = [NSURL URLWithString:@"http://www.keithandthegirl.com/chat/Chat-Login.aspx"];
	if (navigationType == UIWebViewNavigationTypeReload)
	{
		[self loadChatHTML];
		return NO;
	}
	if ([[request URL] isEqual:loginURL] &&
		[request HTTPBody] == nil)
	{
		[self loadLoginScreen];
		return NO;
	} else if ([[request URL] isEqual:loginURL] &&
			   [request HTTPBody] != nil)
	{
		[responseData release]; responseData = nil;
		responseData = [[NSMutableData alloc] init];
		[NSURLConnection connectionWithRequest:request delegate:self];
		return NO;
	}
	if ([[request URL] isEqual:[NSURL URLWithString:@"http://www.keithandthegirl.com/forums/register.php"]] ||
		[[request URL] isEqual:[NSURL URLWithString:@"http://www.keithandthegirl.com/forums/login.php?do=lostpw"]])
	{
		[[UIApplication sharedApplication] openURL:[request URL]];
		return NO;
	}
	return YES;
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *responseHTML = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	//NSLog(@"%@", responseHTML);
	if ([self loginSuccessful:responseHTML])
		[self loadChatHTML];
	else
		[self loadLoginScreen];
}
- (BOOL)loginSuccessful:(NSString *)html
{
	if ([html rangeOfString:@"LabelError" options:NSCaseInsensitiveSearch].location == NSNotFound)
		return YES;
	else
		return NO;
}
#pragma mark -
#pragma mark Keyboard Notifications
#pragma mark -
- (void)registerKeyboardNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(handleKeyboardWillShow:) 
												 name:UIKeyboardWillShowNotification 
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(handleKeyboardWillHide:) 
												 name:UIKeyboardWillHideNotification 
											   object:nil];
}
- (void)handleKeyboardWillShow:(NSNotification *)notification
{
	
}
- (void)handleKeyboardWillHide:(NSNotification *)notification
{
	
}
#pragma mark -
#pragma mark TableView
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"EventTableCell";
    static NSString *CellNib = @"EventTableCellView";
	
    EventTableCellView *cell = (EventTableCellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (EventTableCellView *)[nib objectAtIndex:0];
		cell.layer.cornerRadius = 15;
    }
	
    [[cell eventTitleLabel] setText:[[eventsList objectAtIndex:indexPath.row] objectForKey:@"Title"]];
	[[cell eventDayLabel] setText:[[eventsList objectAtIndex:indexPath.row] objectForKey:@"Day"]];
	[[cell eventDateLabel] setText:[[eventsList objectAtIndex:indexPath.row] objectForKey:@"Date"]];
	[[cell eventTimeLabel] setText:[[eventsList objectAtIndex:indexPath.row] objectForKey:@"Time"]];
	
	if ([[[eventsList objectAtIndex:indexPath.row] objectForKey:@"ShowType"] boolValue]) {
		[[cell eventTypeImageView] setImage:[UIImage imageNamed:@"LiveShowIconTrans.png"]];
	} else {
		[[cell eventTypeImageView] setImage:[UIImage imageNamed:@"EventIconTrans.png"]];
	}
		
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSDictionary *event = [eventsList objectAtIndex:indexPath.row];
	NSString *title = [event objectForKey:@"Title"];
	if (title)
		[self findGuest:title];
	if (popOverController != nil)
	{
		if ([popOverController isPopoverVisible])
		{
			[popOverController dismissPopoverAnimated:YES];
		}
		popOverController = nil;
	}
	EventsDetailViewController *viewController = 
	[[EventsDetailViewController alloc] initWithNibName:@"EventsDetailView" 
												 bundle:nil];
	[viewController setEvent:[eventsList objectAtIndex:indexPath.row]];
	popOverController = 
	[[UIPopoverController alloc] initWithContentViewController:viewController];
	[popOverController setPopoverContentSize:viewController.view.frame.size];
	NSArray *passThrough = [NSArray arrayWithObject:self.tableView];
	[popOverController setPassthroughViews:passThrough];
	CGRect frame = viewController.view.frame;
	CGRect rect = 
	CGRectMake(self.view.frame.size.width - self.tableView.frame.size.width, 
			   (self.view.frame.size.height / 2) - (frame.size.height / 2), 
			   frame.size.width, 
			   frame.size.height);
	[popOverController presentPopoverFromRect:rect
									   inView:self.view 
					 permittedArrowDirections:UIPopoverArrowDirectionRight 
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
#pragma mark Feedback
#pragma mark -
- (BOOL)textView:(UITextView *)textView 
shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
	if ([text isEqualToString:@"\n"])
	{
		[self sendFeedback];
		return NO;
	}
	return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[commentView becomeFirstResponder];
	return NO;
}
#pragma mark -
#pragma mark Data Delegates
#pragma mark -
- (void)events:(NSArray *)events
{
	[super events:events];
	if ([NSThread isMainThread])
	{
		if (events && events.count > 0)
		{
			[self setEventsList:events];
			[self reloadTableView];
		}
	}
	else
	{
		[self performSelectorOnMainThread:@selector(events:) 
							   withObject:events 
							waitUntilDone:NO];
	}
}

@end
