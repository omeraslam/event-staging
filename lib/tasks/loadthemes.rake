namespace :loadthemes do
    desc 'Add default themes'
    task :default_theme => :environment do
        Theme.create( :name => 'Wedding', :slug => 'wedding', :active => true, :layout_type => 'wedding', :icon => 'line-rings', :font_type => 'brandon', :bg_opacity => 0.5, :bg_color => '#222')     
        Theme.create( :name => 'Concert', :slug => 'concert', :active => true, :layout_type => 'concert', :icon => 'line-note', :font_type => 'brandon', :bg_opacity => 0.5, :bg_color => '#222')   
        Theme.create( :name => 'Fundraiser/Gala', :slug => 'gala', :active => true, :layout_type => 'gala', :icon => 'line-hands', :font_type => 'brandon', :bg_opacity => 0.5, :bg_color => '#222')   
        Theme.create( :name => 'Sports Event', :slug => 'sport', :active => true, :layout_type => 'sport', :icon => 'line-trophy', :font_type => 'brandon', :bg_opacity => 0.5, :bg_color => '#222')   
        Theme.create( :name => 'Party', :slug => 'party', :active => true, :layout_type => 'party', :icon => 'line-cocktail', :font_type => 'brandon', :bg_opacity => 0.5, :bg_color => '#222')
   
        Theme.create( :name => 'Other', :slug => 'other', :active => true, :layout_type => 'other', :icon => 'line-balloon', :font_type => 'brandon', :bg_opacity => 0.5, :bg_color => '#222')
    end

    desc "Run all loadthemes tasks"
    task :all => [:default_theme]
end