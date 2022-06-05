
## SimplePractice Test

## Requirement 1: seed the database

####
  ```
  Seed the database using `db/migrate/seeds.rb`
  
   For the purpose of this exercise, you can assume that the `Patient` will only have one `Doctor`

 - There should be 10 Doctors with unique names
 - Each doctor should have 10 patients with unique names
 - Each patient should have 10 appointments (5 in the past, 5 in the future)
```

 ####
 
 - Link to seed file: [seeds.rb](./db/seeds.rb)
 
 ##### Observations and Validation Tests:
 - [Doctor should have 10 patients, and 100 appointments, 50 in the past, 50 in the future.](spec/models/doctor_spec.rb)
 - [atient must have only 1 doctor, and 10 appointments, 5 in the past, 5 in the future.](spec/models/patient_spec.rb)
 - [There should be 1000 appointments, 500 in the past, 500 in the future](spec/models/appointment_spec.rb)
 
  
  
  
  ## Requirement 2: api/appointments endpoint

 Return all appointments.

 The spec for the endpoint requires the following structure:
 ```
 [
   {
	 id: <int>,
	 patient: { name: <string> },
	 doctor : { name: <string>, id: <int> },
	 created_at: <iso8601>,
	 start_time: <iso8601>,
	 duration_in_minutes: <int>
   }, ...
 ]
 ```
 - Link to `Appointment Model`: [appointment.rb](app/models/appointment.rb)
 - Link to `Appointment Controller`: [appointments_controller.rb](app/controllers/application_controller.rb)

 ##### Observations and Validation Tests:
 - [Each Appointment Object must include the Above structure](https://github.com/NadavsSchwartz/SimplePractice-test/blob/cc1e8dcb45a3102911df748f13f348122e46842a/spec/requests/api/appointments_spec.rb#L3)



### Requirement 3: allow the api/appointments endpoint to return filtered records

 The following url params should filter the results:
 
 ```
 - `?past=1` returns only appointments in the past
 - `?past=0` returns only appointments in the future
 - `?length=5&page=1` returns paginated appointments, starting at `page`; use page size of `length`
 ```

 - Link to `Appointment Model`: [appointment.rb](app/models/appointment.rb)
 - Link to `Appointment Controller`: [appointments_controller.rb](app/controllers/application_controller.rb)
 - Link to `Appointment Query Class`: [get_appointments.rb](app/queries/get_appointments.rb)

 ##### Observations and Validation Tests:
 - [Only the `past` `page` `length` parameters are permitted, any other parameter would return an error](spec/requests/api/appointments_spec.rb)
 - [`past` must be 0 or 1, else return error](https://github.com/NadavsSchwartz/SimplePractice-test/blob/cc1e8dcb45a3102911df748f13f348122e46842a/spec/requests/api/appointments_spec.rb#L25)
 - [`page` and `length` params must both exists, and be a positive integer](https://github.com/NadavsSchwartz/SimplePractice-test/blob/cc1e8dcb45a3102911df748f13f348122e46842a/spec/requests/api/appointments_spec.rb#L34)

## Requirement 4: create a new endpoint api/doctors

```Create a new endpoint that returns all doctors that do not have an appointment.```

 - Link to `Doctor Model`: [doctor.rb](app/models/doctor.rb)
 - Link to `Doctor Controller`: [doctors_controller.rb](app/controllers/api/doctors_controller.rb)

 ##### Observations and Validation Tests:
  * The requirements state there are only `10 doctors`, each doctor has `1 patient`, and each `patient` has `10 appointments`,
  which in association means all `doctors` have appointments both in the past and the future, the API would return `All doctors currently have appointments.`
 - [When creating a new `doctor` without `appointments`, Api would return that `doctor`](spec/requests/api/doctors_spec.rb)
 
 
  ## Requirement 5: create new appointment POST to api/appointments

 ```
 {
   patient: { name: <string> },
   doctor: { id: <int> },
   start_time: <iso8604>,
   duration_in_minutes: <int>
 }
 ```
 
 - Link to `Appointment Model`: [appointment.rb](app/models/appointment.rb)
 - Link to `Appointment Controller`: [appointments_controller.rb](app/controllers/application_controller.rb)

 ##### Observations and Validation Tests:
 - [The above parameter structure must be followed in the request body](https://github.com/NadavsSchwartz/SimplePractice-test/blob/cc1e8dcb45a3102911df748f13f348122e46842a/spec/requests/api/appointments_spec.rb#L85)
 - [`Patient` must exist, otherwise API would return 'Patient not found' error](https://github.com/NadavsSchwartz/SimplePractice-test/blob/cc1e8dcb45a3102911df748f13f348122e46842a/spec/requests/api/appointments_spec.rb#L112)
 - [`Doctor` must exist, otherwise API would return 'Doctor not found' error](https://github.com/NadavsSchwartz/SimplePractice-test/blob/cc1e8dcb45a3102911df748f13f348122e46842a/spec/requests/api/appointments_spec.rb#L99)
 - [if `start_time` is not a valid date_format, or empty, return error](https://github.com/NadavsSchwartz/SimplePractice-test/blob/cc1e8dcb45a3102911df748f13f348122e46842a/spec/requests/api/appointments_spec.rb#L125)
 - [if `duration_in_minutes` is not 50 minutes](https://github.com/NadavsSchwartz/SimplePractice-test/blob/cc1e8dcb45a3102911df748f13f348122e46842a/spec/requests/api/appointments_spec.rb#L139)
 * I chose to leave the ability to create appointments in the past for a more comprehensive range of functionality
 
 
 ## Notes:
  -  It's critical to test APIs and handle edge cases on parameters for invalid inputs, sanitization, unauthorized access, data leakage, Etc.
To ensure a smooth flow of data and efficiency, we should utilize open-source well-tested gems.
However, since I was asked not to utilize outside gems, I have implemented validations for multiple edge cases.
  
 
