#!/bin/bash

echo "Configuring cron jobs..."

CRON_USER="cs2server"

if crontab -u $CRON_USER -l 2>/dev/null | grep -q "/home/cs2server/cs2server monitor"; then
    echo "Cron jobs already configured. Skipping."
    return
fi

(crontab -u $CRON_USER -l 2>/dev/null; echo "0 7 * * * /home/cs2server/cs2server monitor") | crontab -u $CRON_USER -
(crontab -u $CRON_USER -l 2>/dev/null; echo "0 8 * * * /home/cs2server/cs2server update") | crontab -u $CRON_USER -
(crontab -u $CRON_USER -l 2>/dev/null; echo "0 9 * * * /home/cs2server/cs2server restart") | crontab -u $CRON_USER -

echo "Cron jobs configured."