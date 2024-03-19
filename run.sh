#!/bin/bash

wpath=$(pwd)

if [ ! -e "$wpath/wp-config.php" ]; then
    echo "Provide Full path to wordpress installation directory: (default: $wpath/public_html/) "
    read -r wpathn

    if [ -z "$wpathn" ]; then
    wpath="$wpath/public_html/"
    else 
    wpath=$wpathn
    fi
fi

echo "Update urls?[y/N]"
read update 
old=$(wp $wpath option get "home")

    if [ "$update" == "y" ]; then
        echo "New url: https://"
        read new
        echo "Old base url: $old"
        echo "New base url: https://$new"
        wp $wpath option update "home" "https://$new"
        wp $wpath option update "siteurl" "https://$new"
        wp $wpath search-replace "$old" "https://$new"  
    fi
    

echo "Add new admin?[y/N]"
read admin

if [ "$admin" == "y" ]; then
           
            echo "Login:"
            read login
            echo "Email:"
            read email
            echo "Password:"
            read password
            wp $wpath user create $login $email --user_pass=$password --role=administrator
    fi


wp $wpath plugin deactivate wordfence
wp $wpath plugin deactivate woo-checkout-field-editor-pro
wp $wpath rewrite flush --hard
wp $wpath cache flush





