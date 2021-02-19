////////////////////////////////////////////////////////////////////
///// Tools for the music of Francesca Woodman /////////////////////
////////////////////////////////////////////////////////////////////
~path = thisProcess.nowExecutingPath.dirname;
(~path ++ "/preload.scd").load;


//////////////////////////////////
// DOUBLEBASS
//////////////////////////////////

// minimal version dbs (dark bass tones):
~funcs['a'][0] = {PZ_layer(~bass_random_dbs).rhythm([4])};

// minimal version dbsl (bright bass tones):
~funcs['a'][0] = {PZ_layer(~bass_random_dbsl).rhythm([1])};

// minimal version (other):
~funcs['a'][0] = {PZ_layer(~bass_random).rhythm([2])};

// more rhythm (1 sample played each beat):
~funcs['a'][0] = {PZ_layer(~bass_random).rhythm(1,1, 1,1)};

// more rhythm (more complex rhythm):
~funcs['a'][0] = {PZ_layer(~bass_random).rhythm(1,[2],1,[2])}; // francesca 3
~funcs['a'][1] = {PZ_layer(~bass_random).rhythm(1,[2],1,[2])}; // francesca 3

// play noise samples
~funcs['a'][1] = {PZ_layer(~alarmclock).rhythm([3], 3, [3], 1)};

//////// choosing the sample:
~funcs['a'][2] = {PZ_layer(~bass, ~buffers['dbplukk'][1.rrand(22)], 0.rrand(1)).rhythm(1)};

// stop all
~funcs['a'].do{|f, i| ~funcs['a'][i] = ();}

//////////////////////////////////
/// RADIO FREQUENCIES
//////////////////////////////////
x = Synth(\sampleNarcodeStr, [\buf, ~buffers['radio1'], \gap, 0, \rl, 1, \loop, 1, \rate, 1, \pos, 0.3]);
x.release;

x = ~sampler.(~buffers['radio2'], loop:1, gap:0, sust:0);
x.set(\gap, 4, \at, 0.2, \rl, 0.01, \sust, 0);
x.release(1); //stop

y = ~sampler.(~buffers['radio1'], loop:1, gap:0, sust:0);
y.set(\gap, 0.2, \at, 0, \rl, 0.2, \sust, 0, \amp, 4);
y.release //stop

//////////////////////////////////
/// MINIMAL BEATS
//////////////////////////////////

/////// minimal beat:
t.tempo=0.2
// arguments are: buffer, out channel, attack, releasel, amp, rate
~funcs['a'][0] = {PZ_layer(~alarmclock, ~buffers['radio'][1], 0.rrand(8), 0.1.rrand(0.3), 0.01, 0.5, 1.rrand(3)).rhythm(0.rrand(2),0,0,0)};

~funcs['a'][1] = {PZ_layer(~alarmclock, ~buffers['radio'][1], 0.rrand(8), 0.01, 0.1.rrand(0.3), 0.5, 1.rrand(3)).rhythm(0.rrand(1), [0.rrand(2)], 0, [0,0,0.rrand(2)])};

~funcs['a'][2] = {PZ_layer(~alarmclock, ~buffers['radio'][1], 0.rrand(8), 0.01, 0.1.rrand(0.6), 0.8, 1.rrand(3)).rhythm(0, 0, 0, [0,4.rrand(2)])};

~funcs['a'][3] = {PZ_layer(~alarmclock, ~buffers['radio'][1], 0.rrand(8), 0.1.rrand(0.3), 0.01, 0.5, 1.rrand(3)).rhythm(0, 0, 1, [0.rrand(4),0,0,0])};

~funcs['a'][4] = {PZ_layer(~alarmclock, ~buffers['radio'][2], 0.rrand(8), 0.1.rrand(0.3), 0.01, 0.3, 1.rrand(4)).rhythm(0, 0, [0,1], 1)};

~notes = Pseq([~buffers['db'][5], ~buffers['db'][8], ~buffers['db'][5]].stutter(1), 2);
~notes2 = Pseq([~buffers['db'][2], ~buffers['db'][7], ~buffers['db'][1]].stutter(1), 2);
~phrase = Pseq([~notes++~notes2], inf).asStream;
~funcs['b'][0] = {PZ_layer(~samplerMono, ~phrase.next, 9, 0.8, 0.3, 0.2, 1).rhythm(1)};
b.beats = 1;

// v2 (faster)
t.tempo=1;
b.beats = 1/3;

~funcs['a'].do{|f, i| ~funcs['a'][i] = ();} // stop all a
~funcs['b'].do{|f, i| ~funcs['b'][i] = ();} // stop all b
~funcs['c'].do{|f, i| ~funcs['c'][i] = ();} // stop all c

//////////////////////////////////
//////// NOISE
//////////////////////////////////
// v1
~lfo = Ndef(\lfo, {LFNoise1.kr(3).range(0.1, 8)});
~lfo1 = Ndef(\lfo, {LFNoise1.kr(3).range(0.3, 2)});
~rit = {Dseq([1/16, 2, 1], inf)};
Ndef(\n, {HPF.ar(DynKlank.ar(`[~fm9*LFPulse.kr(Demand.kr(Impulse.kr(1), 0, ~rit)).range(2,4).lag(0.5), [1,1,1,1]/4, [1,1,1]/2], HPF.ar(WhiteNoise.ar(0.01)*LFPulse.kr(Demand.kr(Impulse.kr(1), 0, ~rit)).range(2,4).lag(0.1), 267)), 345)*EnvGen.kr(Env.linen(~lfo1, ~lfo, 2).circle(1), doneAction:2)}).play(0,2);
Ndef(\n).stop(6);

//v2
~lfo = Ndef(\lfo, {LFNoise1.kr(3).range(39, 38)});
~lfo1 = Ndef(\lfo, {LFNoise1.kr(3).range(0.3, 1)});
Ndef(\n, {HPF.ar(DynKlank.ar(`[[Demand.kr(Impulse.kr(1/14), 0, Dseq(~fm9*4, inf)).lag(0.4), Demand.kr(Impulse.kr(1/8), 0, Dseq(~em9*4, inf)).lag(0.4)], [1,1], [2,1]], LPF.ar(WhiteNoise.ar(LFNoise1.kr(1/4).range(0.1, 0.4)), 567)), 845)*EnvGen.kr(Env.linen(~lfo1, ~lfo, 2).circle(1), doneAction:2)}).play(0,2);

//v3 (arppeggio)
~lfo = Ndef(\lfo, {LFNoise1.kr(3).range(39, 38)});
~lfo1 = Ndef(\lfo, {LFNoise1.kr(3).range(0.3, 1)});
Ndef(\n, {HPF.ar(DynKlank.ar(`[[Demand.kr(Impulse.kr(1), 0, Dseq(~fm9*4, inf)).lag(0), Demand.kr(Impulse.kr(1), 0, Dseq((~fm9++~em9)*4, inf)).lag(0)], [1,1], [2,1]], LPF.ar(WhiteNoise.ar(LFNoise1.kr(1/4).range(0.3, 0.4)), 567)), 845)*EnvGen.kr(Env.linen(~lfo1, ~lfo, 2).circle(), doneAction:2)}).play(0,2);

// storm
Ndef(\s4).fadeTime_(3);
Ndef(\s, {BPF.ar(WhiteNoise.ar(0.8), LFNoise1.kr(1/2).range(100, 456), 0.2)}).play(0,1)
Ndef(\s).stop(4);
Ndef(\s1, {BPF.ar(WhiteNoise.ar(0.8), LFNoise1.kr(1/4).range(600, 1456), 0.2)}).play(1,1);
Ndef(\s2, {BPF.ar(WhiteNoise.ar(0.8), LFNoise1.kr(1).range(1600, 2456), 0.2)}).play(1,1);
Ndef(\s3, {BPF.ar(WhiteNoise.ar(0.9), LFNoise1.kr(1/2).range(100, 856), 0.2)}).play(0,1);
Ndef(\s4, {BPF.ar(WhiteNoise.ar(1), LFNoise1.kr(2).range(3100, 1856), 0.2)}).play(0,1);

// rain
Ndef(\s5, {BPF.ar(WhiteNoise.ar(1), LFNoise1.kr(1/8).range(200, 856), 0.5)}).play(1,1);
Ndef(\s6, {BPF.ar(WhiteNoise.ar(1), LFNoise1.kr(1/6).range(200, 1856), 0.8)}).play(0,1);
Ndef.all.do{|n| n.stop(8);};


//////////////////////////////////
//////// VOICE MESSAGES
//////////////////////////////////
//examples:
~voicemsg.(~buffers['dbs'][5], 0, 1); // arguments are: audio buffer, channel, amplitude
~voicemsg.(~buffers['sax'][2], 0, 1);

// example with other wav (your path will be diffrent!):
~mybuffer = Buffer.read(s, "/Users/narcodeb/Downloads/scene4_pappa.wav");
~voicemsg.(~mybuffer, 1, 1);


