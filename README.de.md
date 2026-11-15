# TeslaMate API Add-on-Repository

[English](README.md) · **Deutsch**

![TeslaMate API Add-on](docs/images/banner.svg)

Home-Assistant-Add-on-Repository, das [tobiasehlert/teslamateapi](https://github.com/tobiasehlert/teslamateapi) als richtiges, installier- und aktualisierbares Add-on bereitstellt. TeslaMate API liefert eine REST-API (JSON) über deine [TeslaMate](https://github.com/teslamate-org/teslamate)-Daten – Fahrzeuge, Fahrten, Ladevorgänge, Status –, die Home Assistant mit `rest`-Sensoren lesen kann.

![Laufzeit: TeslaMate → Add-on → Home Assistant](docs/images/how-it-works.svg)

## Warum es dieses Repo gibt

Der Supervisor von Home Assistant erkennt Updates nur bei Add-ons aus einem echten Add-on-Repository (ein Git-Repo mit `repository.yaml` und einem Ordner pro Add-on). Ein `local`-Add-on (direkt auf dem Host unter `/addons/local/...` gebaut) hat kein Upstream zum Vergleichen und zeigt deshalb nie „Update verfügbar“ – auch wenn das Projekt neue Versionen veröffentlicht.

Dieses Repo behebt das: ein minimales Add-on-Repository mit nur dem Add-on `teslamateapi`, festgelegt auf ein bestimmtes Upstream-Image in `teslamateapi/Dockerfile`.

## Automatisch aktuell bleiben

![Upstream-Release → GitHub Action → dieses Repo → Supervisor](docs/images/auto-update.svg)

[`.github/workflows/check-upstream.yml`](.github/workflows/check-upstream.yml) läuft täglich, prüft das neueste Release von [tobiasehlert/teslamateapi](https://github.com/tobiasehlert/teslamateapi) und erhöht bei einer neueren Version `BUILD_FROM` in `teslamateapi/Dockerfile` sowie `version` in `teslamateapi/config.yaml` und pusht den Commit. Der Supervisor sieht die neue Version bei der nächsten Prüfung und aktualisiert das Add-on – mit eingeschaltetem „Automatisch aktualisieren“ – selbst.

## Einrichtung

1. **Einstellungen → Add-ons → Add-on-Store → ⋮ → Repositories** und `https://github.com/dr-apple/ha-teslamateapi-addon` hinzufügen.
2. **TeslaMate API** im Store installieren.
3. Die Optionen ausfüllen (siehe unten) – sie sind im Repo absichtlich leer, weil es öffentlich ist.
4. Add-on starten, optional **Automatisch aktualisieren** und **Beim Booten starten** einschalten.
5. Wer vorher ein `local_teslamateapi`-Add-on hatte: es entfernen, sobald das neue mit denselben Einstellungen läuft.

## Optionen

| Option | Standard | Bedeutung |
|---|---|---|
| `database_host` / `database_port` | – / `5432` | PostgreSQL von TeslaMate (z. B. DB-Host des TeslaMate-Add-ons) |
| `database_user` / `database_pass` / `database_name` | `postgres` / – / `teslamate` | DB-Zugangsdaten |
| `database_ssl` / `database_timeout` | `disable` / `60000` | SSL-Modus und Timeout (ms) |
| `encryption_key` | – | `ENCRYPTION_KEY` von TeslaMate (für Befehle nötig) |
| `mqtt_host` / `mqtt_port` / `mqtt_user` / `mqtt_pass` / `mqtt_tls` | – / `1883` / – / – / `false` | MQTT-Broker, an den TeslaMate sendet |
| `mqtt_namespace` | – | Nur falls TeslaMate einen MQTT-Namespace nutzt |
| `disable_mqtt` | `false` | Ohne MQTT betreiben (Status-Endpunkt dann nicht verfügbar) |
| `teslamate_host` / `teslamate_port` / `teslamate_ssl` | – / `4000` / `false` | TeslaMate-Weboberfläche (für Links) |
| `timezone` | `Europe/Berlin` | Zeitzone der API-Ausgabe |
| `api_token` / `api_token_disable` | – / `false` | Bearer-Token zum Schutz der API |
| `enable_commands` / `commands_all` | `false` / `false` | Fahrzeugbefehle über die API erlauben (mit Vorsicht) |
| `debug_mode` | `false` | Ausführliches Log |

Beispiel:

```yaml
database_host: xxxxxxxx-postgres
database_pass: "dein-db-passwort"
database_name: teslamate
mqtt_host: core-mosquitto
mqtt_user: teslamate
mqtt_pass: "dein-mqtt-passwort"
teslamate_host: 192.168.1.10
api_token: "ein-langes-zufaelliges-token"
```

## Nutzung in Home Assistant

Die API lauscht auf Port `8080` im Add-on-Netz (und per Ingress in der Seitenleiste). Aus Home Assistant den Hostnamen des Add-ons verwenden, der auf seiner *Info*-Seite steht (`xxxxxxxx-teslamateapi`), oder Port 8080 unter *Netzwerk* freigeben und die Host-IP nehmen. Beispiel-`rest`-Sensor für den Akkustand von Fahrzeug 1:

```yaml
rest:
  - resource: http://xxxxxxxx-teslamateapi:8080/api/v1/cars/1/status
    headers:
      Authorization: Bearer ein-langes-zufaelliges-token
    scan_interval: 60
    sensor:
      - name: Tesla Akkustand
        value_template: "{{ value_json.data.status.battery_details.battery_level }}"
        unit_of_measurement: "%"
        device_class: battery
```

Alle Endpunkte stehen in der [teslamateapi-Dokumentation](https://github.com/tobiasehlert/teslamateapi#api-endpoints).

## Hinweise

- Architektur: nur `amd64` (wie das veröffentlichte Upstream-Image).
- Kein offizielles Projekt von TeslaMate, TeslaMate API oder Tesla.
