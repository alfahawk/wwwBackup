#/bin/bash

days_2_keep=10
www_path='/var/www'
backup_path='/home/murat/'

#lets make a backup directory
if [ ! -d $backup_path ]; then
  mkdir -p $backup_path
fi

#go to www directory
cd "$www_path"
if [ "$(pwd)" != "$www_path" ] ; then
 echo "failed to cd 2 www directory"
 exit
fi


#-L--> FILE exists and is a symbolic link
#-d--> FILE exists and is a directory

for website in * ; do
  if [[ -d $website && ! -L "$website" ]]; then
    echo "Found website folder: $website"
    date=$(date -I)
    tar -cvpzf $backup_path/$date-$website.tar.gz $website
  fi
done

# Delete old backups
#-gt--> "grater than"
if [ "$days_2_keep" -gt 0 ] ; then
  echo "Deleting backups older than $days_2_keep days"
  find $backup_path/* -mtime +$days_2_keep -exec rm {} \;
fi
