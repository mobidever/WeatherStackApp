# WeatherStackApp
This Weather App displays the current **temperature** and **wind direction** for location **Mumbai** , by default. The app fetches live weather information from **WeatherTrack** and presents it using a clear and responsive user interface.

## Features

- **Real-Time Weather Data**: Fetches and displays the temperature and wind direction for Mumbai. (To get for other location, for now, we need to update the code)
- **MVVM Architecture**: Utilizes the Model-View-ViewModel (MVVM) pattern for a clean and testable codebase.
- **SOLID Principles**: Built with SOLID principles to ensure scalability, maintainability, and separation of concerns.
- **Comprehensive Testing**: Includes both unit tests and UI tests for reliable performance and quality assurance.

## Architecture

The app follows the **MVVM** architecture, ensuring separation between business logic, UI, and data management:

- **WeatherModel**: Represents weather data from WeatherTrack. Currently, we are using only Temperature/Wind Direction and Location Information from WeatherTrack JSON Output
- **WeatherViewModel**: Manages data fetching, processing by Connecting with Network Client (**NetWorkClient** protocol), and binding to the UI.
- **HomeScreenView**: Displays weather information and fetches whenever the HomeScreen is loaded

## Code Quality

The app is built according to **SOLID principles**:
- **Single Responsibility Principle (SRP)**: Each class and component has a single responsibility.
		HomeScreenView: Responsible for Displaying Weather Info for Mumbai Location (currently, hardcoded)
		AboutScreenView : Responible to Provide App Description
		TabBarScreenView : Responsible to Handle TabBar style Navigation based upon selected TabBar
- **Open/Closed Principle (OCP)**: **WeatherModel** can be extended for adding more info from WeatherTrack Service
- **Liskov Substitution Principle (LSP)**: **NetWorkClient**  is used to abstract only required method **fetchData**. This protocol can be used to create other Network Clients
- **Interface Segregation Principle (ISP)**: **HTTPClient** is the interface which segregated with only required method.
- **Dependency Inversion Principle (DIP)**: **MockHTTPClient** is created from protocol **NetworkClient** and can be replaced with **HTTPClient** to achieve XCTest execution with Mock Data 

## Network
**HTTPClient** is the class responsible for fetching data from api **"https://api.weatherstack.com/current?access_key=\(api_key)&query=\(location)"**
**MockHTTPClient** class creates mock publishers for providing success and failure json response to ViewModel publishers.

## ErrorHandling
When there is a case of failure we will be showing the alert for the user with retry option upto 3 times.  

## Testing

### Unit Tests
The app includes XCTests for:
- **WeatherViewModelTest**: Creates a **WeatherViewModel** from **MockHttpClient** and fetches data from overridden method of  **weatherPublisher**. Executes the test by parsing **weatherInfo.json** with weather mock data of city **Hyderabad**. Also, tested failure case of decoding the content by passing invalid json object from **weatherInfo_Failure.json** file.
- **WeatherStackAppUITests** : Executes test case of UI Elements of HomeScreenView/TabBarScreenView/AboutScreenView
