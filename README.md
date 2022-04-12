# cloudflare_ipv6_update
A script to update just the IPV6 address of wanted domain

I tried several update scripts and also different dyndns updaters but none really worked on updating my IPV6 address in Cloudflare.
So I created this one. You can add/remove more domains to update to the same IP by just changing the record (and possibly zone) ID variables and adding more curl rows.

I've "forked" this by looking at several different updater scripts that didn't work for me, can't remember the people who did them but thanks anyway.

Just copy the shell script, chmod +x and change the needed variables in settings file (change filename to settings.env).Domain id can be found from Cloudflare audit log, Zone id is displayed on the overview page of the zone. Use cron or whatever you like to schedule updates.
