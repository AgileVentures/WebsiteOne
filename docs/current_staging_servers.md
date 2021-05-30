### Staging

- develop: [websiteone-develop.herokuapp.com](http://websiteone-develop.herokuapp.com/) [![Build Status](https://travis-ci.org/AgileVentures/WebsiteOne.png?branch=develop)](https://travis-ci.org/AgileVentures/WebsiteOne) 
- staging: [websiteone-staging.herokuapp.com](http://websiteone-staging.herokuapp.com/) 
- master: [websiteone-production.herokuapp.com](http://websiteone-production.herokuapp.com/) [![Build Status](https://travis-ci.org/AgileVentures/WebsiteOne.png?branch=master)](https://travis-ci.org/AgileVentures/WebsiteOne)

### Issues
You might run into some issues with ssh keys. 

You have to upload your public key to Heroku:

```heroku keys:add ~/.ssh/id_rsa.pub```

If you don't have a public key, Heroku will prompt you to add one automatically which works seamlessly. Just use:

```heroku keys:add```
