#EventCreate v.1.0

RoR version of the EventCreate website. 

* Ruby version

* System dependencies
After repo is cloned, run:
`bundle install` to install dependencies

* Configuration

* Database creation <br/>
`run rake db:migrate`

* Database initialization

* How to run the test suite
To run the site locally: <br/>
   * With foreman: `foreman start`
   * Without foreman: `rails s`

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions
    * Precompile assets: <br/>
    `RAILS_ENV=production bundle exec rake assets:precompile`
    * Add files and commit latest changes <br/>
    `git add .` <br/>
     `git commit -m 'COMMIT MESSAGE'`
    * Push files to repo <br/>
     `git push origin BRANCHNAME` 
   * Push to heroku <br/>
    `git push heroku master`

* ...


Please feel free to use a different markup language if you do not plan to run
<tt>rake doc:app</tt>.
