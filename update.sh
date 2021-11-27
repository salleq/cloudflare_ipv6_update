#!/bin/bash

#change the variables as needed
interface=eno1
zone=ZONE ID WHERE DOMAIN(S) TO UPDATE RESIDE
record=DOMAIN RECORD TO UPDATE
token=SECRET TOKEN
domain=some.domain.com
old_ipv6=$(cat $domain.ipv6)
log_file=./$domain.log
ip6_file=./$domain.ipv6

#don't change anything below unless you need to update many (sub)domains to same IP

ipv6=$(ip addr show $interface | awk '/inet6 / {gsub(/\/.*/,"",$2); print $2}' | head -1)

#probably there is a better way to handle this than hardcoding '2001'
if ! [[ $ipv6 =~ ^(2001\:.*)$ ]];
then 
echo "exiting, no valid IPV6 found"
echo "exiting, no valid IPV6 found" >> $log_file
exit
fi

echo $old_ipv6
echo $ipv6

#Testing if saved IPV6 is different from saved one
if [ $ipv6 == $old_ipv6 ];
then
echo "No change, old ip is" $old_ipv6 "and current ip is "$ipv6


else 

echo "Updating, old ip is " $old_ipv6 "and doesn't equal new ip which is "$ipv6

#Updating IPV6
curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone/dns_records/$record" -H "Content-Type: application/json" -H "Authorization: Bearer $token" --data "{\"id\":\"$zone\",\"type\":\"AAAA\",\"name\":\"$domain\",\"content\":\"$ipv6\",\"proxied\":false}" >> $log_file
echo $'\n' >> $log_file

# Here the following 4 lines update another domain. If zone is same as above you don't need to declare the string again.

#zone=another_zone_id
#record=record_of_another_domain
#domain=another_domain_to_update
#curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone/dns_records/$record" -H "Content-Type: application/json" -H "Authorization: Bearer $token" --data "{\"id\":\"$zone\",\"type\":\"AAAA\",\"name\":\"$domain\",\"content\":\"$ipv6\",\"proxied\":false}" >> $log_file
#echo $'\n' >> $log_file

#saving current IPV6 to file to check for next time

echo $ipv6 > $ip6_file
echo "saved current ipv6 to file"

fi
