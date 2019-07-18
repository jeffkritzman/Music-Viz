# Music-Viz

This code provides a way to take WAV or MP3 files and convert them into CSV files, using R. Version 2 also does word count and sentiment analysis on TXT files holding lyrics.

"music viz.r" inputs a locally saved audio file and returns a CSV for plotting a spectrogram.

"music viz 2.r" inputs audio files and lyrics files from Google Drive and returns multiple files, including spectrograms and sentiment analyses, and a metadata file.

For the spectrogram functionality, I have borrowed heavily from Hansen Johnson's blog:
https://hansenjohnson.org/post/spectrograms-in-r/

The raw audio files do not need to be edited prior to processing in R.

Basic workflows:

"music viz.r"
 * Run R script on desired file
 * Import the newly created CSV into desired data manipulation program
 * Have fun!

"music viz 2.r"
 * Create a folder in Google Drive called "Music Viz" 
 * * These folder names are case sensitive
 * Create a subfolder within "Music Viz" called "mp3", with MP3 or WAV files in it
 * Create a subfolder within "Music Viz" called "Lyrics", with TXT files of song lyrics in it
 * * To work properly, these should be the same songs as the songs in the "mp3" folder
 * Update the working directory
 * Set download.files = 1 if you need to download the files to your working directory
 * Run R script
 * Import the newly created CSVs into desired data manipulation program
 * Have fun!
