To use the provided files, run the following
```
docker run -it --rm --name my-running-script -v "$PWD":/usr/src/myapp -w /usr/src/myapp ruby:3.3 ruby runner.rb jobseekers.csv jobs.csv
```

TODO:
1.  Add a validation on the file inputs requiring jobseeker_id, job_id, etc columns which are needed in the output
2.  Add specs for file output (how do you test file creation? eg delete output file at start of test and then read output file as part of the test?
3.  Add more output options (STDOUT?)

NOTES:
1.  Moving the data to a relational database would make querying and ordering a lot simpler
