clear

%--------------- bode plot settings ----------------------
options = bodeoptions
options.FreqUnits = 'Hz'
%---------------------------------------------------------

%--------------- power stage parameters ------------------
Vin = 60
Vout = 12
L = 22e-6
C = 230e-6
rc = 2.8167e-4
rl = 0
R = 2
Ri = 0.013
Fsw = 250e3
Tsw = 1/Fsw
D_ = 1 - Vout/Vin
D = Vout/Vin
S1 = (Vin - Vout) / L
S2 = Vin / L
A = 10
%----------------------------------------------------------

%---------------- lm5116 ramp calculation -----------------
Ir = 5e-6*(Vin - Vout) + 25e-6
Cr = 560e-12
Rr = 470e3
Vcc = 7.4
gm = 5e-6
Ios = Vcc / Rr + 25e-6
%----------------------------------------------------------

%---------------- power stage transfer function -----------
s = tf('s')

Ksl = gm * Tsw / Cr
Vsl = Ios * Tsw / Cr
Km = 1 / ((D - 0.5) * A * Ri * Tsw / L + (1 - 2 * D) * Ksl + Vsl / Vin)
wz = 1/(rc*C)
wp = 1/(R*C) + 1 / (Km * A * Ri * C)
wn = pi * Fsw
Se = ((Vin - Vout) * Ksl + Vsl)/Tsw
Sn = Vin * A * Ri / L
mc = Se / Sn
Q = 1 / (pi * (mc - 0.5))

Fp = (1 + s/wz) / (1 + s/wp) % 1p1z function

Fh = 1 / (1 + s / (wn * Q) + s^2/(wn^2)) % second order function

K = R / (Ri*A) * 1 / (1 + R/(Km * A * Ri)) % DC gain

Gps = K * Fp * Fh 

%----------------------------------------------------------

%--------------- feedback compensator (type II) ------------

Fc = 1/10 * Fsw             % selected cross-over freqeuncy, typically 1/5 to 1/10 of switching frequency
R1 = 12e3                   % upper feedback resistor
Rlo = 1.3e3                 % lower feedback resistor
Vdiv = Rlo / (Rlo + R1)     % percentage voltage feedback

PM = 55
[Gfc,PS] = bode(Gps,2*pi*Fc)
boost = PM - PS - 90        % amount of boost required
k = tand(boost/2+45)        % corresponding k factor

C2 = 1/(2*pi*Fc*(1/Gfc)*k*R1)   % remaining compensator components
C1 = C2*(k^2-1)
R2 = k/(2*pi*Fc*C1)
Hcomp = (1+s*R2*C1)/(s*R1*(C1+C2)*(1+s*R2*C1*C2/(C1+C2)))

figure(1)
margin(Gps)
figure(2)
margin( Hcomp * Gps)
figure(3)
bode(Hcomp)
% %----------------------------------------------------------


% mainsys = feedback(Gps*Hcomp,Vdiv)
% step(mainsys)