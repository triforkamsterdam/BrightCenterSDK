@class BCStudentListController;
@class BCGroup;

@interface BCGroupListController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) BCStudentListController *studentListController;
@property NSArray *groups;

- (void) selectGroup:(BCGroup *) group;

@end