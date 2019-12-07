#!/bin/bash
# Name of Google Cloud Storage Bucket
google_bucket="conflux-backups"
# Location to place backups.
backup_dir="/var/backups/databases/"
# Gmail sender
gmail_from="fnaquiravargas@gmail.com"
# Password of gmail Sender
gmail_pwd="123456"
# Receiver
gmail_to="fnaquira@conflux-aqp.com"
#String to append to the name of the backup files
backup_date=`date +%Y-%m-%d`
#Numbers of days you want to keep copy of your databases
number_of_days=3
databases=`psql -l -t | cut -d'|' -f1 | sed -e 's/ //g' -e '/^$/d'`
cp mail.txt out.txt
for i in $databases; do  if [ "$i" != "postgres" ] && [ "$i" != "template0" ]; then    
    echo Dumping $i to $backup_dir$i\_$backup_date.sql    
    pg_dump $i > $backup_dir$i\_$backup_date.sql
    #zipping sql
    zip $backup_dir$i\_$backup_date.zip $backup_dir$i\_$backup_date.sql
    #uploading to google cloud
    gsutil cp $backup_dir$i\_$backup_date.zip $google_bucket
    #printing file size to mail
    file_size=$(du -m $backup_dir$i\_$backup_date.zip | cut -f1)
    echo Backup de $i\_$backup_date.zip $file_size MB >> out.txt
  fi
done
#removing old files
find $backup_dir -type f -prune -mtime +$number_of_days -exec rm -f {} \;
#sending mail of good execution
curl --url 'smtps://smtp.gmail.com:465' --ssl-reqd --mail-from $gmail_from --mail-rcpt $gmail_to --upload-file out.txt --user $gmail_from:$gmail_pwd --insecure