web: bin/rails server -p $PORT -e $RAILS_ENV
GenerateTeachersCsvJob: bundle exec sidekiq -c 2
GenerateStudentsCsvJob: bundle exec sidekiq -c 2
GenerateStudentsCoursesCsvJob: bundle exec sidekiq -c 2
GenerateCoursesCsvJob: bundle exec sidekiq -c 2