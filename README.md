# Cadê Buffet 🎉🍽️

### Motivation

This project is part of the training schedule at Campus Code in the TreinaDev program. Its aim is to develop skills in Ruby on Rails and create a robust project for personal portfolio. The motivation behind Where's Buffet? is to address the problem faced by individuals who need to organize parties, weddings, or corporate events but struggle to find the right catering service for their needs.

***

### Functionalities

A user can register as a client or buffet owner.
A buffet owner can register their company by listing offered services, menus with their prices, and receive inquiries from interested individuals.

Functionalities in progress...

***

### How to Run the Code

1. Ensure you have Ruby on Rails installed on your machine. If not, you can install it by following the instructions [here](https://www.ruby-lang.org/en/documentation/installation/).

2. Clone this repository to your local machine.

3. Navigate to the project directory in your terminal.

4. Install the required dependencies by running:
```bundle install```

5. Set up the database by running:
```rails db:create```
```rails db:migrate```

6. Start the Rails server:
```rails server```
or simply
```rails s```

7. Access the application in your web browser at [http://localhost:3000](http://localhost:3000).

Now you're ready to explore and contribute to Cadê Buffet, and make it a standout project in your portfolio! 🚀

***

### Running tests

You can simply run ```rspec```, so all tests may be running. But, sometimes, in some architectures may occur some errors while trying to run this command, something about pending migrations, if it is the case, you can run the command ```rake db:migrate RAILS_ENV=test ```, and the migrations may take effects in the dev environment as well.

***

### Happy Coding
## Vinigperuzzi 🧙‍♂️