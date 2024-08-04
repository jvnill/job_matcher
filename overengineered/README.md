To use the provided files, run the following
```
docker run -it --rm --name my-running-script -v "$PWD":/usr/src/myapp -w /usr/src/myapp ruby:3.3 ruby runner.rb jobseekers.csv jobs.csv
```
