require 'rubygems'
require 'sitemap_generator'


  # S3_BUCKET_NAME: eventcreate-v1
  # AWS_ACCESS_KEY_ID: AKIAJGOWMDQIYISFYT6Q
  # AWS_SECRET_ACCESS_KEY: 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
  # AWS_REGION: us-west-1

SitemapGenerator::Sitemap.default_host = 'https://www.eventcreate.com'

SitemapGenerator::Sitemap.sitemaps_host = "http://s3-"+ ENV['AWS_REGION'] + ".amazonaws.com/"+ ENV['S3_BUCKET_NAME'] +"/"
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

SitemapGenerator::Sitemap.ping_search_engines