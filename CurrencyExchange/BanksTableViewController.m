//
//  BanksTableViewController.m
//  CurrencyExchange
//
//  Created by alex4eetah on 1/26/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "BanksTableViewController.h"
#import "Fetcher.h"
#import "MapViewController.h"
#import "BanksTVCell.h"

@interface BanksTableViewController ()

@property (strong, nonatomic) NSArray *BanksData;
@property (strong, nonatomic) NSMutableArray *adresses;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BanksTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Fetcher *fetcher = [[Fetcher alloc] init];
    
    self.BanksData = [fetcher dataForTableView];
    
    [self.tableView registerClass:[BanksTVCell class] forCellReuseIdentifier:@"banksCell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.BanksData count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.BanksData objectAtIndex:section] bankName];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[(ReportDataForTable *)[self.BanksData objectAtIndex:section] branchs] count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BanksTVCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"banksCell"];
    
    if (!cell)
        cell = [[BanksTVCell alloc] init];
    
    
    
    if (indexPath.row == 0)
    {
        cell.nameLabel.text = [NSString stringWithFormat:@"%@", [[self.BanksData objectAtIndex:indexPath.section] bankName]] ;
        cell.adressLabel.text = [NSString stringWithFormat:@"%@", @"noadresssrybro"];
    }
    else
    {
        id branches = [[self.BanksData objectAtIndex:indexPath.section] branchs];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@", [[branches objectAtIndex:(indexPath.row - 1)] valueForKey:@"name"]];
        cell.adressLabel.text = [NSString stringWithFormat:@"%@", [[branches objectAtIndex:(indexPath.row - 1)] valueForKey:@"adress"]];
    }
    return cell;
}

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.adresses = [[NSMutableArray alloc] init];

    
    //[adresses addObject: [[self.BanksData objectAtIndex:indexPath.section] ]];
    
    
    for (NSMutableDictionary *branch in [[self.BanksData objectAtIndex:indexPath.section] branchs])
    {
        [self.adresses addObject:[branch valueForKey:@"adress"]];
    }
    
    [self performSegueWithIdentifier:@"showMapView" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showMapView"])
    {
        ((MapViewController *)[segue destinationViewController]).adresses = self.adresses;
    }
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
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
