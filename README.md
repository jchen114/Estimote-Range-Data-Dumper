# Estimote-Range-Data-Dumper
iOS app to dump the range data values so that they can be plotted and modeled

This app allows you to read rssi values and it dumps them into a file in the documents folder of the application. You can set the range and the application will create the corresponding file for that location. This is to see the variance of the values received from the rssi readings and to determine whether or not they can be applied to a location determining mechanism.

It seems from just viewing the values that the rssi values aren't a great determinator of how far the beacon is. I added the capability of displaying the zone as well, which are unknown, immediate, near, and far, but it seems like they wouldn't be a great resource for determining location.
