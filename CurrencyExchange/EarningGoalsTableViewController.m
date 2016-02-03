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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm"];

    cell.investingDate.text = [dateFormater stringFromDate:CDobject.date];
    cell.investingCurrency.text = CDobject.currency;
    cell.investingAmount.text = [NSString stringWithFormat:@"%.02f", [CDobject.value floatValue]];
    cell.EarningAmount.text = [NSString stringWithFormat:@"%.03f", [CDobject.earningPosibility floatValue]];
    
    /*cell.showOnGraphButton.tag = 1;
    [cell.showOnGraphButton addTarget:self
                               action:@selector(showAnotherViewController:)
                     forControlEvents:UIControlEventTouchUpInside];*/
    cell.ShareButton.tag = indexPath.row;
    [cell.ShareButton addTarget:self
                         action:@selector(showAnotherViewController:)
               forControlEvents:UIControlEventTouchUpInside];
}

/*- (BOOL)isControlPointValidToDisplay:(CDControlPoint *)CDPoint
{
    ControllPoint *object = [[ControllPoint alloc] init];
    object.date = CDPoint.date;
    object.value = CDPoint.value;
    object.currency = CDPoint.currency;
    object.exChangeCource = CDPoint.exChangeCource;
    [object calculateEarningPosibilityWithaverageCurrencyObjectsArray:self.averageCurrencyObjectsArray];
    
    return ([object.earningPosibility floatValue] > 0);
}*/


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

#pragma mark - Navigation
- (void)showAnotherViewController:(UIButton *)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    CDControlPoint *CDobject = [self.fetchResultController objectAtIndexPath:indexPath];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShareGoalsViewController * shareGoalsVC = (ShareGoalsViewController *)[sb instantiateViewControllerWithIdentifier:@"shareGoalsVC"];
    UIImage *image = [self.imageGetterDelegate getImageToShareForControlPoint:CDobject];
    shareGoalsVC.imageToShare = image;
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController pushViewController:shareGoalsVC animated:YES];
    
    /*switch (sender.tag)
    {
        case 1:
            //do delegate job
            break;
            
        case 2:
        {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ShareGoalsViewController * shareGoalsVC = (ShareGoalsViewController *)[sb instantiateViewControllerWithIdentifier:@"shareGoalsVC"];
            shareGoalsVC.imageView.image = self.imageGetterDelegate getImageToShareForControlPoint:<#(CDControlPoint *)#>
            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController pushViewController:shareGoalsVC animated:YES];
        }
            break;
            
        default:
            break;
    }*/
}

/*


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
