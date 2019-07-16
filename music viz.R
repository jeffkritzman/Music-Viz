# heavily based on https://hansenjohnson.org/post/spectrograms-in-r/

################################################################
#
# Set parameters
#
################################################################

# set working directory
setwd("H:/R/Music Viz")

# define path to audio file.  Only MP3 and WAV files are accepted.
Song1 = '9_Gillicuddy_Springish.mp3'

# define output file name.  Must be a CSV.
csvFile1 = '9_Gillicuddy_Springish_spectrogram.csv'

# how long of a sample should be taken? In seconds. I suggest 10 or shorter.
sampleTime <- 10 
# when should the sample start? In seconds.
offsetTime <- 15
# example: if offsetTime = 15 and sampleTime = 10, the code will return data for the given song between 0:15 and 0:25

#how many samples per second?
sampleRate <- 25 #suggested range: 10-100, higher sample rate gives better resolution but bigger file.

################################################################
#
# Main code
#
################################################################

library(stringr)
library(tuneR, warn.conflicts = F, quietly = T) # nice functions for reading and manipulating .wav files

# read in audio file
if (str_detect(tolower(Song1),'.mp3')) {
  data1 = readMP3(Song1)
} else {
  data1 = readWave(Song1)
}

snd1 = data1@left # extract signal
snd1 = snd1 - mean(snd1) # de-mean to remove DC offset

library(signal, warn.conflicts = F, quietly = T) # signal processing functions
library(oce, warn.conflicts = F, quietly = T) # image plotting functions and nice color maps

fs1 = data1@samp.rate # determine sample rate
nfft=1024 # number of points to use for the fft
window=256 # window size (in points)
overlap=0 # overlap (in points)

# create spectrogram
# output variables: S(ignal), f(requency), t(ime)
spec1 = specgram(x = snd1, n = nfft, Fs = fs1, window = window, overlap = overlap)

P1 = abs(spec1$S) # discard phase information
P1 = P1/max(P1) # normalize
P1 = 10*log10(P1) # convert to dB
t1 = spec1$t # get time axis
z1 = t(P1) #transpose P
f1 <- spec1$f #get frequency

# 1 second of a standard WAV file is about 173 lines and makes a 4.5 MB CSV
linesPerSec <- 173
size <- linesPerSec * sampleTime
offset <- linesPerSec * offsetTime #skip the intro
size <- size + offset - 1

P1.ds <- as.data.frame(z1)
colnames(P1.ds) <- f1
P1.ds$t <- t1
dim(P1.ds)
P1.ds <- P1.ds[offset:size,] 
dim(P1.ds)
P1.ds[1:5,1:5]
r <- 1:nrow(P1.ds)
mod <- round(linesPerSec / sampleRate)
P1.ds <- P1.ds[r%%mod == 0,]
dim(P1.ds)
P1.ds[1:5,1:5]

library(tidyr)

gat1 <- gather(P1.ds, key = "freq", value = "level", -t) #pivot, i.e. make tidy
write.csv(gat1, file = csvFile1, row.names = FALSE)

