## Secret key  
DSVPN uses a shared secret. Create it with the following command:  

dd if=/dev/urandom of=vpn.key count=1 bs=32  
And copy it on the server and the client.  

If required, keys can be exported and imported in printable form:  

base64 < vpn.key  
echo 'HK940OkWcFqSmZXnCQ1w6jhQMZm0fZoEhQOOpzJ/l3w=' | base64 --decode > vpn.key  
## Example usage on the server  
sudo ./dsvpn server vpn.key auto 1959  
Here, I use port 1959. Everything else is set to the default values. If you want to use the default port (443), it doesn't even have to be specified, so the parameters can just be server vpn.key  

## Example usage on the client  
sudo ./dsvpn client vpn.key 34.216.127.34 1959  
This is a macOS client, connecting to the VPN server 34.216.127.34 on port 1959. The port number is optional here as well. And the IP can be replaced by a host name.  
