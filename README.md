# sti_flutter_assignment3

Fifth assignment on my Dart/Flutter course at STI

# 1. Start applications

To run this application you will need to add a <span style="color:yellow"> _.env-file_</span> in the root of repo that hold some credentials to Firebase

## 1.1 Admin

- Dependancies updated with `flutter pub get`.
- Make sure server is running with `dart run` in /dart_server root.
- This application I have started with `flutter run -d "macOS" ` in /parking_admin root.
  (It's been tested in Mac OS Desktop simulator).

## 1.2 User

- Dependancies updated with `flutter pub get`.
- Make sure server is running with `dart run` in /dart_server root.
- This application I have started with `flutter run -d "IPhone 16"` in /parking_user root.
  (It's been tested in IPhone 16 simulator.)

# 2. Features

- Some miner clean up since last assignment.
- Added possibility to add time parameter to toastMessage (Mostly used to show error from login a bit longer than other toast-messages).

## 2.1 Admin

- Login (but not synced with any account in database)
- See, add, remove and update parking spaces
- See active and ended/inactive parkings
- See most popular parking lots
- See total earnings from ended parkings
- Switch between dark and light mode

New feaures

- All data is saved in Cloud Firestore
- Parking lots and parkings are realtime updated if changes occurs\*

## 2.2 User

- Login with email and password (Firebase auth)
- Registration of new customers
- Switch between dark and light mode
- See, add, update and delete vehicles registered to the logged in user.
- See all free parkings lots
- See, add and update (set endTime to now) to parkings for logged in user.
- See users ended parkings

New features

- All data is saved in Cloud Firestore
- Login uses Firebase Auth
- Registration with Firebase Auth
  However, my version of this doesn't use the stream to continue registration. It does all registration in one step and logout the user directly, and the user needs to login through the regular login. There is a subscribe to changes, but as said it's not really used for registration.
- Parking lots, parkings and vehicles are realtime updated if changes occurs\*

# 3. Known limitations

- (\*) Have implemented some realtime updates, but only on first level. For example if the price of a parking lot is changed, it will (hopefully) update the parking lot list, however a parking that contains a parking lot will not be effected.
- The applications handles the price of the parking lots even if you set an integer. But if you change the price to an integer in the database directly the applications will fail when trying to fetch it.
- Lacks some responsive features
