These luts are designed to perform general useful operations on smpte2084 video

Endings
=======
The endsins encode a change in stop as well as any other transformation.
E.g.:
-----
1p00    -> increase 1 stop
-1p00   -> decrease 1 stop
-Native -> no stop change

Range
=====

luminance
=========

These luts only change the luminance - full range.

flog
====

These map the full range of flog to the full range of smpte2084.
Be warned that smpte2084 has a wider luminance range than flog so if the
incoming video take 100% of the flog range the resulting smpte2084 video migh have too much constrast.

So far, ingesting with the remap and then tweaking in grading seems to work the best so I am minded
to leave as is.

Note On flog:
-------------
At the moment the very bottom few values for flog input are all mapped pretty much to black.
I am not sure if this is correct or incorrect so leaving it for now - some experimentation on the black
gama might be required.


Brightness Effects
------------------

Luts can be used for a range of brightness and colour effects.
At the moment the effect_brighten and effect_curves scripts seem to cover these pretty well
so it is not clear that messing with luts for this is necessary.

Clearly, as new effects are wanted, this might change.

finish
======

Special luts for the final render to mapp to most of the output space as possible but take peak
brightness down. These are not 'correct' but level matched for finishing off to get a nice effect
based on the mastering information in the output scripts.

Currenly finish-4.cube is used. If the MPL were increased then maybe finish-3 or finish-3p5 could be
used for similar effects.

hdr-sdr
=======

hdr-sdr
-------

A mathemetically correct legal range conversion which works for mids and crushes out dark and highlights.

hdr-sdr-optimised
-----------------

An optimized conversion which will fit the luma so the middle 6 stops of HDR are mapped to the most linear
part of bt709. This reduces constrast whilst retaining the video quality as much as possible.

sdr-hdr
=======

Legal range conversion from the entire SDR bt709 range to hdr smpte2084. Should be close to an exact conversion
allowing the mid point to be correct.
