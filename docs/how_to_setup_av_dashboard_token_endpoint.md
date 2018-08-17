## Setting up the secret tokens
You will need to generate a secret token that is 512 bits, or 64 bytes, long.  In python 3, you can do this by:-

```
  import secrets
  secrets.token_hex(64)
```

Then you need to put that token into the WebsiteOne deployed app under the environmental variable AV_DASHBOARD_SECRET_TOKEN.

This same token will also need to be put into the appropriate environmental variable on the AVDashboard app.

## Giving a specific user access to the dashboard

In general, for a user to be given access to the dashboard, they should sign the current [Agile Ventures Data Sharing Agreement](http://bit.ly/AV-confidentiality).  Provided, they have done this, you can give them access to the dashboard if you know their email as follows in the rails console:-

```
  Users.find_by(email: "somedude@gmail.com").update(can_see_dashboard: true)
```
