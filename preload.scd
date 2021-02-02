// pre-load
s.waitForBoot{
(
		~path_samples = thisProcess.nowExecutingPath.dirname ++ "/samples/";
		~buffers = ();
		~buffers['db'] = ();
		~buffers['radio1'] = Buffer.read(s, ~path_samples ++ "radio1.wav");
		~buffers['radio2'] = Buffer.read(s, ~path_samples ++ "radio2.wav");
		8.do{|i|
			var index=i+1;
			~buffers['db'][index] = Buffer.read(s, ~path_samples ++ "db"++index++".wav");
		};
);

// chord progressions:
(
		~fm9 = ["f1".namecps, "ab1".namecps, "f1".namecps, "c1".namecps];
		~fM9 = ["f1".namecps, "a1".namecps, "c1".namecps, "c1".namecps];
		~aM9 = ["a1".namecps, "c#1".namecps, "e1".namecps, "B1".namecps];
		~am9 = ["a1".namecps, "c1".namecps, "e2".namecps, "g2".namecps];
		~cm9 = ["c1".namecps, "b1".namecps, "eb1".namecps, "d2".namecps];
		~cM9 = ["c1".namecps, "b1".namecps, "e1".namecps, "d2".namecps];
		~em9 = ["e1".namecps, "B0".namecps, "g1".namecps, "f1".namecps];
		~eM9 = ["e1".namecps, "g#1".namecps, "d1".namecps, "f2".namecps];
);

s.sync;
// synths
(
		SynthDef(\sampleNarcode, {|out=0, at=0.01, rl=0.1, gate=1, rate=1, pos=0, amp=1, gap=0, loop=0, buf, trig, chans|
			var snd, env;
			env = EnvGen.kr(Env.adsr(at, releaseTime: rl), gate, doneAction:2);
			snd = PlayBuf.ar(1, buf, BufRateScale.kr(buf)*rate, trig, BufFrames.kr(buf)*pos, loop);
			Out.ar(out, snd*amp*env);
	}).store;

			SynthDef(\sampleNarcodeStr, {|out=0, at=0.01, rl=0.1, gate=1, rate=1, pos=0, amp=1, gap=0, loop=0, buf, trig, chans|
			var snd, env;
			env = EnvGen.kr(Env.adsr(at, releaseTime: rl), gate, doneAction:2);
			snd = PlayBuf.ar(2, buf, BufRateScale.kr(buf)*rate, trig, BufFrames.kr(buf)*pos, loop);
			Out.ar(out, snd*amp*env);
	}).store;

		SynthDef(\surroundNarcode, {|out=0, at=0.01, rl=0.1, rate=1, panpos=0, amp=1, pos=1, buf|
			var env = EnvGen.kr(Env.perc(at, rl), doneAction:2);
			var snd, pan, chans;
				snd = PlayBuf.ar(2, buf, BufRateScale.kr(buf)*rate, 1, BufFrames.kr(buf)*pos)*env;
				pan = PanAz.ar(4, snd, panpos);
			Out.ar(out, pan*amp);
		}).store;

		SynthDef(\sampleNarcodeP, {|out=0, at=0.01, rl=0.1, gate=1, rate=1, pos=0, amp=1, gap=0, loop=0, buf, trig, chans|
			var snd, env;
			env = EnvGen.kr(Env.perc(at, releaseTime: rl), gate, doneAction:2);
			snd = PlayBuf.ar(1, buf, BufRateScale.kr(buf)*rate, trig, BufFrames.kr(buf)*pos, loop);
			Out.ar(out, snd*amp*env);
	}).store;

// synth functions
s.sync;
~bass = {|buf, chan=0| {PlayBuf.ar(1, buf, 1, doneAction: 2)}.play(s, chan) };

~bass_random = { {PlayBuf.ar(1, ~buffers['db'][(1..8).choose], 1, doneAction: 2)}.play(s, (0..7).choose) };

~alarmclock = {|buf, out=0| {PlayBuf.ar(2, ~buffers['radio1'], 1, BufFrames.kr(~buffers['radio1'])*LFNoise1.kr(1).range(0, 1), doneAction: 2)*EnvGen.kr(Env.perc(0.1, 3))*8}.play(s, (0..7).choose) };

~sampler = { arg buf, loop, out=0, at=0.01, sust=0, rl=0.1, gate=1, rate=1, pos=0, amp=1, gap=0, trig=1, chans;
			var env;
			if (buf.numChannels == 2) {
				{arg gap=gap, at=at, rl=rl, sust=sust; PlayBuf.ar(2, buf, BufRateScale.kr(buf)*rate, trig, BufFrames.kr(buf)*pos, loop)*EnvGen.kr(Env.linen(at, sust, rl).circle(gap), gate, doneAction:2)}.play(s, out);
			} {
				{arg gap=gap, at=at, rl=rl, sust=sust; PlayBuf.ar(1, buf, BufRateScale.kr(buf)*rate, trig, BufFrames.kr(buf)*pos, loop)*EnvGen.kr(Env.linen(at, sust, rl).circle(gap), gate, doneAction:2)}.play(s, out);
			};
};

);

// dics
	s.sync;
	~revs = ();
	~fxs = ();
	~funcs = ();
	 ~funcs['a'] = ();
		~funcs['b'] = ();
		~funcs['c'] = ();
	~swoosh = ();
	~radio = ();
	~swooshshift = ();
	s.sync;

// globals
	s.sync;
	a = PZ_machine(s);
	b = PZ_machine(s);
	c = PZ_machine(s);
	s.sync;

// PZ_machine

	a.routine.source = {	inf.do{
		s.bind{
			~funcs['a'].do{|f| f.(); };
		};
		(a.beats).wait;
	} };

	b.routine.source = {	inf.do{
		s.bind{
			// audio
			~funcs['b'].do{|f| f.(); };
		};
		(b.beats).wait; // must be dynamic
	} };

	c.routine.source = {	inf.do{
		s.bind{
			// audio
			~funcs['c'].do{|f| f.(); };
		};
		(c.beats).wait; // must be dynamic
	} };

	s.sync;
	"Preload complete".postln;
}


