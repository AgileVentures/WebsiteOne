# ruby-gitter

Ruby gitter API Client

## Installation

Add this line to your application's Gemfile:

    gem 'ruby-gitter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-gitter

## Usage

To create a new client:

```ruby
require 'gitter'

# Create a new client
client = Gitter::Client.new('TOKEN')
```

The following client methods are available

### Rooms

```ruby
# Get a list of rooms
client.rooms

# Get the users of a specific room
client.room_users('ROOM_ID')

# Get the room channels
client.room_channels('ROOM_ID')

# join a room
client.join_room('kristenmills/ruby-gitter')
```

### Messages

```ruby
# Get a list of messages
client.messages('ROOM_ID', limit: 50)

# Send a message
client.send_message('Hello everyone', 'ROOM_ID')

#Update a message
client.update_message('Hello everybody', 'ROOM_ID', 'CHAT_ID')
```

### Users

```ruby
# Get the current user
client.current_user

# Get the users rooms
client.user_rooms('USER_ID')

# Mark the following chats as read
client.user_read_messages('USER_ID', 'ROOM_ID', ['CHAT_ID1', 'CHAT_ID2'])

# Get the users organizations
client.user_orgs('USER_ID')

# Get the users repos
client.user_repos('USER_ID')

# Get the users channels
client.user_channels('USER_ID')
```


## Contributing

1. Fork it ( http://github.com/<my-github-username>/ruby-gitter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
