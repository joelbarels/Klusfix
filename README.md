# KlusFix 4.0 — afgeschermde online testomgeving

Dit pakket is **deploy-klaar**, maar is **niet door ChatGPT online gezet**. Je hebt zelf een server/VPS, domein en DNS-instelling nodig. Een VPS en domein kunnen geld kosten. Deze opzet is voor een **kleine, besloten test met fictieve gegevens**, niet voor een publieke commerciële lancering.

## Voorbereiding

1. Regel een Linux-server met Docker Engine + Docker Compose-plugin, een domein en een A-record `test.jouwdomein.nl` naar het publieke IP van je server. Open poorten 80 en 443 in de firewall.
2. Kopieer deze map naar de server. Voer in deze map uit: `cp .env.example .env`.
3. Maak een sterk testwachtwoord. Genereer de hash met `docker run --rm caddy:2-alpine caddy hash-password --plaintext 'JE_STERKE_TESTWACHTWOORD'`. Zet de volledige hash in `.env` bij `TEST_PASSWORD_HASH` **tussen enkele quotes**. Gebruik geen letterlijke voorbeeldhash.
4. Zet je echte testdomein in `.env` bij `APP_DOMAIN`. Voeg eventueel `GEMINI_API_KEY` toe. Zonder sleutel geeft de app uitsluitend basisregels en geen AI-fotoanalyse.
5. Start: `docker compose up -d --build`. Controleer: `docker compose ps` en `docker compose logs --tail=100 proxy app`.
6. Open `https://test.jouwdomein.nl` op je telefoon. De browser vraagt om de testgebruikersnaam en het testwachtwoord. Daarna registreer je binnen KlusFix afzonderlijke testaccounts als consument en vakman.

Caddy regelt automatisch HTTPS wanneer DNS, domein en poorten correct zijn ingesteld. Publiceer geen API-sleutels, echte klantgegevens of `.env`.

## Wat is nieuw in versie 4

- Dockerfile en Compose voor reproduceerbare serverinstallatie.
- HTTPS reverse proxy via Caddy met extra wachtwoord vóór de hele testapp.
- SQLite-bestand staat op een blijvend Docker-volume (`klusfix_data`) en blijft behouden na een normale containerherstart.
- API-sleutel staat uitsluitend als serveromgevingvariabele ingesteld.
- Serverfouten geven geen interne foutdetails meer terug aan bezoekers.

## Back-up en verwijderen

Stop de app voor een consistente back-up: `docker compose stop app`. Kopieer de database uit het volume met `docker compose run --rm --entrypoint sh app -c 'cat /data/klusfix.sqlite' > klusfix-backup.sqlite` (bewaar de back-up versleuteld en buiten de server). Herstart met `docker compose start app`. Verwijder het volume **niet** met `docker compose down -v`, tenzij je de database bewust wilt wissen.

## Beperkingen / voor publieke lancering vereist

- Geen automatische bedrijf-/identiteitsverificatie, wachtwoordreset, e-mailbevestiging, accountverwijdering of privacy-/bewaarbeleid.
- Geen rate limiting, anti-spam, CSRF-bescherming voor browser-gebaseerde basic-auth, of uitgewerkte logging-/incidentprocedures. Beperk testaccounts tot vertrouwde personen.
- Geen werkelijke betalingen, kaart/locatiezoekfunctie of PDF-export.
- De app slaat geen foto's in de database op; foto's worden bij toestemming tijdelijk naar de AI-dienst gestuurd. Gebruik uitsluitend fictieve testfoto's en deel geen herkenbare personen/adressen.
- Deze configuratie is niet gratis gegarandeerd: server, domein en AI-gebruik kunnen kosten meebrengen.
- De PWA-installatie en offline cache moeten op het gekozen apparaat en de browser worden getest.

## Lokaal zonder Docker

Node.js 24+: `node server.js` en open `http://localhost:8080`. Dit is alleen voor lokaal testen; het heeft geen externe HTTPS-toegangsbeveiliging.
