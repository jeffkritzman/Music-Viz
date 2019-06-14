# Music-Viz

This code provides a way to take WAV files and convert them into CSV files, using R.

I have borrowed heavily from Hansen Johnson's blog:
https://hansenjohnson.org/post/spectrograms-in-r/

There are parameters that let you choose what time sample to use.  I would suggest doing a 10 second or less time sample.  

The raw WAV file does not need to be edited prior to processing in R.

Basic workflow:
 * Run R script on desired file
 * Import the newly created CSV into desired data manipulation program
 * Have fun!
