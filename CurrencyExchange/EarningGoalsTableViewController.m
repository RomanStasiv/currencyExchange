//
//  EarningGoalsTableViewController.m
//  CurrencyExchange
//
//  Created by alex4eetah on 1/31/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "EarningGoalsTableViewController.h"
#import "CustomEGTableViewCell.h"
#import "CDControlPoint.h"
#import "ShareGoalsViewController.h"
#import "EarnMoneyViewController.h"

@interface EarningGoalsTableViewController ()

@end

@implementation EarningGoalsTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                target:self
                                                                                action:@selector(actionEdit:)];
    self.navigationItem.rightBarButtonItem = editButton;
}

- (void) actionEdit:(UIBarButtonItem*) sender
{
    BOOL isEditing = self.tableView.editing;
    
    [self.tableView setEditing:!isEditing animated:YES];
    
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
    
    if (self.tableView.editing)
    {
        item = UIBarButtonSystemItemDone;
    }
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item
                                                                                target:self
                                                                                action:@selector(actionEdit:)];
    [self.navigationItem setRightBarButtonItem:editButton animated:YES];
}


- (ControlPointCDManager *)manager
{
    if (!_manager)
    {
        _manager = [[ControlPointCDManager alloc] init];
    }
    return _manager;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchResultController sections][section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"EGCell";
    
    CustomEGTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(CustomEGTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    CDControlPoint *CDobject = [self.fetchResultController objectAtIndexPath:indexPath];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"dd-MM-yyyy HH:mm"];

    cell.investingDate.text = [dateFormater stringFromDate:CDobject.date];
    cell.investingCurrency.text = CDobject.currency;
    cell.investingAmount.text = [NSString stringWithFormat:@"%.02f", [CDobject.value floatValue]];
    cell.earningAmount.text = [NSString stringWithFormat:@"%.03f", [CDobject.earningPosibility floatValue]];
    
   /* cell.removeControlPoint.tag = indexPath.row;
    [cell.removeControlPoint addTarget:self
                               action:@selector(removeControlPoint:)
                     forControlEvents:UIControlEventTouchUpInside];*/
    cell.shareButton.tag = indexPath.row;
    [cell.shareButton addTarget:self
                         action:@selector(showAnotherViewController:)
               forControlEvents:UIControlEventTouchUpInside];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        CDControlPoint *CDobject = [self.fetchResultController objectAtIndexPath:indexPath];
        
        ControlPointCDManager *manager = [ControlPointCDManager sharedManager];
        [manager deleteFromCDControlPoint:CDobject];
        
        [self.graphViewControllerDelegate restoreAllControlPointsFromCD];
        [self.graphViewControllerDelegate performAddNavButtonsLogic];
        [self.graphViewControllerDelegate redrawGraphView];
    }
    
}

#pragma mark - NSFetchedResultsControllerDelegate
- (NSFetchedResultsController *)fetchResultController
{
    if (_fetchResultController != nil) {
        return _fetchResultController;
    }
    
    NSManagedObjectContext *moc = self.manager.context;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CDControlPoint" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"earningPosibility > 0"];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    [fetchRequest setSortDescriptors:@[descriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:moc
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchResultController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchResultController performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _fetchResultController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark - UITableViewDelegate
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


#pragma mark - CellButtonIvents
- (void)showAnotherViewController:(UIButton *)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    CDControlPoint *CDobject = [self.fetchResultController objectAtIndexPath:indexPath];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShareGoalsViewController * shareGoalsVC = (ShareGoalsViewController *)[sb instantiateViewControllerWithIdentifier:@"shareGoalsVC"];
    UIImage *image = [self.graphViewControllerDelegate getImageToShareForControlPoint:CDobject];
    shareGoalsVC.imageToShare = image;
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController pushViewController:shareGoalsVC animated:YES];
}


@end
