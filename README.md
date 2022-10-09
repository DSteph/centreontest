# centreontest

The application takes a single argument in the form of an absolute path to the file to be parsed.
i.e: >perl centreon-test.pl C:/Users/JaneDoe/Desktop/filetoparse.txt

The result will be saved in the same directory as the file to parse as : filetoparse_parsed.json

Multiple tests are run through to make sure the file exists, can be opened/read and that we have the rights to create a new file.

As for now, I considered whistespaces and it's cousins (tab, carriage return etc...) to not be counted as characters, but if need be it would represent a minor change in the code.