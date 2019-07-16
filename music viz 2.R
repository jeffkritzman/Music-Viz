# heavily based on https://hansenjohnson.org/post/spectrograms-in-r/

################################################################
#
# Set parameters
#
################################################################

download.files = 0 #if need to get files, set to 1. else, set to 0.
num.points = 100
freq.mod = 7
# set working directory
#setwd("H:/R/Music Viz")
setwd("~/R/music viz")


################################################################
#
# Main code
#
################################################################

# Initialize libraries
library(googledrive)
library(stringr)
library(tuneR, warn.conflicts = F, quietly = T) # nice functions for reading and manipulating .wav files
library(signal, warn.conflicts = F, quietly = T) # signal processing functions
library(oce, warn.conflicts = F, quietly = T) # image plotting functions and nice color maps
library(tidyr)

#get file lists
mp3.list <- drive_ls(path = "Music Viz/mp3")
mp3.list <- drive_ls(path = "Music Viz/mp3") #only works half the time...
lyric.list <- drive_ls(path = "Music Viz/Lyrics")
slug.list <- as.vector(rep("", nrow(mp3.list)))
#make sure they're in the same order
mp3.list <- mp3.list[order(mp3.list$name),]
lyric.list <- lyric.list[order(lyric.list$name),]

################################################################
#
# Set up spectrogram function
#
################################################################

spectrogram <- function(mp3, num.points = 100, freq.mod = 7) { 
  # read in audio file
  mp3.name <- as.character(mp3["name"])
  if (str_detect(tolower(mp3.name),'.mp3')) {
    freq.data = readMP3(mp3.name)
  } else {
    freq.data = readWave(mp3.name)
  }
  
  # prep file
  snd1 = freq.data@left # extract signal
  snd1 = snd1 - mean(snd1) # de-mean to remove DC offset
  fs1 = freq.data@samp.rate # determine sample rate
  nfft=1024 # number of points to use for the fft
  window=256 # window size (in points)
  overlap=0 # overlap (in points)
  
  # create spectrogram. output variables: S(ignal), f(requency), t(ime)
  spec1 = specgram(x = snd1, n = nfft, Fs = fs1, window = window, overlap = overlap)
  P1 = abs(spec1$S) # discard phase information
  P1 = P1/max(P1) # normalize
  P1 = 10*log10(P1) # convert to dB
  t1 = spec1$t # get time axis
  z1 = t(P1) #transpose P
  f1 <- spec1$f #get frequency
  
  #set up and shrink data frame
  P1.ds <- as.data.frame(z1)
  colnames(P1.ds) <- f1
  P1.ds$t <- t1
  dim(P1.ds)
  #trim file: keep only num.points moments in time, evenly distributed through song
  r <- 1:nrow(P1.ds)
  mod <- round(nrow(P1.ds) / num.points)
  P1.ds <- P1.ds[r%%mod == 0,]
  
  #gather data frame and output to file
  gat1 <- gather(P1.ds, key = "freq", value = "level", -t) #pivot, i.e. make tidy
  write.csv(gat1, file = str_replace(mp3.list[i, "name"], ".mp3", ".csv"), row.names = FALSE)
}



for (i in 1:nrow(mp3.list)) {
  slug.list[i] <- str_replace(mp3.list[i, "name"], ".mp3", "")
  mp3 <- mp3.list[i, ]
  lyrics <- lyric.list[i, ]
  if (download.files == 1) {
    drive_download(mp3, overwrite = TRUE)
    drive_download(lyrics, overwrite = TRUE)
  }
  spectrogram(mp3 = mp3, num.points = num.points, freq.mod = freq.mod)
}

meta.data <- as.data.frame(slug.list)
meta.data$mp3.file <- mp3.list$name
meta.data$lyrics.file <- lyric.list$name
meta.data

