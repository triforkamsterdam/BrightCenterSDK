#import "BCStudentListController.h"
#import "BCHeaderView.h"
#import "BCTableCell.h"
#import "BCStudent.h"
#import "BCStudentPickerController.h"

#define NAVIGATION_BAR_HEIGHT 70.0

@implementation BCStudentListController {

    BCHeaderView *headerView;

    UITableView *tableView;

    NSArray *students;
}

- (void) viewDidLoad {
    headerView = [BCHeaderView new];
    [self.view addSubview:headerView];
    headerView.text = @"leerlingen";
    headerView.backgroundColor = [UIColor colorWithWhite:214 / 255.0 alpha:1.0];
    headerView.textColor = [UIColor colorWithWhite:67 / 255.0 alpha:1.0];

    tableView = [UITableView new];
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.rowHeight = 75.0;
}

- (NSArray *) students {
    return students;
}

- (void) setStudents:(NSArray *) theStudents {
    students = theStudents;
    [tableView reloadData];
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    headerView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, NAVIGATION_BAR_HEIGHT);
    tableView.frame = CGRectMake(0.0, NAVIGATION_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - NAVIGATION_BAR_HEIGHT);
}

- (UITableViewCell *) tableView:(UITableView *) tv cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    static NSString *identifier = @"BCTableCell";
    BCTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[BCTableCell alloc] initWithReuseIdentifier:identifier];
        [cell showDisclosureIndicator];
        cell.textLabel.textColor = [UIColor colorWithWhite:115 / 255.0 alpha:1.0];
    }

    BCStudent *student = students[(NSUInteger) indexPath.row];
    cell.textLabel.text = student.name;

    return cell;
}

- (NSInteger) tableView:(UITableView *) tv numberOfRowsInSection:(NSInteger) section {
    return [students count];
}

- (void) tableView:(UITableView *) tableView1 didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    BCStudent *student = students[(NSUInteger) indexPath.row];

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:BCStudentPickedNotification object:student];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end