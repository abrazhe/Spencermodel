TITLE Na current for [Spencer et al., 2012]'s octopus cell model initial segment. 

NEURON {
    SUFFIX nas
    USEION na READ ena WRITE ina
    RANGE gbar, g, ina
    GLOBAL minf, mtau, hinf, htau
}

UNITS {
    (mA) = (milliamp)
    (mV) = (millivolt)
}

PARAMETER {
    celsius (degC) : for qt = q10^((celsius-22)/10)
    ena = 55 (mV)
    gbar = 4.2441 (mho/cm2)
    q10 = 3
    
    
}
ASSIGNED {
    v (mV)
    ina (mA/cm2)
    g (mho/cm2)
    minf
    hinf
    mtau (ms)
    htau (ms)
    :qt
}

STATE {
    m h
}


BREAKPOINT {
    SOLVE states METHOD cnexp
    g = gbar*(m^3)*h
    ina = g*(v-ena)
}

INITIAL {
    params(v)
    h = hinf
    m = minf
}
UNITSOFF
LOCAL qt

DERIVATIVE states {
    params(v)
    m' = qt*(minf-m)/mtau
    h' = qt*(hinf-h)/htau
}


PROCEDURE params(v) {
    
    LOCAL hlp
   
    :TABLE hlp,  minf, hinf, mtau, htau FROM -400 TO 400 WITH 800
    
    qt = q10^((celsius - 22)/10)
    
    minf = 1/(1-(1.11*(v+58)/(v+49))*(exp(-(v+49)/3)-1)/(exp((v+58)/20)-1))
    mtau = 1/(0.4*((v+58)/(exp((v+58)/20)-1)) - 0.36*((v+49)/(exp(-(v+49)/3)-1)))
    
    hlp = 2.4/(1+exp((v+68)/3))  + 0.8/(1+exp(v+61.3))
    hinf = hlp/(hlp + 3.6/(1+exp(-(v+21)/10)))
    htau = 1/(hlp + 3.6/(1+exp(-(v+21)/10)))
}
UNITSON
COMMENT 
FUNCTION vtrap(x,y) {  :Traps for 0 in denominator of rate eqns.
        if (fabs(x/y) < 1e-6) {
                vtrap = y*(1 - x/y/2)
        }else{
                vtrap = x/(exp(x/y) - 1)
            }
	}
	ENDCOMMENT
	


