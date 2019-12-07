# Script para backups automaticos en servidor

Este script permite sacar un backup de todos los postgres presentes en una instancia y subirlos a **Google Cloud Storage**.

## Preparación

Primero, debemos crear la carpeta databases e instalar zip y Gcloud

```
sudo mkdir /var/backups/databases
sudo apt-get install -y zip
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update && sudo apt-get install -y google-cloud-sdk
```

Luego de instalado todo, debemos configurar nuestra cuenta de Google con:

```
gcloud init
```

Así mismo, debemos configurar las variables de nuestro script

-   **google_bucket**: Nombre del bucket donde subiremos los backups
-   **backup_dir**: Nombre del directorio donde guardaremos localmente nuestros backups
-   **gmail_from** Correo desde el que enviaremos la notificación
-   **gmail_pwd** Contraseña del correo anteriormente mencionado. Debe tener habilitado el inicio de sesión inseguro.
-   **gmail_to** Destinatario

## Ejecución

Para poder ejecutarlo, primero se le debe otorgar permisos de ejecucion:

```
chmod +x pg_backup_all.sh
```

Luego simplemente podemos llamarla como un ejecutable:

```
./pg_backup_all.sh
```

## Automatización

Para agregarlo como tarea automática en el servicio **cron** del servidor, debemos abrir el editor de cron:

```
crontab -e
```

Luego añadir una línea haciendo referencia a nuestro script.

```
30 2 * * * /opt/backup-postgres/pg_backup_all.sh
```
