require 'rubygems'
require 'sitemap_generator'



SitemapGenerator::Sitemap.default_host = 'https://www.eventcreate.com'
# pick a place safe to write the files
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(fog_provider: 'AWS',
                                         aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                                         aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
                                         fog_directory: ENV['S3_BUCKET_NAME'],
                                         fog_region: ENV['AWS_REGION'])

SitemapGenerator::Sitemap.sitemaps_host = "https://s3-#{ENV['AWS_REGION']}.amazonaws.com/#{ENV['S3_BUCKET_NAME']}"

# pick a namespace within your bucket to organize your maps
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'


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