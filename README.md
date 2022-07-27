# Wireguard-ui-setup

This scripts helps to setup the [wireguard-ui](https://github.com/ngoduykhanh/wireguard-ui) project into the your machine. It enables:

- Setup the server interface
- Setup the clients interfaces
- Restart wireguard-ui with no interruption

## How to execute

Open the file `wireguard-ui-setup.sh` and edit the parameteres in the begin of the file:

```
export WIREGUARD_UI_VERSION=0.3.7
export WIREGUARD_UI_PLATFORM=linux-arm64
export WG_INTERFACE=wg0
export WG_DIRECTORY=/opt/wireguard-ui
export WG_ARGS=''
```

The latest `WIREGUARD_UI_VERSION` can be found at [https://github.com/ngoduykhanh/wireguard-ui/releases](https://github.com/ngoduykhanh/wireguard-ui/releases)

Check the `WIREGUARD_UI_PLATFORM`. Available platforms are:
- linux-arm64
- linux-amd64
- linux-386
- linux-arm
- freebsd-386
- freebsd-amd64
- freebsd-arm
- freebsd-arm64

For the WG_ARGS the available arguments are:

```
Usage of /opt/wireguard-ui/wireguard-ui:
  -bind-address string
    	Address:Port to which the app will be bound. (default "0.0.0.0:5000")
  -disable-login
    	Disable authentication on the app. This is potentially dangerous.
  -email-from string
    	'From' email address.
  -email-from-name string
    	'From' email name. (default "WireGuard UI")
  -sendgrid-api-key string
    	Your sendgrid api key.
  -session-secret string
    	The key used to encrypt session cookies.
  -smtp-auth-type string
    	SMTP Auth Type : Plain or None. (default "None")
  -smtp-hostname string
    	SMTP Hostname (default "127.0.0.1")
  -smtp-no-tls-check
    	Disable TLS verification for SMTP. This is potentially dangerous.
  -smtp-password string
    	SMTP Password
  -smtp-port int
    	SMTP Port (default 25)
  -smtp-username string
    	SMTP Password
```

## More information

[https://github.com/ngoduykhanh/wireguard-ui/](https://github.com/ngoduykhanh/wireguard-ui/)