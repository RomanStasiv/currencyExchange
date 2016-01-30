//
//  TestCoreData.m
//  CurrencyExchange
//
//  Created by Vitaliy Yarkun on 29.01.16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "TestCoreData.h"
#import "BankData.h"
#import "CurrencyData.h"
#import "BranchData.h"
#import "AppDelegate.h"

@interface TestCoreData ()

@property (strong, nonatomic) NSManagedObjectContext* context;
@property (assign, nonatomic) NSInteger banksCount;
@property (assign, nonatomic) NSInteger branchesCount;
@property (assign, nonatomic) NSInteger currenciesCount;



@end

@implementation TestCoreData

static NSString* cities[] = {@"Semykhatka",@"Staraya Kuzhel’",@"Круглий",@"Текля",@"Мала Олександрівка",
                             @"Gavro",@"Zadvuzhe",@"Khutor Borutin",@"Shumskoye",@"Sudkovska Volya",
                             @"Vaserovka",@"Khoroshevo",@"Imstichevo",@"Verkhniye Serogozy",
                             @"Pen’ki",@"Yaltushkov",@"Dobrovlyany",@"Sukholuch’ye",@"Vydra",@"Червона Слобода",
                             @"Zorinovka",@"Pervomayskiy",@"Кар’єрне",@"Havrylivka Druha",@"Yagodzin",
                             @"Aleksandrogil’f",@"Troitsk",@"Дулово",@"Kvasovsk Menculi",@"Telyazh",
                             @"Ruda Brodzha",@"Lyutynsk",@"Volosin’",@"Soltysy",@"Zamirtsy",
                             @"Shymkivtsi",@"Podgortse",@"Великий Самбір",@"Sorokino",@"Madar",
                             @"Proyezzheye",@"Chukaluvka",@"Risove",@"Trylisy",@"Kichkas",
                             @"Rechki",@"Мороча",@"Uhil’tsi",@"Korostovitsy",@"Lipetska Polyana"};

static NSString* addresses[] = {@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"G",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"};

-(void) insertFakeDataToCoreData
{
    self.context = [AppDelegate singleton].managedObjectContext;
    self.banksCount = 10;
    self.branchesCount = 5;
    self.currenciesCount = 20;
    
    NSError* error = nil;
    
    NSMutableArray* tempBankArray = [[NSMutableArray alloc] init];
    NSMutableArray* tempDateArray = [[NSMutableArray alloc] init];
    NSInteger currencyCounter = 0;
    NSInteger bankCurrencyDifference = 0;
    
    for (int bankCounter = 0; bankCounter < self.banksCount; bankCounter++)
    {
        BankData* fakeBank = [self bankDataByIndex:bankCounter];
        [tempBankArray addObject:fakeBank];
    }
    
    for (int dateCounter = 0; dateCounter < self.currenciesCount; dateCounter++)
    {
        NSDate* tempDate = [self generateRandomDateWithinDaysBeforeToday:200];
        [tempDateArray addObject:tempDate];
    }
    
    for (BankData* bankObject in tempBankArray) {
        
        currencyCounter = 0;
        
        for (NSDate* dateObject in tempDateArray)
        {
            CurrencyData* fakeCurrency = [self currencyDataByIndex:currencyCounter withEUR:20 + bankCurrencyDifference withUSD:18 + bankCurrencyDifference withDate:dateObject];
            [bankObject addCurrencyObject:fakeCurrency];
            currencyCounter++;

        }
        
        for (int j = 0; j < self.branchesCount; j++)
        {
            BranchData* fakeBranch = [self branchDataByIndex:j];
            [bankObject addBranchObject:fakeBranch];
        }
        bankCurrencyDifference++;
        
        
    }
    
    if (![self.context save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
}


-(BankData*) bankDataByIndex:(NSInteger) bankIndex
{
    
    BankData* bank = [NSEntityDescription insertNewObjectForEntityForName:@"BankData" inManagedObjectContext:self.context];
    bank.name = [NSString stringWithFormat:@"Bank #%ld", bankIndex];
    bank.region = [NSString stringWithFormat:@"Bank region #%ld", bankIndex];
    bank.city = [NSString stringWithFormat:@"%@",cities[arc4random_uniform(50)]];
    bank.address = [NSString stringWithFormat:@"%@", addresses[arc4random_uniform(26)]];
    
    return bank;
    
}

-(BranchData*) branchDataByIndex:(NSInteger) branchIndex
{
    
    BranchData* branch = [NSEntityDescription insertNewObjectForEntityForName:@"BranchData" inManagedObjectContext:self.context];
    branch.name = [NSString stringWithFormat:@"Branch #%ld", branchIndex];
    branch.region = [NSString stringWithFormat:@"Branch region #%ld", branchIndex];
    branch.city = [NSString stringWithFormat:@"%@",cities[arc4random_uniform(50)]];
    branch.address = [NSString stringWithFormat:@"%@", addresses[arc4random_uniform(26)]];
    return branch;
    
}

-(CurrencyData*) currencyDataByIndex:(NSInteger) currencyIndex withEUR:(NSInteger) eur withUSD:(NSInteger) usd withDate:(NSDate*) date
{
    
    CurrencyData* currency = [NSEntityDescription insertNewObjectForEntityForName:@"CurrencyData" inManagedObjectContext:self.context];
    currency.date = date;
    currency.eurCurrencyAsk = [NSString stringWithFormat:@"%ld", eur+currencyIndex];
    currency.eurCurrencyBid = [NSString stringWithFormat:@"%ld", (eur-2)+currencyIndex];
    currency.usdCurrencyAsk = [NSString stringWithFormat:@"%ld", usd+currencyIndex];
    currency.usdCurrencyBid = [NSString stringWithFormat:@"%ld", (usd-2)+currencyIndex];

    return currency;
    
}

- (NSDate *) generateRandomDateWithinDaysBeforeToday:(int)days
{
    int r1 = arc4random_uniform(days);
    int r2 = arc4random_uniform(23);
    int r3 = arc4random_uniform(59);
    
    NSDate *today = [NSDate new];
    NSCalendar *gregorian =
    [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *offsetComponents = [NSDateComponents new];
    [offsetComponents setDay:(r1*-1)];
    [offsetComponents setHour:r2];
    [offsetComponents setMinute:r3];
    
    NSDate *rndDate1 = [gregorian dateByAddingComponents:offsetComponents
                                                  toDate:today options:0];
    
    return rndDate1;
}






@end
