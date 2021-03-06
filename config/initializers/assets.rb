# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( editable/loading.gif )
Rails.application.config.assets.precompile += %w( editable/clear.png )
Rails.application.config.assets.precompile += %w( events.js )
Rails.application.config.assets.precompile += %w( dashboard.js )
Rails.application.config.assets.precompile += %w( registrations.js )
Rails.application.config.assets.precompile += %w( pages.js )
Rails.application.config.assets.precompile += %w( sessions.js )
Rails.application.config.assets.precompile += %w( urls.js )
Rails.application.config.assets.precompile += %w( themes.js )
Rails.application.config.assets.precompile += %w( users.js )
Rails.application.config.assets.precompile += %w( payments.js )
Rails.application.config.assets.precompile += %w( attendees.js )
Rails.application.config.assets.precompile += %w( tickets.js )
Rails.application.config.assets.precompile += %w( coupons.js )

# Rails.application.config.assets.precompile += %w( search.js )
