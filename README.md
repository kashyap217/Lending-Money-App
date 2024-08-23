# Lending Money App

The Lending Money App is designed to help users manage loans efficiently. Built with Ruby on Rails, it offers features like user authentication and authorization, loan tracking, and automatic interest calculation.


## Installation
1. Clone the repository:
   https://github.com/kashyap217/Lending-Money-App.git

2. Navigate to the project directory:
   cd your-repo-name

3. Install dependencies:
   bundle install

4. Set up the database:
   rails db:create db:migrate

### 7. **Usage**

To start the application, run:
   - rails server
   - bundle exec sidekiq (This is reponsible to calculate and apply the interest on the loans)

### NOTE:**
THE ADMIN USER WILL BE CREATED WHEN YOU RUN THE MIGRATION (using rails db:migrate) **

## Admin Credentials

The admin credentials are as follows:

- **Email**: `admin@lending.com`
- **Password**: `password`

