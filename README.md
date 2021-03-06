## This is a short Documentation on School API (SKOLERA Task):
- is an API which is used as registration system, using http requests (restful)
- only admins can visit endpoints and send requests, to be an admin you must register through devise endpoints
- there are 4 background jobs implemented using sidekiq with redis server for creating csv files contain all data for any model you want from the 4 main models (students, courses, teachers, students_courses)
- data sent back for the 4 main models serialized using fastjsonapi gem 
### Database
- Consists of 6 models, 4 of them with relations (teachers has many courses, courses and students are many to many), with some validations on model and database levels, index is added for speed, 1 model for devise (the admins who can visit all other models), 1 model for saving csv files using paperclip 

![alt text](https://res.cloudinary.com/elta3lab/image/upload/v1560632464/Screenshot_from_2019-06-15_22-58-42.png)

###  Routes
- nested resources, where you can apply crud operations on teachers model, on courses belongs to a specific teacher, on students model, on students_courses model which show courses belongs to specific student

![alt text](https://res.cloudinary.com/elta3lab/image/upload/v1560633716/Screenshot_from_2019-06-15_23-21-28.png)

- some custom routes created too to be able to serve needs of extracting more data, applying specific editing, like get all courses exists in the system, get all students_courses records, edit course teacher & edit course student

![alt text](https://res.cloudinary.com/elta3lab/image/upload/v1560634175/Screenshot_from_2019-06-15_23-29-19.png)

### Devise
- using devise for authentication, with the whole list of endpoints for registration, login, logout, edit info, etc

![alt text](https://res.cloudinary.com/elta3lab/image/upload/v1560634421/Screenshot_from_2019-06-15_23-32-22.png)

- here are some examples
1) to register a new email, send post request to endpoint /auth with json data of email, password, password confirmation

![alt text](https://res.cloudinary.com/elta3lab/image/upload/v1560634934/Screenshot_from_2019-06-15_23-41-37.png)

2) to login, send post request to endpoint /auth/sign_in with params of email and password, after sending it go to headers and copy (access-token, client, uid) key and value, which will then be used to communicate with all other protected endpoints which require login

![alt text](https://res.cloudinary.com/elta3lab/image/upload/v1560635209/Screenshot_from_2019-06-15_23-46-28.png)

3) if you try to visit any url without adding the 3 headers from the previous step, then an error will be sent back requiring you to login

![alt text](https://res.cloudinary.com/elta3lab/image/upload/v1560635867/Screenshot_from_2019-06-15_23-57-34.png)

but if you send the 3 key values headers, a response with serialized data using fastjsonapi will appear

![alt text](https://res.cloudinary.com/elta3lab/image/upload/v1560635897/Screenshot_from_2019-06-15_23-57-01.png)

4) another endpoint for signing out, which will destroy the tokens we added before to the headers, now they are destroyed and you can't login or contact protected endpoints using them

![alt text](https://res.cloudinary.com/elta3lab/image/upload/v1560636269/Screenshot_from_2019-06-16_00-02-56.png)

### Background Jobs using sidekiq & redis server

- every model data can be exported into a csv file, you visit an endpoint in order to create a csv using background job (request it for example 4 times), then visit another endpoint for downloading csv files and keep refreshing it til all csv files download urls appears (ordered by newer), go to any link of them and the csv will start downloading

here are the endpoints used:

![alt text](https://res.cloudinary.com/elta3lab/image/upload/v1560636608/Screenshot_from_2019-06-16_00-09-32.png)

and here are some screenshots in sending requests for background jobs with headers from google chrome

![alt text](https://res.cloudinary.com/elta3lab/image/upload/v1560636811/Screenshot_from_2019-06-16_00-13-07.png)

![alt text](https://res.cloudinary.com/elta3lab/image/upload/v1560637016/Screenshot_from_2019-06-16_00-13-49.png)

![alt text](https://res.cloudinary.com/elta3lab/image/upload/v1560637058/Screenshot_from_2019-06-16_00-17-11.png)

![alt text](https://res.cloudinary.com/elta3lab/image/upload/v1560637063/Screenshot_from_2019-06-16_00-17-23.png)

### Development

- to run api locally, clone the repo and run rails server and sidekiq.

### Tesing

- Rspec included for everything, models, requests, jobs, etc

### production

- everything working pretty the same for production, except that csv files can't be hosted ( needs AWS amazon S3 account which I don't have ), and only one job from the 4 is enabled (redis-to-go addon free plan), which is the students job with the 2 endpoints, one for creation of the csv and the other one for list all csv files urls

- Root url on heroku: https://serene-mountain-76394.herokuapp.com
- Endpoints for the workings students job (don't forget to sign-up, sign-in, add the 3 headers first !)
https://serene-mountain-76394.herokuapp.com/createstudentscsv 
https://serene-mountain-76394.herokuapp.com/downloadstudents
      

### Others

- Concerns, exception handling, rollbar installed.

## Future Plans

- Add Rubocop, circleci, and more

