// CroneEngine_Delayyyyyyyy
// SuperCollider engine for delayyyyyyyy
// Based on: https://sccode.org/1-1P8
Engine_Delayyyyyyyy : CroneEngine {
  var <synth;

  *new { arg context, doneCallback;
  ^super.new(context, doneCallback);
  }

  alloc {
    synth = {
      arg out, time = 0.4, feedback = 0.4, sep = 0, mix = 0;

      var t = Lag.kr(time, 0.2);
      var f = Lag.kr(feedback, 0.2);
      var s = Lag.kr(sep, 0.2);

      var input = SoundIn.ar([0, 0]);
      var fb = LocalIn.ar(2);
      var output = LeakDC.ar(fb * f + input);

      output = HPF.ar(output, 400);
      output = LPF.ar(output, 5000);
      output = output.tanh;

      output = DelayC.ar(output, 2.5, LFNoise2.ar(12).range([t, t + s], [t + s, t])).reverse;
      LocalOut.ar(output);

      Out.ar(out, LinXFade2.ar(input, output, mix));
    }.play(args: [\out, context.out_b], target: context.xg);

    this.addCommand("time", "f", { arg msg;
      synth.set(\time, msg[1]);
    });

    this.addCommand("feedback", "f", { arg msg;
      synth.set(\feedback, msg[1]);
    });

    this.addCommand("sep", "f", { arg msg;
      synth.set(\sep, msg[1]);
    });

    this.addCommand("mix", "f", { arg msg;
      synth.set(\mix, msg[1]);
    });
  }

  free {
    synth.free;
  }
}