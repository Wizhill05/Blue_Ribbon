# Blue Ribbon
## Team Contrast | Hackloop 2024

This Flutter application is designed to assist individuals with dyslexia in reading and comprehending text more effectively. The app uses advanced APIs and a user-friendly interface to simplify text presentation, making reading a smoother and more engaging experience.

<details>
  <summary><h2>Gallery</h2></summary>
  <img src="https://github.com/Wizhill05/Blue_Ribbon/blob/readme-images/readme-images/1.jpg?raw=true" alt="just flexing the ui lol" width="300">
  <img src="https://github.com/Wizhill05/Blue_Ribbon/blob/readme-images/readme-images/3.jpg?raw=true" alt="just flexing the ui lol" width="300">
  <img src="https://github.com/Wizhill05/Blue_Ribbon/blob/readme-images/readme-images/4.jpg?raw=true" alt="just flexing the ui lol" width="300">
  <img src="https://github.com/Wizhill05/Blue_Ribbon/blob/readme-images/readme-images/5.jpg?raw=true" alt="just flexing the ui lol" width="300">
  <img src="https://github.com/Wizhill05/Blue_Ribbon/blob/readme-images/readme-images/6.jpg?raw=true" alt="just flexing the ui lol" width="300">
  <img src="https://github.com/Wizhill05/Blue_Ribbon/blob/readme-images/readme-images/7.jpg?raw=true" alt="just flexing the ui lol" width="300">
  <img src="https://github.com/Wizhill05/Blue_Ribbon/blob/readme-images/readme-images/8.jpg?raw=true" alt="just flexing the ui lol" width="300">
  <img src="https://github.com/Wizhill05/Blue_Ribbon/blob/readme-images/readme-images/9.jpg?raw=true" alt="just flexing the ui lol" width="300">
  <img src="https://github.com/Wizhill05/Blue_Ribbon/blob/readme-images/readme-images/10.jpg?raw=true" alt="just flexing the ui lol" width="300">
  <img src="https://github.com/Wizhill05/Blue_Ribbon/blob/readme-images/readme-images/11.jpg?raw=true" alt="just flexing the ui lol" width="300">
  <img src="https://github.com/Wizhill05/Blue_Ribbon/blob/readme-images/readme-images/12.jpg?raw=true" alt="just flexing the ui lol" width="300">
  <img src="https://github.com/Wizhill05/Blue_Ribbon/blob/readme-images/readme-images/13.jpg?raw=true" alt="just flexing the ui lol" width="300">
  <img src="https://github.com/Wizhill05/Blue_Ribbon/blob/readme-images/readme-images/14.jpg?raw=true" alt="just flexing the ui lol" width="300">
  <img src="https://github.com/Wizhill05/Blue_Ribbon/blob/readme-images/readme-images/15.jpg?raw=true" alt="just flexing the ui lol" width="300">
  <img src="https://github.com/Wizhill05/Blue_Ribbon/blob/readme-images/readme-images/16.jpg?raw=true" alt="just flexing the ui lol" width="300">
  <img src="https://github.com/Wizhill05/Blue_Ribbon/blob/readme-images/readme-images/2.jpg?raw=true" alt="just flexing the ui lol" width="300">
   
</details>

## Features

### 1. **Library Section**
- Connects to our **Supabase database** to fetch short stories.
- Organizes and displays stories in a dyslexia-friendly format.
- Also has support to change text size and resume from last page which was read
- Has a section where you can quickly check meaning and pronunciation by tapping on tokenized word

### 2. **News Section**
- Fetches the latest news articles.
- Displays the articles in the same tokenized and easy-to-read format.

### 3. **Summarization and Tokenized Display**
- Utilizes **Gemini APIs** to summarize lengthy content.
- Presents the text in a **tokenized format**, enhancing readability for users with dyslexia.

### 4. **Read from anywhere**
- Just select the text you are finding difficult to read and share it to app, you'll get your reader.

## Installation and Setup

### Prerequisites to Build or Run the project from source code
- Flutter SDK installed.
- A Supabase account with the required database setup.
- Access to Gemini APIs, NewsAPI keys.

### Steps to set up project locally
1. Clone the repository
   ```bash
   git clone https://github.com/Wizhill05/Blue_Ribbon.git

2. Navigate to the project directory
   ```bash
   cd Blue_Ribbon

3. Install dependencies
   ```bash
   flutter pub get

4. Set up credentials in the `lib/secrets.dart` file
   ```dart
   class Secrets {
   
      String url() {
        return "YOUR_SUPABASE_DB_URL_GOES_HERE";
      }
  
      String key() {
        return "YOUR_SUPABASE_PUBLIC_ANON_KEY_GOES_HERE";
      }
  
      geminiKey() {
        return 'AND_YOUR_GEMINI_API_KEY';
      }
  
      newsKey() {
        return 'WELL_THIS_IS_NEWSAPI_KEY';
      }
  
      static final Secrets _instance = Secrets._internal();
  
      factory Secrets() {
        return _instance;
      }
  
      Secrets._internal();
    }

  5. Run the app
     ```bash
     flutter run
