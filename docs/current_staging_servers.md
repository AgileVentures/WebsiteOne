### Staging
Deploys with Travis CI Continuous Deployment.

- develop: [websiteone-develop.herokuapp.com](http://websiteone-develop.herokuapp.com/) [![Build Status](https://travis-ci.org/AgileVentures/WebsiteOne.png?branch=develop)](https://travis-ci.org/AgileVentures/WebsiteOne) 
- staging: [websiteone-staging.herokuapp.com](http://websiteone-staging.herokuapp.com/) 
- master: [websiteone-production.herokuapp.com](http://websiteone-production.herokuapp.com/) [![Build Status](https://travis-ci.org/AgileVentures/WebsiteOne.png?branch=master)](https://travis-ci.org/AgileVentures/WebsiteOne)

### Developer servers

* [Yaro Heroku WSO](http://yaro.herokuapp.com/) -- [GitHub repo](https://github.com/AgileVentures/WebsiteOne)
* [Bill Heroku WSO](http://billwso.herokuapp.com/)  
    * **CSS styling missing** required rails_12factor gem which handles asset handling
* Daniel: http://websiteone-sponsors.herokuapp.com/
* Sampriti: http://websiteone-sampriti.herokuapp.com/
* Pete http://pete-wso.herokuapp.com/
* Bryan http://websiteone-bryan.herokuapp.co
* Marcelo: http://websiteone-marcelo.herokuapp.com/


### Issues
You might run into some issues with ssh keys. 

You have to upload your public key to Heroku:

```heroku keys:add ~/.ssh/id_rsa.pub```

If you don't have a public key, Heroku will prompt you to add one automatically which works seamlessly. Just use:

```heroku keys:add```
