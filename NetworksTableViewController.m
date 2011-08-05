//
//  NetworksTableViewController.m
//  inSSIDer.iOS
//
//  Created by Ben Bower on 7/14/11.
//  Copyright 2011 MetaGeek, LLC. All rights reserved.
//

#import "NetworksTableViewController.h"

@interface NetworksTableViewController()
@property (retain) NSMutableDictionary *networks;
@property (retain) NSMutableArray *rows;
@end

@implementation NetworksTableViewController

@synthesize networks, rows;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	networks = [[NSMutableDictionary alloc] init];
	rows = [[NSMutableArray alloc] init];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

 
/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.rows.count;
}

- (NSString *)networkDataAtIndexPath:(NSIndexPath *)indexPath
{
	return [networks valueForKey:[rows objectAtIndex:indexPath.row]];
	//return [rows objectAtIndex:indexPath.row];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	tableView.separatorColor = [UIColor blackColor];
	
    static NSString *CellIdentifier = @"NetworksTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = [rows objectAtIndex:indexPath.row];
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.backgroundColor = [UIColor darkGrayColor];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
		NSString *row = [self.rows objectAtIndex:indexPath.row];
		[self.networks removeObjectForKey:row];
		// Delete the row from the table view
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	/*
    // Navigation logic may go here. Create and push another view controller.
    
    UIViewController *detailViewController = [[UIViewController alloc] initWithNibName:@"NetworksDetailView" bundle:nil];
	UITextView *detailedNetworkData = [[UITextView alloc] initWithFrame:self.view.frame];
	detailedNetworkData.text = [networks valueForKey:[rows objectAtIndex:indexPath.row]];
	detailViewController.view = detailedNetworkData;
     // ...
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
	
	ndc = [[NetworkDetailController alloc] init];
	ndc.networkDetail = [self networkDataAtIndexPath:indexPath];
	[self.navigationController pushViewController:ndc animated:YES];
	
	selectedNetworkPath = indexPath;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)setNetworksObject:(NSString *)data ForKey:(NSString *)ssid {
	if (ssid)
	{
		[networks setObject:data forKey:ssid];
	}
}

- (void)setRowSsid:(NSString *)ssid {
	if (ssid)
	{
		BOOL alreadySeen = NO;
	
		for(NSString *s in rows)
		{
			if ([s isEqualToString:ssid])
				alreadySeen = YES;
		}
	
		if(!alreadySeen)
			[rows addObject:ssid];
	}
}

- (void)updateNetworkDetailView
{
	if (ndc.view.window)
	{
		ndc.networkDetail = [self networkDataAtIndexPath:selectedNetworkPath];
		[ndc viewWillAppear:NO];
	}
}


- (void)dealloc {
	[networks release];
	[rows release];
	[ndc release];
    [super dealloc];
}


@end

