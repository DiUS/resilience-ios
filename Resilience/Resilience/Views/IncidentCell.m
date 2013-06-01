#import "IncidentCell.h"
#import "UIColor+Resilience.h"

static const float IMAGE_HEIGHT = 70.0;

@implementation IncidentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];

    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.textColor = [UIColor titleTextColor];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:16.];

    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.descriptionLabel.backgroundColor = [UIColor clearColor];
    self.descriptionLabel.textColor = [UIColor defaultTextColor];
    self.descriptionLabel.font = [self.descriptionLabel.font fontWithSize:14.];

    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.textColor = [UIColor defaultTextColor];
    self.timeLabel.font = [self.timeLabel.font fontWithSize:12.];

    self.contentView.backgroundColor = [UIColor defaultBackgroundColor];
    self.accessoryView.backgroundColor = [UIColor defaultBackgroundColor];

    UIView* myBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    myBackgroundView.backgroundColor = [UIColor defaultBackgroundColor];
    self.backgroundView = myBackgroundView;

    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.descriptionLabel];
    [self.contentView addSubview:self.photoImageView];

    self.photoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *views = NSDictionaryOfVariableBindings(_photoImageView, _nameLabel, _timeLabel, _descriptionLabel);
    [self.contentView addConstraints:[NSLayoutConstraint
            constraintsWithVisualFormat:@"|[_photoImageView(==70@900)]-[_nameLabel]|"
                                options:0
                                metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint
            constraintsWithVisualFormat:@"|[_photoImageView(==70@900)]-[_timeLabel]|"
                                options:0
                                metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint
            constraintsWithVisualFormat:@"|[_photoImageView(==70@900)]-[_descriptionLabel]|"
                                options:0
                                metrics:nil views:views]];

    [self.contentView addConstraints:[NSLayoutConstraint
            constraintsWithVisualFormat:@"V:|[_photoImageView(==70@900)]|"
                                options:NSLayoutFormatAlignAllLeft
                                metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint
            constraintsWithVisualFormat:@"V:|-5@900-[_nameLabel][_descriptionLabel][_timeLabel]-5@900-|"
                                options:NSLayoutFormatAlignAllLeft
                                metrics:nil views:views]];
  }
  return self;
}

@end
