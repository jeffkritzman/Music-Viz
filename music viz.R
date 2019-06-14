# heavily based on https://hansenjohnson.org/post/spectrograms-in-r/

################################################################
#
# Set parameters
#
################################################################

# how long of a sample should be taken? In seconds. I suggest 10 or shorter.
sampleTime <- 10 
# when should the sample start? In seconds.
offsetTime <- 60
# example: if offsetTime = 60 and sampleTime = 10, the code will return data for the given song between 1:00 and 1:10

# set working directory
setwd("H:/R/Music Viz")

# define path to audio file(s)
Song1 = 'ArringtonDeDionyso_ManiMalaikat.wav'
# Song2 = 'BeatCulture_Midori.wav'
# Song3 = 'BebeFang_Work.wav'
# Song4 = 'BlueDucks_FourFlossFiveSix.wav'
# Song5 = 'CscFunkBand_BadBananaBread.wav'

# define output file name(s)
csvFile1 = 'song1_spectrogram.csv'
# csvFile2 = 'song2_spectrogram.csv'
# csvFile3 = 'song3_spectrogram.csv'
# csvFile4 = 'song4_spectrogram.csv'
# csvFile5 = 'song5_spectrogram.csv'

# uncomment lines as needed if you want to process more than one song at a time


################################################################
#
# Main code
#
################################################################

library(tuneR, warn.conflicts = F, quietly = T) # nice functions for reading and manipulating .wav files

# read in audio files
data1 = readWave(Song1)
# data2 = readWave(Song2)
# data3 = readWave(Song3)
# data4 = readWave(Song4)
# data5 = readWave(Song5)

# extract signal
snd1 = data1@left
# snd2 = data2@left
# snd3 = data3@left
# snd4 = data4@left
# snd5 = data5@left

# de-mean to remove DC offset
snd1 = snd1 - mean(snd1)
# snd2 = snd2 - mean(snd2)
# snd3 = snd3 - mean(snd3)
# snd4 = snd4 - mean(snd4)
# snd5 = snd5 - mean(snd5)

nfft=1024 # number of points to use for the fft
window=256 # window size (in points)
overlap=128 # overlap (in points)

library(signal, warn.conflicts = F, quietly = T) # signal processing functions
library(oce, warn.conflicts = F, quietly = T) # image plotting functions and nice color maps

# determine sample rate
fs1 = data1@samp.rate
# fs2 = data2@samp.rate
# fs3 = data3@samp.rate
# fs4 = data4@samp.rate
# fs5 = data5@samp.rate

# create spectrogram
# output variables: S(ignal), f(requency), t(ime)
spec1 = specgram(x = snd1, n = nfft, Fs = fs1, window = window, overlap = overlap)
# spec2 = specgram(x = snd2, n = nfft, Fs = fs2, window = window, overlap = overlap)
# spec3 = specgram(x = snd3, n = nfft, Fs = fs3, window = window, overlap = overlap)
# spec4 = specgram(x = snd4, n = nfft, Fs = fs4, window = window, overlap = overlap)
# spec5 = specgram(x = snd5, n = nfft, Fs = fs5, window = window, overlap = overlap)

# discard phase information
P1 = abs(spec1$S)
# P2 = abs(spec2$S)
# P3 = abs(spec3$S)
# P4 = abs(spec4$S)
# P5 = abs(spec5$S)

# normalize
P1 = P1/max(P1)
# P2 = P2/max(P2)
# P3 = P3/max(P3)
# P4 = P4/max(P4)
# P5 = P5/max(P5)

# convert to dB
P1 = 10*log10(P1)
# P2 = 10*log10(P2)
# P3 = 10*log10(P3)
# P4 = 10*log10(P4)
# P5 = 10*log10(P5)

# get time axis
t1 = spec1$t
# t2 = spec2$t
# t3 = spec3$t
# t4 = spec4$t
# t5 = spec5$t

#transpose P
z1 = t(P1)
# z2 = t(P2)
# z3 = t(P3)
# z4 = t(P4)
# z5 = t(P5)

#get frequency
f1 <- spec1$f
# f2 <- spec2$f
# f3 <- spec3$f
# f4 <- spec4$f
# f5 <- spec5$f

# to reduce size of files, I suggest taking a sample of roughly 10 seconds
# this turns out to be about 3451 lines, with an associated csv of about 88 MB
# 1 second of a standard WAV file is about 345 lines
size <- 345 * sampleTime
offset <- 345 * offsetTime #skip the intro
size <- size + offset - 1

P1.ds <- as.data.frame(z1)
colnames(P1.ds) <- f1
P1.ds$t <- t1
dim(P1.ds)
P1.ds <- P1.ds[offset:size,] 
dim(P1.ds)

# P2.ds <- as.data.frame(z2)
# colnames(P2.ds) <- f2
# P2.ds$t <- t2
# dim(P2.ds)
# P2.ds <- P2.ds[offset:size,]
# dim(P2.ds)
# 
# P3.ds <- as.data.frame(z3)
# colnames(P3.ds) <- f3
# P3.ds$t <- t3
# dim(P3.ds)
# P3.ds <- P3.ds[offset:size,]
# dim(P3.ds)
# 
# P4.ds <- as.data.frame(z4)
# colnames(P4.ds) <- f4
# P4.ds$t <- t4
# dim(P4.ds)
# P4.ds <- P4.ds[offset:size,]
# dim(P4.ds)
# 
# P5.ds <- as.data.frame(z5)
# colnames(P5.ds) <- f5
# P5.ds$t <- t5
# dim(P5.ds)
# P5.ds <- P5.ds[offset:size,]
# dim(P5.ds)

library(tidyr)
gat1 <- gather(P1.ds, key = "freq", value = "level", -t)
# gat2 <- gather(P2.ds, key = "freq", value = "level", -t)
# gat3 <- gather(P3.ds, key = "freq", value = "level", -t)
# gat4 <- gather(P4.ds, key = "freq", value = "level", -t)
# gat5 <- gather(P5.ds, key = "freq", value = "level", -t)

write.csv(gat1, file = csvFile1, row.names = FALSE)
# write.csv(gat2, file = csvFile2, row.names = FALSE)
# write.csv(gat3, file = csvFile3, row.names = FALSE)
# write.csv(gat4, file = csvFile4, row.names = FALSE)
# write.csv(gat5, file = csvFile5, row.names = FALSE)
