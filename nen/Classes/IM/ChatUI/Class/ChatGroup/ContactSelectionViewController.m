/************************************************************
  *  * Hyphenate CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2016 Hyphenate Inc. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of Hyphenate Inc.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from Hyphenate Inc.
  */

#import "ContactSelectionViewController.h"

#import "EMRemarkImageView.h"
#import "BaseTableViewCell.h"
#import "RealtimeSearchUtil.h"

@interface ContactSelectionViewController ()

@property (strong, nonatomic) NSMutableArray *contactsSource;
@property (strong, nonatomic) NSMutableArray *selectedContacts;
@property (strong, nonatomic) NSMutableArray *blockSelectedUsernames;

@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) UIScrollView *footerScrollView;
@property (strong, nonatomic) UIButton *doneButton;

@property (nonatomic) BOOL presetDataSource;

@end

@implementation ContactSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _contactsSource = [NSMutableArray array];
        _selectedContacts = [NSMutableArray array];
        
        [self setObjectComparisonStringBlock:^NSString *(id object) {
            return object;
        }];
        
        [self setComparisonObjectSelector:^NSComparisonResult(id object1, id object2) {
            NSString *username1 = (NSString *)object1;
            NSString *username2 = (NSString *)object2;
            
            return [username1 caseInsensitiveCompare:username2];
        }];
    }
    return self;
}

- (instancetype)initWithBlockSelectedUsernames:(NSArray *)blockUsernames
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _blockSelectedUsernames = [NSMutableArray array];
        [_blockSelectedUsernames addObjectsFromArray:blockUsernames];
    }
    
    return self;
}

- (instancetype)initWithContacts:(NSArray *)contacts
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _presetDataSource = YES;
        [_contactsSource addObjectsFromArray:contacts];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"title.chooseContact", @"select the contact");
    self.navigationItem.rightBarButtonItem = nil;
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backButton.accessibilityIdentifier = @"back";
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    [self.view addSubview:self.footerView];
    self.tableView.editing = YES;
    
    if ([_blockSelectedUsernames count] > 0) {
        for (NSString *username in _blockSelectedUsernames) {
            NSInteger section = [self sectionForString:username];
            NSMutableArray *tmpArray = [_dataSource objectAtIndex:section];
            if (tmpArray && [tmpArray count] > 0) {
                for (int i = 0; i < [tmpArray count]; i++) {
                    NSString *buddy = [tmpArray objectAtIndex:i];
                    if ([buddy isEqualToString:username]) {
                        [self.selectedContacts addObject:buddy];
                        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:section] animated:NO scrollPosition:UITableViewScrollPositionNone];
                        
                        break;
                    }
                }
            }
        }
        
        if ([_selectedContacts count] > 0) {
            [self reloadFooterView];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

- (UIView *)footerView
{
    if (self.mulChoice && _footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
        _footerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _footerView.backgroundColor = [UIColor colorWithRed:207 / 255.0 green:210 /255.0 blue:213 / 255.0 alpha:0.7];
        
        _footerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, _footerView.frame.size.width - 30 - 70, _footerView.frame.size.height - 5)];
        _footerScrollView.backgroundColor = [UIColor clearColor];
        [_footerView addSubview:_footerScrollView];
        
        _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(_footerView.frame.size.width - 80, 8, 70, _footerView.frame.size.height - 16)];
        _doneButton.accessibilityIdentifier = @"done_button";
        [_doneButton setBackgroundColor:[UIColor colorWithRed:10 / 255.0 green:82 / 255.0 blue:104 / 255.0 alpha:1.0]];
        [_doneButton setTitle:NSLocalizedString(@"accept", @"Accept") forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_doneButton setTitle:NSLocalizedString(@"ok", @"OK") forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:_doneButton];
    }
    
    return _footerView;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactListCell";
    BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *username = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"chatListCellHead.png"];
    cell.textLabel.text = username;
    cell.username = username;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if ([_blockSelectedUsernames count] > 0) {
        NSString *username = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        return ![self isBlockUsername:username];
    }
    
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (self.mulChoice) {
        if (![self.selectedContacts containsObject:object])
        {
            [self.selectedContacts addObject:object];
            [self reloadFooterView];
        }
    }
    else {
        [self.selectedContacts addObject:object];
        [self doneAction:nil];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *username = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([self.selectedContacts containsObject:username]) {
        [self.selectedContacts removeObject:username];
        
        [self reloadFooterView];
    }
}

#pragma mark - private

- (BOOL)isBlockUsername:(NSString *)username
{
    if (username && [username length] > 0) {
        if ([_blockSelectedUsernames count] > 0) {
            for (NSString *tmpName in _blockSelectedUsernames) {
                if ([username isEqualToString:tmpName]) {
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

- (void)reloadFooterView
{
    if (self.mulChoice) {
        [self.footerScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        CGFloat imageSize = self.footerScrollView.frame.size.height;
        NSInteger count = [self.selectedContacts count];
        self.footerScrollView.contentSize = CGSizeMake(imageSize * count, imageSize);
        for (int i = 0; i < count; i++) {
            NSString *username = [self.selectedContacts objectAtIndex:i];
            EMRemarkImageView *remarkView = [[EMRemarkImageView alloc] initWithFrame:CGRectMake(i * imageSize, 0, imageSize, imageSize)];
            remarkView.image = [UIImage imageNamed:@"chatListCellHead.png"];
            remarkView.remark = username;
            [self.footerScrollView addSubview:remarkView];
        }
        
        if ([self.selectedContacts count] == 0) {
            [_doneButton setTitle:NSLocalizedString(@"ok", @"OK") forState:UIControlStateNormal];
        }
        else{
            [_doneButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"doneWithCount", @"Done(%i)"), [self.selectedContacts count]] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - public

- (void)loadDataSource
{
    if (!_presetDataSource) {
        [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
        [_dataSource removeAllObjects];
        [_contactsSource removeAllObjects];
        
        NSArray *buddyList = [[EMClient sharedClient].contactManager getContacts];
        for (NSString *username in buddyList) {
            [self.contactsSource addObject:username];
        }
        
        [_dataSource addObjectsFromArray:[self sortRecords:self.contactsSource]];
        
        [self hideHud];
    }
    else {
        _dataSource = [[self sortRecords:self.contactsSource] mutableCopy];
    }
    [self.tableView reloadData];
}

- (void)doneAction:(id)sender
{
    BOOL isPop = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(viewController:didFinishSelectedSources:)]) {
        if ([_blockSelectedUsernames count] == 0) {
            isPop = [_delegate viewController:self didFinishSelectedSources:self.selectedContacts];
        }
        else{
            NSMutableArray *resultArray = [NSMutableArray array];
            for (NSString *username in self.selectedContacts) {
                if(![self isBlockUsername:username])
                {
                    [resultArray addObject:username];
                }
            }
            isPop = [_delegate viewController:self didFinishSelectedSources:resultArray];
        }
    }
    
    if (isPop) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)backAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(viewControllerDidSelectBack:)]) {
        [_delegate viewControllerDidSelectBack:self];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end