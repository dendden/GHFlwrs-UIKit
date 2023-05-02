# GHFlwrs-UIKit

The "GitHub Followers" app from Sean Allen's "Take Home Project" course, with few custom improvements:

- When alert shows in FollowersListVC informing about network request error - tapping alert's button not only dismisses it, but also pops the FollowersListVC from Navigation Controller, so that user automatically returns to the search screen.
- Filtering followers list takes into consideration empty search prompt IF it BECAME empty after user deleted previously entered characters. Thus the followers list returns to "all followers" state even before search is dismissed with Cancel button.