// CroneEngine_Delayyyyyyyy
// SuperCollider engine for delayyyyyyyy
// Taken from: https://sccode.org/1-1P8

Engine_Delayyyyyyyy : CroneEngine {
	var <synth;

	*new { arg context, doneCallback;
		^super.new(context, doneCallback);
	}

	alloc {
		synth = {
			arg inL, inR, out, length = 1, fb = 0.8, sep = 0.012;
			
			var l = Lag.kr(length, 0.2);
			var f = Lag.kr(fb, 0.2);
			var s = Lag.kr(sep, 0.2);
			
	    var input = [In.ar(inL), In.ar(inR)];
	    var feedback = LocalIn.ar(2);
	    var output = LeakDC.ar(feedback*f + input);
	    output = HPF.ar(output, 400);
	    output = LPF.ar(output, 5000);
	    output = output.tanh;

      // Note: .reverse causes the ping pong.
      // Could be nice to enable / disable?
	    LocalOut.ar(DelayC.ar(output, 1, LFNoise2.ar(12).range([l,l+s],[l+s,l])).reverse);
	    
			Out.ar(out, output);
		}.play(args: [
		  \inL, context.in_b[0].index,			
			\inR, context.in_b[1].index,
		  \out, context.out_b,
		  \length, 0.2,
		  \fb, 0.8,
		  \sep, 0.012
		], target: context.xg);

		this.addCommand("length", "f", { arg msg;
			synth.set(\length, msg[1]);
		});
		
		this.addCommand("fb", "f", { arg msg;
			synth.set(\fb, msg[1]);
		});
		
		this.addCommand("sep", "f", { arg msg;
			synth.set(\sep, msg[1]);
		});
	}

	free {
		synth.free;
	}
}
