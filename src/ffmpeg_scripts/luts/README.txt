These luts are designed to perform general useful operations on smpte2084 video

Endings
=======
The endsins encode a change in stop as well as any other transformation.
E.g.:
-----
1p00    -> increase 1 stop
-1p00   -> decrease 1 stop
-Native -> no stop change

luminance
=========

These luts only change stop within the legal range.

luminance-uclipped
==================

These change luminance and are over the maximum digital range.
It is beter not to use these appart from final export etc where 100% white and 100% black
are things one wants.
Using these luts might cause the black level to drop and a slight darkening of the video.
I created them for music visualizations where an exported 'pc' range video black should be
absolutely black.

flog
====================

These map the full range of flog to the full range of smpte2084.
Be warned that smpte2084 has a wider luminance range than flog so if the
incoming video take 100% of the flog range the resulting smpte2084 video migh have too much constrast.

So far, ingesting with the remap and then tweaking in grading seems to work the best so I am minded
to leave as is.

boost-highs
===========

Add a knee to brigh up highlights. This can brighten up a dull video but can easily be overdone and
works best is mixed with  drop is stop as well.

Another, more flexible approach is just to use the effect_curves.sh script and bend the curve in any
way you want.

reduce-x
========

These reduce the dynamic range in a fairly even way.  The larger the number the bigger the effect.

power-xx
========

Add a power gamma of amount xx. This is a huge effect - make contrast much greater.

broken-rec709-flog-smpte2084
============================

This is used to demonstrate how if you import from fuji flog using the colour space it says it has
the colours come out all wrong. Don't use it unless you want super pink skin tones and purple
sky!
