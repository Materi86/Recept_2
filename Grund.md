Absolut\! Att skapa ett Produktkravdokument (PRD) och ett Arkitekturdokument, även för en enkel "Hello World"-app, är en utmärkt övning. Det hjälper till att strukturera tankarna och skapar en tydlig plan. Eftersom du tidigare har haft problem med att få Flutter att fungera kommer jag att göra arkitekturdokumentet extra detaljerat med fokus på förutsättningar och felsökning.

Här är dokumenten, anpassade för en nybörjare.

-----

### Dokumentöversikt

1.  **Produktkravdokument (PRD):** Fokuserar på *VAD* appen ska göra och *VARFÖR*.
2.  **Arkitekturdokument & Kom-igång-guide:** Fokuserar på *HUR* appen ska byggas, vilka verktyg som behövs och hur man löser vanliga problem.

-----

## 1\. Produktkravdokument (PRD) - "Hello Flutter" App

### 1.1. Introduktion & Syfte

**Syfte:** Syftet med detta projekt är att skapa en grundläggande mobilapplikation med Flutter för att verifiera att utvecklingsmiljön är korrekt konfigurerad och för att demonstrera de mest fundamentala koncepten i Flutter-utveckling. Appen kommer att tjäna som ett första, fungerande exempel för en ny utvecklare.

**Problem som löses:** Många nya Flutter-utvecklare stöter på problem med installation och konfiguration av verktyg. Denna applikation, och processen att bygga den, fungerar som ett kvitto på att hindren är övervunna och att en grundläggande utvecklingscykel (skapa, köra, felsöka) fungerar.

### 1.2. Målgrupp

  * **Primär användare:** Utvecklaren själv.
  * **Sekundär användare:** Den som eventuellt testar appen på en telefon/simulator.

### 1.3. Funktionella Krav (Functional Requirements)

Appen ska vara en enkel räknare, vilket är standardexemplet när man skapar ett nytt Flutter-projekt. Detta är mer lärorikt än en statisk "Hello World"-text eftersom det introducerar konceptet med *tillstånd (state)*.

| ID | Krav | Beskrivning | Prioritet |
| :--- | :--- | :--- | :--- |
| **FR1** | Visa en statisk titel | Applikationen ska ha ett huvudfält (AppBar) med titeln "Hello Flutter Demo". | Hög |
| **FR2** | Visa en central text | Applikationen ska visa en text i mitten av skärmen som säger "Du har tryckt på knappen så här många gånger:". | Hög |
| **FR3** | Visa en räknare | Under texten från FR2 ska ett numeriskt värde visas. Detta värde ska starta på `0`. | Hög |
| **FR4** | Inkludera en knapp | En flytande action-knapp (FloatingActionButton) med en plus-ikon ska finnas på skärmen. | Hög |
| **FR5** | Öka räknaren vid klick | När användaren trycker på knappen (FR4), ska räknaren (FR3) öka sitt värde med 1. | Hög |

### 1.4. Icke-funktionella Krav (Non-Functional Requirements)

| ID | Krav | Beskrivning |
| :--- | :--- | :--- |
| **NFR1** | Plattformskompatibilitet | Koden ska kunna kompileras och köras utan ändringar på både Android (via emulator) och iOS (via simulator). |
| **NFR2** | Prestanda | Appen ska starta snabbt och interaktionen (knapptryckning) ska vara omedelbar utan märkbar fördröjning. |
| **NFR3** | Användbarhet | Gränssnittet ska vara rent, enkelt och självförklarande. |

### 1.5. Framtida Omfattning (Out of Scope)

  * Ingen koppling till backend eller databaser.
  * Inga avancerade UI-element eller animationer.
  * Ingen användarautentisering.
  * Ingen publicering till App Store eller Google Play.

-----

## 2\. Arkitekturdokument & Kom-igång-guide - "Hello Flutter" App

Detta dokument är designat för att vara en praktisk guide för att bygga appen och lösa de problem du tidigare stött på.

### 2.1. Systemöversikt & Arkitekturval

**Arkitektur:** Flutter-arkitekturen är i sig själv baserad på **Widgets**. Allt i Flutter är en widget – från en knapp till padding och hela app-skärmen. För denna enkla app kommer vi att använda en standard-widgetstruktur som Flutter själv genererar.

  * **Widget-träd:** Appen kommer att bestå av ett träd av widgets.
      * `MaterialApp`: Rot-widgeten som tillhandahåller grundläggande app-funktionalitet (som navigering och tema).
      * `Scaffold`: En standardlayout för en skärm, som ger oss en AppBar och en body.
      * `StatefulWidget`: Vår huvudskärm kommer att vara en `StatefulWidget` eftersom den behöver hålla reda på ett värde som förändras (räknaren). En `StatelessWidget` kan inte ändra sitt eget utseende eller data efter att den har byggts.

### 2.2. Förutsättningar (Detta är det viktigaste steget\!)

Innan du skriver en enda rad kod, måste din miljö vara korrekt inställd.

1.  **Installera Flutter SDK:** Ladda ner och installera Flutter SDK från den officiella hemsidan: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install). Följ instruktionerna noga för ditt operativsystem (Windows, macOS eller Linux).

2.  **Installera en Kod-editor:**

      * **Visual Studio Code (Rekommenderas):** Installera VS Code. Gå sedan till "Extensions"-fliken och installera de officiella `Flutter`- och `Dart`-tilläggen. De ger dig syntax-markering, kodkomplettering och "Hot Reload"-funktionalitet.

3.  **Installera Plattformsspecifika Verktyg:**

      * **För Android:**
          * Installera **Android Studio**.
          * Öppna Android Studio och gå igenom "first-time setup".
          * Gå till `Tools > SDK Manager` och se till att du har en Android SDK installerad.
          * Gå till `Tools > AVD Manager` och skapa en **Android Virtual Device (Emulator)**. Välj en telefonmodell (t.ex. Pixel 6) och en system-image.
      * **För iOS (endast på macOS):**
          * Installera **Xcode** från Mac App Store.
          * Öppna Xcode en gång för att den ska installera sina komponenter.
          * En iOS Simulator installeras automatiskt med Xcode.

4.  **Verifiera installationen med `flutter doctor`:**

      * Öppna din terminal (eller kommandotolken) och kör kommandot:
        ```bash
        flutter doctor
        ```
      * **Detta kommando är din bästa vän.** Det analyserar din installation och talar om exakt vad som saknas eller är felkonfigurerat.
      * **Mål:** Du ska se gröna bockar vid `Flutter`, `Android toolchain` (om du siktar på Android), `Xcode` (om du är på Mac), och `Connected device`. Om du ser ett `!` eller `✗`, läs meddelandet noga. Det ger ofta lösningen (t.ex. "run `flutter doctor --android-licenses`"). **Gå inte vidare förrän `flutter doctor` är nöjd.**

### 2.3. Projektstruktur

1.  **Skapa projektet:** Navigera i terminalen till en mapp där du vill spara dina projekt och kör:

    ```bash
    flutter create hello_flutter_app
    ```

    Detta skapar en ny mapp `hello_flutter_app` med all startkod.

2.  **Viktiga filer och mappar:**

      * `lib/main.dart`: **Detta är filen du kommer att arbeta i.** Det är appens startpunkt.
      * `pubspec.yaml`: Projektets "recept". Här specificerar du beroenden (paket), typsnitt, bilder, app-version, etc.
      * `android/` och `ios/`: Mappar som innehåller de underliggande, plattformsspecifika projekten. Du rör sällan dessa i början.

### 2.4. Appens Kod (`lib/main.dart`)

Den autogenererade koden uppfyller redan alla våra funktionella krav. Här är koden med extra kommentarer för att förklara varje del.

```dart
// Importerar Googles Material Design-bibliotek, som innehåller alla vanliga widgets.
import 'package:flutter/material.dart';

// Appens startpunkt. "=>" är ett kort sätt att skriva en funktion med en enda rad.
// Denna rad startar vår app genom att köra widgeten "MyApp".
void main() => runApp(const MyApp());

// "MyApp" är rot-widgeten för hela applikationen.
// Den är "Stateless" eftersom den aldrig ändrar sig själv.
// Den sätter upp appens övergripande tema och vilken skärm som ska visas först.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp är en nödvändig widget som omsluter hela appen.
    return MaterialApp(
      title: 'Hello Flutter Demo', // Titeln som syns i app-växlaren
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // "home" definierar vilken widget som är appens startskärm.
      home: const MyHomePage(title: 'Hello Flutter Demo'),
    );
  }
}

// "MyHomePage" är vår huvudskärm.
// Den är "Stateful" eftersom den innehåller data (räknaren) som kan ändras,
// vilket kräver att widgeten ritas om för att visa den nya datan.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title; // Titeln som skickas från MyApp

  @override
  // Denna metod skapar det föränderliga tillståndet (state) för vår widget.
  State<MyHomePage> createState() => _MyHomePageState();
}

// Detta är "State"-klassen som hör ihop med "MyHomePage".
// All data som kan ändras (som vår räknare) och all logik som ändrar den
// (som vår knapptrycknings-metod) ska placeras här.
class _MyHomePageState extends State<MyHomePage> {
  // En privat variabel för att hålla reda på antalet klick.
  int _counter = 0;

  // En metod som ökar "_counter" med 1.
  // Den är insvept i "setState()", vilket är KRITISKT.
  // setState() talar om för Flutter att datan har ändrats och att skärmen
  // behöver ritas om för att visa det nya värdet. Utan detta skulle
  // _counter öka, men användaren skulle aldrig se det.
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // "Scaffold" är en grundläggande layout-widget för Material Design.
    // Den ger oss en färdig struktur med AppBar, Body, FloatingActionButton, etc.
    return Scaffold(
      appBar: AppBar(
        // Tar titeln från MyHomePage-widgeten ovanför.
        title: Text(widget.title),
      ),
      // "body" är huvud-innehållet på skärmen.
      body: Center( // Centrerar sitt barn-widget i mitten av skärmen.
        child: Column( // Arrangerar sina barn-widgets i en vertikal kolumn.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Du har tryckt på knappen så här många gånger:',
            ),
            Text(
              '$_counter', // Visar värdet av vår _counter-variabel.
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      // Den flytande knappen längst ner.
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter, // Anropar vår metod när knappen trycks.
        tooltip: 'Öka',
        child: const Icon(Icons.add), // Visar en plus-ikon.
      ),
    );
  }
}

```

### 2.5. Hur man kör appen

1.  **Starta din emulator/simulator:**
      * **Android:** Öppna Android Studio, gå till AVD Manager och tryck på "Play"-knappen bredvid din virtuella enhet.
      * **iOS:** Öppna terminalen och kör `open -a Simulator`.
2.  **Se till att Flutter ser enheten:** I VS Code, längst ner i högra hörnet, ska du se namnet på din emulator (t.ex. "sdk gphone64 arm64"). Om det står "No Device", vänta en stund eller starta om VS Code.
3.  **Kör appen:**
      * Öppna terminalen i VS Code (`View > Terminal`).
      * Se till att du är i projektmappen (`cd hello_flutter_app`).
      * Kör kommandot:
        ```bash
        flutter run
        ```
      * Första gången kan det ta flera minuter. Efterföljande starter är mycket snabbare. När appen körs, prova att ändra en text i koden och spara. Du kommer se "Hot Reload" i action – ändringen syns i appen på under en sekund utan att räknaren nollställs\!

### 2.6. Felsökning (När det inte fungerar)

  * **Problem:** Kommandot `flutter` hittas inte.
      * **Lösning:** Du har inte lagt till Flutter SDK i din `PATH`. Följ instruktionerna för "Update your path" i den officiella installationsguiden igen.
  * **Problem:** `flutter doctor` klagar på Android-licenser.
      * **Lösning:** Kör kommandot `flutter doctor --android-licenses` och acceptera alla licenser genom att skriva `y`.
  * **Problem:** Bygget misslyckas med ett konstigt felmeddelande.
      * **Lösning 1:** Kör `flutter clean` i terminalen i ditt projekt. Detta rensar gamla byggfiler.
      * **Lösning 2:** Kör sedan `flutter pub get` för att säkerställa att alla beroenden är nedladdade.
      * **Lösning 3:** Försök köra `flutter run` igen.
  * **Problem:** Appen uppdateras inte när jag sparar koden.
      * **Lösning:** Kontrollera att du kör appen i "Debug"-läge (vilket `flutter run` gör som standard). Om Hot Reload (`r` i terminalen) inte fungerar, prova en Hot Restart (`R` i terminalen). Detta laddar om hela appen men är snabbare än en fullständig omstart.

Genom att följa denna guide steg-för-steg, med särskild vikt vid `flutter doctor`-steget, har du en mycket hög chans att lyckas denna gång. Lycka till\!