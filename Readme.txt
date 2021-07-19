The aim of this app is to provide a brief overview of SpaceX's rockets. Basically, the first screen of the app will show
a list of all the available SpaceX's rockets containing basic information - rocket name, when it was first launch and if
it is active or not - and when tapping any of these rockets, a new screen will be push containing more detailed
information about the rocket selected.

The architecture chosen for the app was MVVM-C. The elements of this arquitecture are:
    - Model(M): representation of the data the application is dealing with.
    - View(V): dummy object which the user will interact with.
    - ViewModel(VM): element which separates the view from the model and handles all the business logic of the app.
    - Coordinator(C): element which pushes/presents/pops/dismiss views on the app.
    
The project uses Combine framework to bind the data connecting the view with the view model.

As this app is a prototype, I want to enumerate future things to improve the app itself:
    - Improve of NetworkManager to handle data requests.
    - Add caching to Network manager.
    - Create a set of fonts which the app will use.
    - Add dark mode.
    - Add more data to the rocket model to display more data on the Rocket Details screen.
    - Integrate more APIs to increase the level of information that a user can provided with.
