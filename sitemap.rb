require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = 'http://example.com'
SitemapGenerator::Sitemap.create do
    add '/'
    add '/about'
    add '/terms'
    add '/users/sign_in'
    add '/users/sign_up'
end