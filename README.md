# GHFlwrs-UIKit

The "GitHub Followers" app from Sean Allen's "Take Home Project" course, with few custom improvements.

<p align="center">
  <img src="/Screens/1.png" width="200" title="Initial search screen">
  <img src="/Screens/2.png" width="200" title="Followers list">
</p>

## Improvements List

Some improvements were implemented before SA refactored his code towards the end of the course, and thus should be considered as independent and standalone:

- When alert shows in ```FollowersListVC``` informing about network request error - tapping alert's button not only dismisses it, but also pops the ```FollowersListVC``` from Navigation Controller, so that user automatically returns to the search screen.
- Filtering followers list takes into consideration empty search prompt IF it BECAME empty after user deleted previously entered characters. Thus the followers list returns to "all followers" state even before search is dismissed with *Cancel* button.
- Getting Followers list from a ```UserInfoVC``` deactivates searchController (if user was selected from an active search).
- When getting Followers list from a user details view, scrollView uses ```scrollToItem(0)``` instead of ```setContentOffset```, which produces a more precise result.
- Persistence utilizes *FileManager* + *Documents Directory* to write Bookmarked Users (Favorites) to a json file instead of ```UserDefaults``` key-value storage.
- PersistenceManager has a static ```allBookmarkedUsers``` String array which contains all usernames of users added to Bookmarks. This array is populated via mapping the result of FileManager read call on app launch in ```application(didFinishLaunchingWithOptions)```. The array of usernames is used by ```FollowersListVC``` to quickly check if user is added to favorites.
- ```FollowersListVC``` shows a bookmark image for adding to favorites. The image alters between empty and filled bookmark depending on whether this user is already in Bookmarks.
- When sliding to delete a bookmark - persistence call to remove is executed first, then either alert gets shown if there was an error or the row gets deleted from TableView.
- An **error** or **success** haptic accompanies ```presentGFAlert()``` method.
