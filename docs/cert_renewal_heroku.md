# This method is obsolete.  Do certs right on Heroku now...
* [ ] updating av.org certs:
 - [ ] ensure servers are running ...
 - [ ] and shut down afterwards

```$ sudo certbot certonly --manual -d develop.agileventures.org
$ sudo heroku certs:update /etc/letsencrypt/live/develop.agileventures.org/fullchain.pem /etc/letsencrypt/live/develop.agileventures.org/privkey.pem  -r develop --confirm websiteone-develop

$ sudo certbot certonly --manual -d staging.agileventures.org
$ sudo heroku certs:update /etc/letsencrypt/live/staging.agileventures.org/fullchain.pem /etc/letsencrypt/live/staging.agileventures.org/privkey.pem  -r staging --confirm websiteone-staging

$ sudo certbot certonly --manual -d www.agileventures.org
$ sudo heroku certs:update /etc/letsencrypt/live/www.agileventures.org/fullchain.pem /etc/letsencrypt/live/www.agileventures.org/privkey.pem  -r production  --confirm websiteone-production
```
would love to 100% automate this
