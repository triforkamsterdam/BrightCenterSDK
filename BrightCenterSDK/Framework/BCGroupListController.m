#import "BCGroupListController.h"
#import "BCHeaderView.h"
#import "BCTableCell.h"
#import "BCGroup.h"
#import "BCStudentListController.h"

#define NAVIGATION_BAR_HEIGHT 70.0

@implementation BCGroupListController {

    BCHeaderView *headerView;

    UITableView *tableView;

    NSArray *groups;
}

- (void) viewDidLoad {
    headerView = [BCHeaderView new];
    [self.view addSubview:headerView];
    headerView.text = @"groepen";
    headerView.backgroundColor = [UIColor colorWithWhite:136 / 255.0 alpha:1.0];
    headerView.textColor = [UIColor colorWithWhite:220 / 255.0 alpha:1.0];

    tableView = [UITableView new];
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor colorWithWhite:79 / 255.0 alpha:1.0];
    tableView.rowHeight = 75.0;
    tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
}

- (NSArray *) groups {
    return groups;
}

- (void) setGroups:(NSArray *) theGroups {
    groups = theGroups;
    [tableView reloadData];
}

- (void) selectGroup:(BCGroup *) group {
    NSInteger index = [groups indexOfObject:group];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];

    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    self.studentListController.students = group.students;
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    headerView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, NAVIGATION_BAR_HEIGHT);
    tableView.frame = CGRectMake(0.0, NAVIGATION_BAR_HEIGHT,
            self.view.frame.size.width, self.view.frame.size.height - NAVIGATION_BAR_HEIGHT);
}

- (UITableViewCell *) tableView:(UITableView *) tv cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    static NSString *identifier = @"BCTableCell";
    BCTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[BCTableCell alloc] initWithReuseIdentifier:identifier];
        cell.textLabel.textColor = [UIColor colorWithWhite:174 / 255.0 alpha:1.0];
        [cell addLogoToSelectedBackground];
    }

    BCGroup *group = groups[(NSUInteger) indexPath.row];
    cell.textLabel.text = group.name;

    return cell;
}

- (NSInteger) tableView:(UITableView *) tv numberOfRowsInSection:(NSInteger) section {
    return [groups count];
}

- (void) tableView:(UITableView *) tableView1 didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    BCGroup *group = groups[(NSUInteger) indexPath.row];
    self.studentListController.students = group.students;
}

@end