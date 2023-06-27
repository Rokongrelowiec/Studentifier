# $\textcolor{orange}{\textsf{Studentifier}}$ 

<h3>Parking barrier application whose purpose is to control incoming cars written in Flutter.</h3>

---
## How it works?

The incoming car is recognized by the machine learning model and then its license plate is processed by optical character recognition (OCR). Further with own API, the program checks the presence of scanned license plate in data base. If it exists - parking barrier opens and the record is added to the daily report. However, if it does not exists - the application asks for QR code (which can be get from QR Code Generator based on USOS API).<details><summary>QR Code Generator</summary>https://qr.danielrum.in</details>contains necessary data to create a new record in the data base. Added records are available in the daily and monthly report. Additionally application gives access to manage parking spaces from admin and to change privileged license plates (entry without registering in the database or scanning the QR code). 

<br>

**Features**: Machine Learning and OCR, QR code scanner, themes (light, dark and system) and languages (english, polish and system - if it is not one from the previous ones, the default is english) caching, own API and own QR code generator based on USOS API.

<br>

The application scanning process is shown in the diagram below.

![diag_ang](https://github.com/Rokongrelowiec/Studentifier/assets/71082031/4fd99e7b-f497-4dcf-8486-dc11ae04836d)

---
## Screenshots

  <img src="https://github.com/Rokongrelowiec/studentifier_readme/blob/main/license_plate_scan.gif" width=360 height=780/>
<p float="left">
  <img src="https://github.com/Rokongrelowiec/studentifier_readme/blob/main/IMG_5798.PNG" width=360 height=780 />
  <img src="https://github.com/Rokongrelowiec/studentifier_readme/blob/main/IMG_5799.PNG" width=360 height=780 />
</p>
<p float="left">
  <img src="https://github.com/Rokongrelowiec/studentifier_readme/blob/main/IMG_5803.PNG" width=360 height=780 />
  <img src="https://github.com/Rokongrelowiec/studentifier_readme/blob/main/IMG_5800.PNG" width=360 height=780 />
</p>
<p float="left">
  <img src="https://github.com/Rokongrelowiec/studentifier_readme/blob/main/IMG_5801.PNG" width=360 height=780 />
  <img src="https://github.com/Rokongrelowiec/studentifier_readme/blob/main/IMG_5802.PNG" width=360 height=780 />
</p>

---
## Run project

**Important:**
Api-key is needed to run the app. To get Api-key -> create issue under the project in which leave your contact details (E.g. email address).


1. Download Flutter: https://docs.flutter.dev/get-started/install
2. Download IDE:
   + Visual Studio Code: https://code.visualstudio.com
   + Android Studio: https://developer.android.com/studio
3. Add Flutter and Dart extensions in your IDE
4. Download project
5. Add api-key.txt to the assets folder
6. Open project
7. Type `flutter pub get` in project path to get dependencies
8. Run project on your device
