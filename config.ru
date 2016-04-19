require './config/environment'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

require 'sinatra'

require_relative 'app/controllers/application_controller'
require_relative 'app/controllers/users_controller'
require_relative 'app/controllers/lists_controller'
require_relative 'app/controllers/items_controller'

use Rack::MethodOverride
use UsersController
use ListsController
use ItemsController
run ApplicationController