# OIT Umbrel App Store

Community-App-Store für Umbrel mit einer App: Threadfin als IPTV-Proxy für Plex. Der Store enthält keine Playlist-URLs und keine Zugangsdaten.

## Store hinzufügen

In umbrelOS: App Store, Menü mit den drei Punkten, Community App Stores, diese URL einfügen:

```text
https://github.com/andreasolbricht/umbrel-oit-store
```

Danach `Threadfin` (`oit-threadfin`) installieren. Vor der Installation prüfen, dass `app-data/oit-threadfin` auf dem Umbrel-Host noch nicht existiert. Ist das Verzeichnis da, nicht installieren und nicht deinstallieren, sondern den Inhalt zuerst ansehen. Eine Deinstallation löscht das gesamte App-Datenverzeichnis.

## Erster Start

1. Threadfin über das Umbrel-Dock öffnen. Dieser Weg verlangt die Umbrel-Anmeldung.
2. In Threadfin einen Benutzer anlegen und die WEB- sowie API-Authentifizierung einschalten, bevor eine Quellen-URL gespeichert wird. Ein leerer Erststart hat diese Schalter aus.
3. M3U und XMLTV nur in dieser Oberfläche eintragen. `http://127.0.0.1:34400/xmltv/threadfin.xml` antwortet erst, nachdem eine XMLTV-Quelle gespeichert wurde.
4. Den Puffer auf den Threadfin-Puffer stellen. Der Erststart steht auf direkter Weiterleitung.
5. SSDP in den Einstellungen ausschalten. Der Erststart hat es an, das Paket veröffentlicht dafür keinen UDP-Port.
6. Das In-App-Update auslassen. Ein leerer Erststart meldet es bereits als aus. Neue Stände kommen über das gepinnte Image.

## Plex

Die offizielle Umbrel-Plex-App nutzt das Host-Netz. Threadfin veröffentlicht `34400` nur auf `127.0.0.1`. Plex erreicht den Tuner damit lokal, ohne den Port ins LAN zu legen.

- Tuner, manuell: `http://127.0.0.1:34400`
- EPG: `http://127.0.0.1:34400/xmltv/threadfin.xml`

Vor dem Eintragen prüfen, dass der laufende Plex-Container wirklich `network_mode: host` hat. Dieses Paket ändert Plex nicht. SSDP-Erkennung ist nicht vorgesehen.

Umbrel leitet die Oberfläche über das App-Gateway an die Container-IP weiter. Der veröffentlichte Host-Port ist dafür nicht nötig. Umbrel versucht zusätzlich, `127.0.0.1:34400` selbst für das Gateway zu belegen. Das schlägt fehl, solange Docker denselben Loopback-Port hält, und Umbrel behält den LAN-Zugang zur angemeldeten Oberfläche. Aufrufe von `127.0.0.1:34400` auf dem Host gehen direkt an Threadfin. Die WEB-Anmeldung von Threadfin schützt dort `/web/`. Die HDHomeRun- und XMLTV-Pfade bleiben auf diesem Loopback ohne Zugangsdaten, damit Plex sie lesen kann.

## Image

`fyb3roptik/threadfin:1.2.37@sha256:96122ab220e14b881cbd40d7f8c7b022e1f9c6ecfe05aca2ab801e0321dc0d61`

Der Container läuft als User `31337:31337`, ohne Docker-Socket, ohne `privileged` und ohne Host-Netz. Konfiguration liegt unter `app-data/oit-threadfin/data/conf`.

## Lokal prüfen

```sh
export APP_DATA_DIR=/tmp/oit-threadfin
docker compose --project-directory oit-threadfin config
```

Die Design-Spec steht unter `docs/superpowers/specs/2026-11-09-threadfin-umbrel-design.md`.
