require 'rubygems'
require 'sitemap_generator'



SitemapGenerator::Sitemap.default_host = 'https://www.eventcreate.com'

SitemapGenerator::Sitemap.sitemaps_host = "http://s3-#{ENV['AWS_REGION']}.amazonaws.com/sitemap-generator/"
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::WaveAdapter.new



SitemapGenerator::Sitemap.create do
    add '/'
    add '/features'
    add '/about'
    add '/pricing'
    add '/terms'
    add '/privacy'
    add '/users/sign_in'
    add '/users/sign_up'

end

#SitemapGenerator::Sitemap.ping_search_engines