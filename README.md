# lm5116_synchronous_buck
a 72W synchronous buck converter based on TI LM5116

- Features:
Input voltage range from 20 - 50V
Output Voltage: 12V    +- 2.5%
Output Current: Max 6A. Shuts off after reaching the limit
Max efficiency 96% at full load

- Notes
The inductor of this buck converter circuit is changed from a 22u vishay smd inductor to a 97u toroidal inductor due to excessive inductor heating at no load.
The suspected reason is the inductor current spiking at light load DCM. 
Replacing with higher inductance solves the issue in the design as it decreases the output load "boundary" to CCM
Further investigations on this behaviour still needed!

- Remaining issues
1. The current design has bad "acoustics". Inductor buzzing is audible. It is normal to have a buzzing noise in a switching converter prototype but it's still not
desirable. Further investigations needed on how to reduce this audible noise in a mature product.

2. After loading the converter and then returning back to no load, the buck converter still draws around 2.1W standby power - which is not seen when the circuit is first
powered up. Further inverstigations needed on this high standby power. It may have to do with the ic itself not in "standby" mode and / or the inductor current spiking
at no load

- Potential applications
This project is a prototype design using TI's LM5116 and may open up more design ideas involving this chip. For instance, a fan driver or an AA battery charger.
The feedback voltage can be made programmable easily by attaching a filtered-pwm / DAC / pull-down resistors to the feedback pin, thus enabling voltage programming
or even current regulation using an external control loop (e.g. using an MCU). This control scheme is suitable for chargers and variable power supply. Related project 
maybe added to the github in the future.

- Thanks
Big shout-outs to TI's engineers for their great documentation of the IC and their reference designs
