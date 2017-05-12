#!/bin/bash
./vendor/bin/nut database:update;
chmod 0777 ./public/files;
mkdir -p ./app/cache;
mkdir -p ./app/config;
mkdir -p ./app/database;
mkdir -p ./public/extensions;
mkdir -p ./public/extensions/var;
mkdir -p ./public/files;
chmod -R 0777 ./app;
chmod -R 0777 ./public/extensions;
IFS=","
set -- $BOLT_EXT
for element in $@
do
    eval "./vendor/bin/nut config:set extensions/stability dev";
    echo "Installing extestion $element";
    eval "./vendor/bin/nut extensions:install $element";
done

if [ -n "$BOLT_THEME" ]
then
    echo "Installing theme $BOLT_THEME";
    eval "./vendor/bin/nut config:set theme demo";
    eval "cp -prf extensions/vendor/$BOLT_THEME public/theme/demo"
    eval "cp -prf extensions/vendor/$BOLT_THEME public/theme/`basename $BOLT_THEME`"
else
  echo -e "BOLT_THEME not set\n"
fi

if [ -n "$BOLT_TITLE" ]
then
    eval "./vendor/bin/nut config:set sitename '$BOLT_TITLE'";
fi

rm -f /var/run/apache2/apache2.pid
exec apache2-foreground