To deploy into staging:

1. Confirm you have privileges to push to https://git.heroku.com/websiteone-staging.git
1. In github: merge develop to staging
2. Clone websiteone if not already cloned
```
git clone https://github.com/websiteone.git
```
2. If remote not set for heroku:
  ```
  git add heroku https://git.heroku.com/websiteone-staging.git
  ```
3.  Checkout and pull from staging
```
cd websiteone
git checkout staging
git pull origin staging
```
4. Push to heroku
```
git push staging heroku:master
```
