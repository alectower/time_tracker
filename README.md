TimeTracker
-----------

A Ruby CLI for project time tracking

Usage
-----

    user$ time_tracker

      Usage: time_tracker <command> [project]:[task] [OPTIONS]

          Commands
              track        track time for project tasks
              hours        print hours tracked for project tasks in date range

          Options
              -s, --start <YYYY-MM-DD>    used with hours command
              -e, --end <YYYY-MM-DD>      used with hours command

          Examples
              time_tracker track company:api
              time_tracker track company:api
              time_tracker track company:frontend
              time_tracker track company:frontend
              time_tracker hours company:api
              time_tracker hours company:frontend
              time_tracker hours company -s 2014-1-1
              time_tracker hours company -s 2014-1-1 -e 2014-2-1
              time_tracker hours -s 2014-1-1 -e 2014-2-1


Contributing
------------
1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Write specs (bundle exec rspec spec)
4. Commit your changes (git commit -am 'Add some feature')
5. Push to the branch (git push origin my-new-feature)
6. Create new Pull Request

Copyright (c) 2011 Alec Tower. See LICENSE.txt for
further details.
