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

### API

This project is also an API, you can send requests to it's endpoints and receive data as json.
The documentation for endpoints are listed below:

***

```http://localhost:3000/api/v1/buffets```  -> list all buffets registered in application

Response example: 
```[{"name": "example buffet", "id": 1}, {"name": "another buffet", "id": 2}]```

***

```http://localhost:3000/api/v1/buffets/id```  -> changing id for the specified number, the api will response details for specified buffet

Response example: 
```
{
  "name": "My Buffet",
  "phone": "xx - xxxxxxxxx",
  "email": "example@email.com",
  "address": "Some Street, some number",
  "district": "My district",
  "state": "XX",
  "city": "Some City",
  "payment_method": "List of payment methods",
  "description": "Description of my buffet"
}
```


Informing an invalid buffet_id will send an error message and the error status, such as:

```{"error":"Buffet not found for this buffet_id"}```

***

```http://localhost:3000/api/v1/buffets?query=example```  -> changing example for any fragment word you desire, the api will return any buffet that has on it's name some correspondence to the given fragment

Response example: 
```{"name": "example buffet", "id": 1}```

***

```http://localhost:3000/api/v1/events?buffet_id=x```  -> informing an buffet id where the 'x' are, the api will response with name, description and id for and other details for all events for the specified buffet

Response example: 
```
[
  {
    "id": 1,
    "name": "Casamento",
    "description": "Buffet de doces e bolo artesanal para casamentos",
    "min_qtd": 50,
    "max_qtd": 500,
    "duration": 250,
    "menu": "Salgadinhos, doces e bolos",
    "drinks": true,
    "decoration": true,
    "valet": true,
    "only_local": false,
    "prices": {
      "base_price": 2500,
      "additional_person": 250,
      "extra_hour": 150,
      "sp_base_price": 3500,
      "sp_additional_person": 350,
      "sp_extra_hour": 250
    }
  },
  {
    "id": 3,
    "name": "Formatura",
    "description": "Salgadinhos de festa para formaturas",
    "min_qtd": 60,
    "max_qtd": 200,
    "duration": 450,
    "menu": "Salgadinhos variados",
    "drinks": true,
    "decoration": true,
    "valet": true,
    "only_local": false,
    "prices": {
      "base_price": 5000,
      "additional_person": 50,
      "extra_hour": 40,
      "sp_base_price": 6000,
      "sp_additional_person": 60,
      "sp_extra_hour": 50
    }
  }
]
```

Informing an invalid buffet_id, or not informing id at all will send an error message and the error status, such as:

```{"error":"Buffet_id required for this operation"}```
```{"error":"Buffet not found for this buffet_id"}```


***

```'http://localhost:3000/api/v1/events/id/check_date?date=2034-12-7&guest_qtd=30'``` -> Response with the value and availability for the given date, with the given guest quantity for the event specified in id

Response examples: 

Date available
```
{
  "value": 2500,
  "availability": true
}
```
Date not available

```
{
  "value": 0,
  "availability": false
}
```

if error occur

```
{
  "error": "Event not found for this id"
}
```

```
{
  "error": "Guest quantity required for this operation
}
```

```
{
  "error": "Date required for this operation"
}
```

```
{
  "error": "Guest quantity above max event's capacity"
}
```


***

### Happy Coding
## Vinigperuzzi 🧙‍♂️