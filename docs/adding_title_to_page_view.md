In `app/views/layouts/application.html.erb:4` we use following code:
   ```
   <title>
   <%= content_for?(:title) ? [yield(:title),  ' | AgileVentures - WebsiteOne'].join(' ') : '| AgileVentures -    WebsiteOne' %>
   </title>
```

Use `<% content_for :title do 'Your stylish WSO title' end %>` if you want to add title property to your view or static page. 