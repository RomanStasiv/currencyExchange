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

@property (strong, nonatomic) NSMutableArray *BanksData;
@property (strong, nonatomic) NSMutableArray *BanksDataUnfiltered;

@property (strong, nonatomic) NSMutableArray *adresses;
@property (strong, nonatomic) NSMutableArray *bankNames;

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
    
    [self.BanksData sortUsingComparator:^NSComparisonResult(id a, id  b)
    {
        NSString *first = [(ReportDataForTable *)a bankRegion];
        NSString *second = [(ReportDataForTable *)b bankRegion];
        return [first compare:second];
    }];
    self.BanksData = [self arraySortedInSections:self.BanksData];
    self.BanksDataUnfiltered = self.BanksData;
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sunsat_patternColor"]];
    
    self.searchBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sunsat_patternColor"]];
    
    [self.tableView registerClass:[BanksTVCell class] forCellReuseIdentifier:@"banksCell"];
}

-(NSMutableArray *) arraySortedInSections: (NSMutableArray *) banks
{
    NSMutableArray *sectionedBanks = [[NSMutableArray alloc] init];
    
    NSMutableArray * sectionNames = [[NSMutableArray alloc] init];
    Section *section = [[Section alloc] init];
    section.name = [[banks firstObject] bankRegion];
    [sectionNames addObject:section.name];
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
            [sectionNames addObject:section.name];
            section.banks = [[NSMutableArray alloc] initWithObjects:bank, nil];
        }
    }
    [sectionedBanks addObject:section];
    for (ReportDataForTable *bank in banks)
    {
        for (ReportDataForTable *branch in [bank branchs])
        {
            if ([sectionNames indexOfObject:[branch bankRegion]] != NSNotFound)
            {
                [[[sectionedBanks objectAtIndex:[sectionNames indexOfObject:[branch bankRegion]]] banks] addObject:branch];
            }
            else
            {
                Section *section = [[Section alloc] init];
                section.name = [branch bankRegion];
                [sectionNames addObject:section.name];
                section.banks = [[NSMutableArray alloc] init];
                [section.banks addObject:branch];
                [sectionedBanks addObject:section];
            }
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
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BanksTVCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"banksCell"];
    

    Section * section = [self.BanksData objectAtIndex:indexPath.section];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", [[section.banks objectAtIndex:indexPath.row] bankName]];
    cell.cityLabel.text = [NSString stringWithFormat:@"%@", [[section.banks objectAtIndex:indexPath.row] bankCity]];
    cell.streetLabel.text = [NSString stringWithFormat:@"%@", [[section.banks objectAtIndex:indexPath.row] bankStreet]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.adresses = [[NSMutableArray alloc] init];
    self.bankNames = [[NSMutableArray alloc] init];

    //[adresses addObject: [[self.BanksData objectAtIndex:indexPath.section] ]];
    if (self.checkedIndex == 0)
    {
        for (ReportDataForTable *bank in [[self.BanksData objectAtIndex:indexPath.section] banks])
        {
            NSString *adress = [NSString stringWithFormat:@"%@, %@, %@, Украина", bank.bankStreet, bank.bankCity, bank.bankRegion];
            [self.adresses addObject:adress];
            [self.bankNames addObject:bank.bankName];
            
        }
        self.checkedIndex = indexPath.row;
        [self performSegueWithIdentifier:@"showMapView" sender:self];
    }

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showMapView"])
    {
        [[segue destinationViewController] adressesToDisplay:self.adresses withNames:self.bankNames centerOn:[self.adresses objectAtIndex:self.checkedIndex]];
        self.checkedIndex = 0;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sunsat_patternColor"]];
}

#pragma mark - search bar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchOperation cancelAllOperations];
    if (!self.searchOperation)
        self.searchOperation = [NSOperationQueue currentQueue];
    __weak __block BanksTableViewController *weakSelf = self;
    if ([searchText isEqualToString:@""])
    {
        self.BanksData = self.BanksDataUnfiltered;
    }
    else
    {
        NSBlockOperation * blockOperation = [NSBlockOperation blockOperationWithBlock:
                                             ^{
                                                 NSArray * arrayToFilter = [weakSelf.BanksDataUnfiltered copy];
                                                 NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
                                                 for (Section * section in arrayToFilter)
                                                 {
                                                     Section * filteredSect = [[Section alloc] init];
                                                     filteredSect.name = section.name;
                                                     filteredSect.banks = [section.banks copy];
                                                     filteredSect.banks = [[filteredSect.banks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"bankName contains[cd] %@", searchText]] mutableCopy];
                                                     if ([filteredSect.banks count] != 0)
                                                     {
                                                         [filteredArray addObject:filteredSect];
                                                     }
                                                 }
                                                 weakSelf.BanksData = filteredArray;
                                                 [weakSelf.tableView reloadData];
                                             }];
        [self.searchOperation addOperation:blockOperation];
    }
}

@end
