<h1>MATLAB Mirco-Manager Handler</h1>

MATLAB class that allows operation of Canon EOS 550D and PI - E662 Z-stage through Micro-Manager library (java).
<br>

Current version allows the following operations:
<br>

<em>Snap:</em> shots a single image and retrieves it from the camera. SaveImg : saves retrieved image to the file specified.
<br>

<em>ZStack:</em> shots and saves a series of images at the z-positions specified.
<br>

<em>Timer:</em> performs a specified action (Snap or ZStack) for a specified number of cycles and interval.

<br>

<em>Arduino.cpp and Arduino.h</em> Modified Arduino device adapter for Micro-Manager that features xy-stage device.
 