# News Reader App

## Overview
News Reader is an iOS application developed using SwiftUI that allows users to browse and read news articles from various sources. The app fetches articles from the NewsAPI, allows users to bookmark articles for offline reading of title and description, and provides filtering options for a personalized reading experience.

### Requirements
- iOS 17.0 or later
- Xcode 14.0 or later
- SwiftUI and SwiftData

## Screenshots

<img src="https://github.com/user-attachments/assets/5363efab-73cc-4f3e-b016-46af98088910" width=50% height=50%>
<img src="https://github.com/user-attachments/assets/a51bc6f7-d705-4d66-95c9-55c4a7b0ec6f" width=50% height=50%>
<img src="https://github.com/user-attachments/assets/8ad2b282-3d6f-47d7-9e26-b9c1d60dc09e" width=50% height=50%>


 ### Usage
- Launch the app to view the latest news articles.
- Tap on an article to read its details.
- Bookmark articles by tapping the bookmark icon.
- Navigate to the Bookmarks tab to view saved articles.

 ## Localization
 The app supports localization for various strings to enhance user experience. All localizable strings are stored in the Localizable.strings file.

## Features
- **Fetch News Articles**: Retrieve articles from the NewsAPI based on user preferences.
- **Bookmark Articles**: Save articles locally for offline access.
- **Read Full Content**: View detailed information about each article.
- **Filter Articles**: Easily filter articles by category.
- **Offline Access**: Access bookmarked articles without an internet connection.
- **User-Friendly Interface:** A clean and intuitive design using SwiftUI.

## Technologies
- **SwiftUI**: For building the user interface.
- **SwiftData**: For local data storage of bookmarked articles.
- **Network Framework**: For monitoring internet connectivity.

## Architecture
The application follows the **MVVM (Model-View-ViewModel)** architecture pattern to separate concerns and enhance testability.

### Data Model
The main data model is `NewsArticle`, which is represented as a SwiftData entity with the following properties:
- `id`: Unique identifier for the article.
- `sourceName`: Name of the news source.
- `author`: Author of the article.
- `title`: Title of the article.
- `articleDescription`: Brief description of the article.
- `url`: Link to the article.
- `urlToImage`: URL of the article's image.
- `publishedAt`: Date the article was published.
- `content`: Full content of the article.
- `isBookmarked`: Boolean indicating if the article is bookmarked.

### Network Monitoring
The `NewsNetworkMonitor` class observes internet connectivity using the Network framework to notify users about connectivity changes.

## Error Handling
The app implements error handling for network requests and database operations, ensuring that users are informed of any issues encountered.

### Unit Testing
The application includes unit tests written using **XCTest**. Tests cover:
- Validating the fetching of articles and their properties.
- Bookmarking and unbookmarking articles.
- Ensuring articles are correctly stored and retrieved from the database.

### Mocking
A mock version of `ModelContext`, called `MockModelContext`, is used to simulate database operations during testing, ensuring that tests do not affect real data.

### Database Management
Before executing tests that modify the database, the database is cleared to ensure each test runs in isolation. SWiftUI database is used to store offline bookmarked articles of title and description.

## Installation
 **Clone the Repository**
    git clone https://github.com/paulsoham/NewsReaderApp.git

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Author
* Soham Paul - https://github.com/paulsoham


  



   
