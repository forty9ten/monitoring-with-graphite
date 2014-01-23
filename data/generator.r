N=15000
N=50

noisysin <- sin(seq(0,4*pi,by=0.01))+rnorm(N)+sin(seq(1,4*pi+1,by=0.01))/5+2*30
plot(noisysin, type="l")
write(noisysin, file="noisysin", ncolumns=1)

pulsy <- rweibull(n=N, shape=3, scale=0.2) + rnorm(N)
plot(pulsy, type="l")
write(pulsy, file="pulsy", ncolumns=1)

cpuish <- rbinom(N, size=5, prob=0.2) * 0.25 + 12 + sin(seq(0,4*pi,by=0.001))
plot(cpuish,type="l")
write(cpuish, file="cpuish", ncolumns=1)

help(rbinom)