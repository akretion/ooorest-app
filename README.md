NOTE: in this tutorial we often use the devstep hack command. This avoids the developer to have to clutter its deveopment machine with all the required Ruby runtime. But alternatively you can install Ruby 2+ and use regular bundle install commands if you prefer.


Creation of basic Odoo app with Voodoo (if you don't have any)
--------------------------------------------------------------

install http://voodoo.akretion.com/

```text
voodoo new voodoo-ooorest
cd voodoo-ooorest
voodoo run
ak run
```

the server is running on port 8069. Install a few modules in the default db database. Leave the admin user as admin with password admin for now.
let it running on port 8069


Creation of a basic Rails app (if you don't have one already you can also use the one of this repo)
---------------------------------------------------------------------------------------------------

Install Devstep (it's fast when you already have voodoo):

```text
docker pull fgrehm/devstep
```

see client installation here: http://fgrehm.viewdocs.io/devstep/cli/installation

```
mkdir ooorest-lab
cd ooorest-lab
vi Gemfile  # see repo for content
devstep hack # that will bring you inside a container with Ruby and required gems (Rails)
rails new ooorest-app --skip-bundle
```

exit from the container with CTRL+D

Injection of ooorest and devise in a basic Rails app

```
cd rails-app
vi Gemfile
```

add these lines:
```
gem 'devise' # not required for ooorest but we will use it here
gem 'ooorest', git: 'https://github.com/akretion/ooorest.git'
```

Now create a new file config/ooor.yml with the following content:

```yaml
development:
  url: http://localhost:8069/xmlrpc         #the OpenERP XML/RPC server
  database: db               #the OpenERP database you want to connect to
  username: admin
  password: admin
  global_context:
    'lang': en_US
```


Now launch a container with the proper dependencies.
Note that you'll need to link that container to the voodoo container. You can find the name of the Voodoo container with the command: docker ps

```text
devstep hack -p 3000:3000 --link <voodoo_container_name>:odoo
```

NOTE: I had a bug with the Rails server not being accessible on localhost:3000 (network rested by peer error). So instead I did a regular bundle install on the host

Inside the container, finish to install Devise:
rails generate devise:install

Pay attention to the instructions to configure the mailer if you need to

```
bundle exec rails generate devise User
bundle exec rails g devise:views
bundle exec rake db:migrate
```


Launch the Rails app:

```
bundle exec rails s
```
