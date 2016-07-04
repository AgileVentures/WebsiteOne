## Usage

We use tags on projects to in the context of setting search criteria for retrieval of YT videos for the project. The tags, along the projects title, are used to pull videos from all project members connected YT channels.

### Setting tags

Open the console by running `$ heroku run rails c` or `$ heroku run rails c --remote production` 

Search for a project and add it to a variable. Search by id or, fince we are using friendly_id's, by the projects slug: `p = Project.find_by_slug('the-odin-project')`

Add a tag by: `p.tag_list.add("odin")` or a series of tags by `p.tag_list.add("odin, learning, web-development", parse: true)`

Remove tags by: `p.tag_list.remove("...")` 

Finish it all by saving the object: `p.save`