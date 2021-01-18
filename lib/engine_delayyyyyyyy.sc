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
			arg inL, inR, out, length, feedback, modulation, wet;
			
			var l = Lag.kr(length, 0.2);
			var f = Lag.kr(feedback, 0.2);
			var m = Lag.kr(modulation, 0.2);
			
	    var input = SoundIn.ar([inL, inR]);
	    var fb = LocalIn.ar(2);
	    var output = LeakDC.ar(fb*f + input);
	    output = HPF.ar(output, 400);
	    output = LPF.ar(output, 5000);
	    output = output.tanh;
	    
	    output = DelayC.ar(output, 2.5, LFNoise2.ar(12).range([l,l+m],[l+m,l])).reverse;
	    LocalOut.ar(output);
	    
			Out.ar(out, LinXFade2.ar(input, output, wet));
		}.play(args: [
		  \inL, 0,
			\inR, 1,
		  \out, context.out_b,
		  \length, 0.2,
		  \feedback, 0.5,
		  \modulation, 0.0,
		  \wet, 0.0
		], target: context.xg);
		
		this.addCommand("inL", "i", { arg msg;
			synth.set(\inL, msg[1]);
		});
		
		this.addCommand("inR", "i", { arg msg;
			synth.set(\inR, msg[1]);
		});

		this.addCommand("length", "f", { arg msg;
			synth.set(\length, msg[1]);
		});
		
		this.addCommand("feedback", "f", { arg msg;
			synth.set(\feedback, msg[1]);
		});
		
		this.addCommand("modulation", "f", { arg msg;
			synth.set(\modulation, msg[1]);
		});
		
		this.addCommand("wet", "f", { arg msg;
			synth.set(\wet, msg[1]);
		});
	}

	free {
		synth.free;
	}
}
