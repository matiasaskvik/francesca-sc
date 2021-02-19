// pre-load
s.waitForBoot{
(
		~path_samples = thisProcess.nowExecutingPath.dirname ++ "/samples/";
		~buffers = ();
		~buffers['db'] = ();
		~buffers['radio'] = ();
		~buffers['sax'] = ();
		~buffers['dbp'] = ();
		~buffers['dbs'] = ();
		~buffers['dbsl'] = ();
		~buffers['dbplukk'] = ();

		2.do{|i|
			var index=i+1;
			~buffers['radio'][index] = Buffer.read(s, ~path_samples ++ "radio" ++index++".wav");
		};
		8.do{|i|
			var index=i+1;
			~buffers['db'][index] = Buffer.read(s, ~path_samples ++ "db"++index++".wav");
		};
		9.do{|i|
			var index=i+1;
			~buffers['sax'][index] = Buffer.read(s, ~path_samples ++ "sax"++index++".wav");
		};
		7.do{|i|
			var index=i+1;
			~buffers['dbp'][index] = Buffer.read(s, ~path_samples ++ "dbp"++index++".wav");
		};
		9.do{|i|
			var index=i+1;
			~buffers['dbs'][index] = Buffer.read(s, ~path_samples ++ "dbs"++index++".wav");
		};
		8.do{|i|
			var index=i+1;
			~buffers['dbsl'][index] = Buffer.read(s, ~path_samples ++ "dbsl"++index++".wav");
		};
		22.do{|i|
			var index=i+1;
			~buffers['dbplukk'][index] = Buffer.read(s, ~path_samples ++ "dbplukk"++index++".wav");
		};
		~buffers['voice_msg_start'] = Buffer.read(s, ~path_samples ++ "voice_message_start.wav");
		~buffers['voice_msg_end'] = Buffer.read(s, ~path_samples ++ "voice_message_end.wav");
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

~bass_random_dbs = { {PlayBuf.ar(1, ~buffers['dbs'][(1..9).choose], 1, doneAction: 2)}.play(s, (0..9).choose) };

~bass_random_dbsl = { {PlayBuf.ar(1, ~buffers['dbsl'][(1..8).choose], 1, doneAction: 2)}.play(s, (0..8).choose) };

~bass_random = { {PlayBuf.ar(1, ~buffers['dbplukk'][(1..22).choose], 1, doneAction: 2)}.play(s, (0..9).choose) };

		~alarmclock = {|buf, out=0, at=0.01, rl=3, amp=1, rate=2| {(PlayBuf.ar(2, buf, rate,1, BufFrames.kr(buf)*LFNoise0.kr(6).range(0, 1), doneAction: 2)*EnvGen.kr(Env.perc(at, rl))).sum*amp}.play(s, out) };

				~samplerMono = {|buf, out=0, at=0.01, rl=3, amp=1, rate=2| {(PlayBuf.ar(1, buf, rate,1, 0, doneAction: 2)*EnvGen.kr(Env.perc(at, rl)))*amp}.play(s, out) };

~sampler = { arg buf, loop, out=0, at=0.01, sust=0, rl=0.1, gate=1, rate=1, pos=0, amp=1, gap=0, trig=1, chans;
			var env;
			if (buf.numChannels == 2) {
				{arg gap=gap, at=at, rl=rl, sust=sust; PlayBuf.ar(2, buf, BufRateScale.kr(buf)*rate, trig, BufFrames.kr(buf)*pos, loop)*EnvGen.kr(Env.linen(at, sust, rl).circle(gap), gate, doneAction:2)}.play(s, out);
			} {
				{arg gap=gap, at=at, rl=rl, sust=sust; PlayBuf.ar(1, buf, BufRateScale.kr(buf)*rate, trig, BufFrames.kr(buf)*pos, loop)*EnvGen.kr(Env.linen(at, sust, rl).circle(gap), gate, doneAction:2)}.play(s, out);
			};
};

	~voicemsg = {|buf, out=0, amp=1|
			{
				~samplerMono.(~buffers['voice_msg_start'], out, 0.01, 4, amp);
				(~buffers['voice_msg_start'].duration - 0.3).wait;
				~bass.(buf, out);
				buf.duration.wait;
				~samplerMono.(~buffers['voice_msg_end'], out, 0.01, 4, amp);
			}.fork;
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


