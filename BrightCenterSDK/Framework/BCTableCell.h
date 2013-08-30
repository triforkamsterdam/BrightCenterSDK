@interface BCTableCell : UITableViewCell
- (id) initWithReuseIdentifier:(NSString *) identifier;

- (void) showDisclosureIndicator;

- (void) addLogoToSelectedBackground;
@end