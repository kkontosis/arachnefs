# estruct

* single event in affected directory
  - file data event body
  - filename meta event header
  - filename meta autoincedtimestamp
  - filename meta xoritemhash
* code I propagated parent dir event in same level as dir name up to root dir
  - filename meta autoincedtimestamp
  - filename meta xordirhash
  - ? peer id
* code i only in root dir lazy with grace time and during login logout one per store
  - filename meta autoincedtimestamp
  - filename meta xordirhash
  - store id

## deletion eligibility

* for I events, satisfy 
  - at least 1 newer exists and includes all modifications of that event via XOR checksum detection
  - grace+1 expired
* for update events, satisfy
  - newer R event exists and includes all modifications of that event via XOR checksum detection, 
  - history+grace+1 expired, R-update timediff > grace2+1 expired, 
  - min importantknownstore timediff of an i event that includes this modification via XOR checksum detection, with R event has grace3+1 expired
