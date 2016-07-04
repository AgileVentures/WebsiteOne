### THIS METHOS OF DEPLOYING ASSETS HAS BEEN DEPRECATED!

~~**In order to get assets to work on Heroku (js, css and images) we need to precompile them.**~~ 

~~The Rails asset pipeline provides an assets:precompile rake task to allow assets to be compiled and cached up front rather than compiled every time the app boots.~~

~~If you have made any changes to the css or js files or if you have added any images to the project, please run ```RAILS_ENV=production bundle exec rake assets:precompile``` to precompile assets before you make a PR.~~

~~Remember to add them to git with ```git add public/assets -A``` or ```git add . -A``` and make the commit and submit the PR.~~