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
#import "Section.h"

@interface BanksTableViewController ()

@property (strong, nonatomic) NSArray *BanksData;
@property (strong, nonatomic) NSMutableArray *adresses;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSOperationQueue *searchOperation;
@property (assign, nonatomic) NSUInteger checkedIndex;

@end

@implementation BanksTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.checkedIndex = 0;
    self.searchBar.delegate = self;
    
    Fetcher *fetcher = [[Fetcher alloc] init];
    
    self.BanksData = [fetcher dataForTableView];
    
    self.BanksData = [self.BanksData sortedArrayUsingComparator:^NSComparisonResult(id a, id  b)
    {
        NSString *first = [(ReportDataForTable *)a bankRegion];
        NSString *second = [(ReportDataForTable *)b bankRegion];
        return [first compare:second];
    }];
    self.BanksData = [self arraySortedInSections:self.BanksData];
    
    [self.tableView registerClass:[BanksTVCell class] forCellReuseIdentifier:@"banksCell"];
}

-(NSArray *) arraySortedInSections: (NSArray *) banks
{
    NSMutableArray *sectionedBanks = [[NSMutableArray alloc] init];
    
    Section *section = [[Section alloc] init];
    section.name = [[banks firstObject] bankRegion];
    section.banks = [[NSMutableArray alloc] init];
    for (ReportDataForTable *bank in banks)
    {
        if ( [[bank bankRegion] isEqualToString:section.name])
        {
            [section.banks addObject:bank];
        }
        else
        {
            [sectionedBanks addObject:section];
            section = [[Section alloc] init];
            section.name = [bank bankRegion];
            section.banks = [[NSMutableArray alloc] initWithObjects:bank, nil];
        }
    }
    return sectionedBanks;
}

//-(NSArray)

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.BanksData count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.BanksData objectAtIndex:section] name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[(Section *)[self.BanksData objectAtIndex:section] banks] count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BanksTVCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"banksCell"];
    
    //    if (indexPath.row == 0)
    //    {
    Section * section = [self.BanksData objectAtIndex:indexPath.section];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", [[section.banks objectAtIndex:indexPath.row] bankName]];
    cell.regionLabel.text = [NSString stringWithFormat:@"%@", [[section.banks objectAtIndex:indexPath.row] bankRegion]];
    cell.cityLabel.text = [NSString stringWithFormat:@"%@", [[section.banks objectAtIndex:indexPath.row] bankCity]];
    cell.streetLabel.text = [NSString stringWithFormat:@"%@", [[section.banks objectAtIndex:indexPath.row] bankStreet]];
    
    //    }
    //    else
    //    {
    //        id branches = [[self.BanksData objectAtIndex:indexPath.section] branchs];
    //        cell.nameLabel.text = [NSString stringWithFormat:@"%@", [[branches objectAtIndex:(indexPath.row - 1)] valueForKey:@"name"]];
    //        cell.regionLabel.text = [NSString stringWithFormat:@"%@", [[branches objectAtIndex:(indexPath.row - 1)] valueForKey:@"region"]];
    //        cell.cityLabel.text = [NSString stringWithFormat:@"%@", [[branches objectAtIndex:(indexPath.row - 1)] valueForKey:@"city"]];
    //        cell.streetLabel.text = [NSString stringWithFormat:@"%@", [[branches objectAtIndex:(indexPath.row - 1)] valueForKey:@"street"]];
    //    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.adresses = [[NSMutableArray alloc] init];

    
    //[adresses addObject: [[self.BanksData objectAtIndex:indexPath.section] ]];
    if (self.checkedIndex == 0)
    {
        for (ReportDataForTable *bank in [[self.BanksData objectAtIndex:indexPath.section] banks])
        {
            NSString *adress = [NSString stringWithFormat:@"%@, %@, %@, Украина", bank.bankStreet, bank.bankCity, bank.bankRegion];
            [self.adresses addObject:adress];
        }
        self.checkedIndex = indexPath.row;
        [self performSegueWithIdentifier:@"showMapView" sender:self];
    }

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showMapView"])
    {
        [[segue destinationViewController] adressesToDisplay:self.adresses centerOn:[self.adresses objectAtIndex:self.checkedIndex]];
        self.checkedIndex = 0;
    }
}

#pragma mark - search bar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchOperation cancelAllOperations];
    self.searchOperation = [NSOperationQueue currentQueue];
    [self.searchOperation addOperationWithBlock:^{
        for (Section *section in self.BanksData)
        {
        //    section.banks = [section.banks filterUsingPredicate:[NSPredicate predicateWithFormat:@"bankName like %@", searchText]];
        }
    }];
    
    //NSOperation *operation = [[NSOperation alloc] i]
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
