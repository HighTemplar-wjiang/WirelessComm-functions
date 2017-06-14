# matlab-functions
Some useful Matlab functions for wireless communication simulations

Avaliable methods:
## 1. channels: channel related functions
- MIMO: MIMO related functions
  + alamouti_2x1_stbc: 2x1 MIMO Alamouti STBC channel
  + alamouti_2x2_stbc: 2x2 MIMO Alamouti STBC channel
  + beam_forming_bpsk: Mx1 BPSK modulated beam-forming
  + ml_bpsk: MxN BPSK modulated maximum likelihood receiver
  + mmse_bpsk: MxN MMSE equalizer with successive iterference cancellation and/or optimal ordering
  + mrc_bpsk: 1xN BPSK modulated MRC
  + zf_bpsk: MxN BPSK modulated zero-forcing equalizer

- Modulations: modulators & demodulators
  + modulator: general modulator
  + soft_demodulator: general soft demodulator
  + mod_16qam_gray: 16-QAM modulator with Gray code
  + dem_16qam_gray: 16-QAM demodulator with Gray code
  + mod_qpsk_gray: QPSK modulator with Gray code
  + dem_qpsk_gray: QPSK demodulator with Gray code

- Generations: generate random numbers for channel usage
  + universal channel: Fading channel and AWGN channel
  + awgn_channel: AWGN channel
  + rayleigh_channel: Rayleigh fading channel
  + generate_channel_coeff: generate channel coefficients
  + generate_noise: generate channel noises

- Miscellaneous
  + channel_test: test channels
  + rep_perms: generate permutation with repicas

## 2. functions
