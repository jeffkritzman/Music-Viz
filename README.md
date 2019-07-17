# Music-Viz

This code provides a way to take WAV or MP3 files and convert them into CSV files, using R.

For the spectrogram functionality, I have borrowed heavily from Hansen Johnson's blog:
https://hansenjohnson.org/post/spectrograms-in-r/

The raw audio files do not need to be edited prior to processing in R.

Basic workflow:
 * Create a folder in Google Drive called "Music Viz" - this is case sensitive
 * Create a subfolder within "Music Viz" called "mp3", with MP3 or WAV files in it
 * Create a subfolder within "Music Viz" called "Lyrics", with TXT files of song lyrics in it
 * * Ideally, these would be the same songs as the songs in the "mp3" folder
 * Update the working directory
 * Set download.files = 1 if you need to download the files to your working directory
 * Run R script
 * Import the newly created CSVs into desired data manipulation program
 * Have fun!
