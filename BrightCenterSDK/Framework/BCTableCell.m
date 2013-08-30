#import "BCTableCell.h"
#import "BCDisclosureIndicator.h"
#import "BCLogo.h"

#define DISCLOSURE_INDICATOR_WIDTH 16.0
#define DISCLOSURE_INDICATOR_HEIGHT 27.0

#define MARGIN_RIGHT 20.0
#define LOGO_SIZE 30.0

@implementation BCTableCell {

    BCDisclosureIndicator *disclosureIndicator;

    UIView *selectedBackgroundView;

    BCLogo *logo;
}

- (id) initWithReuseIdentifier:(NSString *) identifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (self) {
        self.textLabel.highlightedTextColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont systemFontOfSize:32.0];

        selectedBackgroundView = [UIView new];
        selectedBackgroundView.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:126 / 255.0 blue:43 / 255.0 alpha:1.0];
        self.selectedBackgroundView = selectedBackgroundView;

        self.indentationWidth = 15;
        self.indentationLevel = 1;

        disclosureIndicator = [BCDisclosureIndicator new];
        [self addSubview:disclosureIndicator];
        disclosureIndicator.hidden = YES;
    }
    return self;
}

- (void) showDisclosureIndicator {
    disclosureIndicator.hidden = NO;
}

- (void) addLogoToSelectedBackground {
    logo = [[BCLogo alloc] initWithColor:[UIColor colorWithWhite:79 / 255.0 alpha:1.0]];
    [selectedBackgroundView addSubview:logo];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(
            self.textLabel.frame.origin.x,
            self.textLabel.frame.origin.y,
            self.textLabel.frame.size.width - DISCLOSURE_INDICATOR_WIDTH - MARGIN_RIGHT,
            self.textLabel.frame.size.height
    );

    disclosureIndicator.frame = CGRectMake(
            self.frame.size.width - MARGIN_RIGHT - DISCLOSURE_INDICATOR_WIDTH,
            (self.frame.size.height / 2.0) - (DISCLOSURE_INDICATOR_HEIGHT / 2.0),
            DISCLOSURE_INDICATOR_WIDTH,
            DISCLOSURE_INDICATOR_HEIGHT
    );

    logo.frame = CGRectMake(
            selectedBackgroundView.frame.size.width - MARGIN_RIGHT - LOGO_SIZE,
            (selectedBackgroundView.frame.size.height / 2.0) - (LOGO_SIZE / 2.0),
            LOGO_SIZE,
            LOGO_SIZE
    );
}

@end